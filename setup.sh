#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

ZSHRC="${HOME}/.zshrc"
MCP_DIR="${HOME}/.local/share/mcp"

info "Starting OpenCode MCP setup..."
echo ""

# =============================================================================
# Dependencies
# =============================================================================
install_uv() {
    if command -v uv &>/dev/null; then
        success "uv already installed"
        return 0
    fi
    
    info "Installing uv..."
    brew install uv
    success "uv installed"
}

# =============================================================================
# GitHub Token
# =============================================================================
setup_github_token() {
    # Check if already set in environment or zshrc
    if grep -q "export GITHUB_PERSONAL_ACCESS_TOKEN=" "$ZSHRC" 2>/dev/null; then
        success "GitHub token already configured in $ZSHRC"
        return 0
    fi
    
    if [[ -n "${GITHUB_PERSONAL_ACCESS_TOKEN:-}" ]]; then
        success "GitHub token already set in environment"
        return 0
    fi
    
    echo ""
    info "GitHub MCP requires a Personal Access Token"
    echo "  Create one at: https://github.com/settings/tokens"
    echo "  Required scopes: repo, read:org, read:user"
    echo ""
    
    read -rp "Enter your GitHub Personal Access Token (or press Enter to skip): " token
    
    if [[ -z "$token" ]]; then
        warn "Skipped GitHub token setup. GitHub MCP won't work until configured."
        return 0
    fi
    
    # Validate token format (basic check)
    if [[ ! "$token" =~ ^gh[ps]_[a-zA-Z0-9]{36,}$ ]] && [[ ! "$token" =~ ^github_pat_ ]]; then
        warn "Token format looks unusual. Saving anyway..."
    fi
    
    # Add to zshrc
    echo "" >> "$ZSHRC"
    echo "# GitHub Personal Access Token for MCP" >> "$ZSHRC"
    echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\"$token\"" >> "$ZSHRC"
    
    # Export for current session
    export GITHUB_PERSONAL_ACCESS_TOKEN="$token"
    
    success "GitHub token saved to $ZSHRC"
}

# =============================================================================
# CVE-Search MCP
# =============================================================================
setup_cve_search_mcp() {
    local repo_dir="${MCP_DIR}/cve-search_mcp"
    
    mkdir -p "$MCP_DIR"
    
    if [[ -d "$repo_dir" ]]; then
        info "Updating cve-search_mcp..."
        git -C "$repo_dir" pull --quiet
    else
        info "Cloning cve-search_mcp..."
        git clone --quiet https://github.com/roadwy/cve-search_mcp "$repo_dir"
    fi
    
    info "Installing cve-search_mcp dependencies..."
    (cd "$repo_dir" && uv sync --quiet)
    
    success "cve-search_mcp ready"
}

# =============================================================================
# Verify npx MCPs
# =============================================================================
verify_npx_mcps() {
    info "Pre-caching npx MCP packages..."
    
    # These will be cached for faster startup
    npx -y @shopify/dev-mcp@latest --version &>/dev/null 2>&1 || true
    npx -y chrome-devtools-mcp@latest --help &>/dev/null 2>&1 || true
    
    success "NPX packages cached"
}

# =============================================================================
# Docker images
# =============================================================================
pull_docker_images() {
    if ! command -v docker &>/dev/null; then
        warn "Docker not available, skipping image pull"
        return 0
    fi
    
    if ! docker info &>/dev/null 2>&1; then
        warn "Docker daemon not running, skipping image pull"
        return 0
    fi
    
    info "Pulling GitHub MCP Docker image..."
    docker pull ghcr.io/github/github-mcp-server:latest --quiet || warn "Failed to pull GitHub MCP image"
    
    success "Docker images ready"
}

# =============================================================================
# Summary
# =============================================================================
print_summary() {
    echo ""
    echo "=============================================="
    echo -e "${GREEN}OpenCode MCP Setup Complete${NC}"
    echo "=============================================="
    echo ""
    echo "Configured MCP servers:"
    echo "  • shopify      - Shopify dev tools (npx)"
    echo "  • chrome-devtools - Chrome DevTools (npx)"
    echo "  • github       - GitHub API (Docker)"
    echo "  • cve-search   - CVE database search (uv)"
    echo ""
    
    if [[ -z "${GITHUB_PERSONAL_ACCESS_TOKEN:-}" ]]; then
        echo -e "${YELLOW}Note:${NC} GitHub token not configured. Run this script again or add manually:"
        echo "  export GITHUB_PERSONAL_ACCESS_TOKEN=\"your_token\""
        echo ""
    fi
    
    echo "Restart your terminal or run:"
    echo "  source $ZSHRC"
    echo ""
}

# =============================================================================
# Main
# =============================================================================
main() {
    install_uv
    setup_github_token
    setup_cve_search_mcp
    verify_npx_mcps
    pull_docker_images
    print_summary
}

main "$@"
