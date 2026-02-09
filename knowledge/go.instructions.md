# Go Development Standards

## Project Structure

Follow standard Go project layout:

- `cmd/` - main applications
- `internal/` - private packages (not importable by other modules)
- `pkg/` - public library code (if applicable)
- Keep `main.go` thin - parse flags, wire dependencies, call `run()`

## Error Handling

- Always handle errors explicitly. Never use `_` for errors.
- Wrap errors with context: `fmt.Errorf("creating user: %w", err)`
- Use sentinel errors for expected conditions: `var ErrNotFound = errors.New("not found")`
- Use `errors.Is()` and `errors.As()` for error checking, not string comparison
- Return early on errors - avoid deep nesting

```go
// Good
if err := doThing(); err != nil {
    return fmt.Errorf("doing thing: %w", err)
}
// continue with happy path...

// Bad - deep nesting
if err := doThing(); err == nil {
    // success path buried in nesting
}
```

## Concurrency

- Always pass `context.Context` as the first parameter for cancellable operations
- Use `errgroup` for coordinating goroutines with error propagation
- Protect shared state with `sync.Mutex` or prefer channel-based communication
- Use `sync.Once` for one-time initialization
- Always handle goroutine lifecycle - no fire-and-forget goroutines in production
- Use `select` with `ctx.Done()` for cancellation in long-running operations

```go
g, ctx := errgroup.WithContext(ctx)
for _, item := range items {
    g.Go(func() error {
        return process(ctx, item)
    })
}
if err := g.Wait(); err != nil {
    return fmt.Errorf("processing items: %w", err)
}
```

## Interfaces

- Define interfaces at the consumer, not the producer
- Keep interfaces small (1-3 methods)
- Accept interfaces, return concrete types
- Use `io.Reader`, `io.Writer`, `fmt.Stringer` when appropriate

## Testing

- Use table-driven tests for comprehensive coverage
- Name test cases descriptively: `"returns error when user not found"`
- Use `testify/assert` and `testify/require` for readable assertions
- Use `t.Helper()` in test helper functions
- Use `t.Parallel()` for independent tests
- Benchmarks: `BenchmarkXxx(b *testing.B)` with `b.ResetTimer()` after setup

```go
func TestCreateUser(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateUserInput
        want    *User
        wantErr error
    }{
        {
            name:  "valid input creates user",
            input: CreateUserInput{Name: "Alice", Email: "alice@example.com"},
            want:  &User{Name: "Alice", Email: "alice@example.com"},
        },
        {
            name:    "empty name returns error",
            input:   CreateUserInput{Email: "alice@example.com"},
            wantErr: ErrNameRequired,
        },
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := CreateUser(tt.input)
            if tt.wantErr != nil {
                require.ErrorIs(t, err, tt.wantErr)
                return
            }
            require.NoError(t, err)
            assert.Equal(t, tt.want.Name, got.Name)
        })
    }
}
```

## Performance

- Profile before optimizing: `go tool pprof`
- Use `sync.Pool` for frequently allocated objects
- Preallocate slices when size is known: `make([]T, 0, expectedLen)`
- Avoid string concatenation in loops - use `strings.Builder`
- Use pointer receivers for large structs, value receivers for small ones
- Benchmark with `go test -bench=. -benchmem`
- Use `go vet` and `staticcheck` for static analysis

## HTTP Services

- Use `http.Server` with explicit timeouts (ReadTimeout, WriteTimeout, IdleTimeout)
- Graceful shutdown with `server.Shutdown(ctx)`
- Middleware pattern for cross-cutting concerns (logging, auth, recovery)
- Use `http.Handler` interface, not framework-specific abstractions
- Structured logging with `slog`

## Dependencies

- Keep `go.mod` clean: `go mod tidy`
- Vendor dependencies for reproducible builds when needed
- Prefer stdlib over third-party when the stdlib solution is adequate
- Pin major versions in `go.mod`

## Common Pitfalls

- **Goroutine leaks:** Always ensure goroutines can exit
- **Nil pointer:** Check interface values, not just nil
- **Slice append:** Understand when append creates new backing array
- **Map concurrency:** Maps are NOT safe for concurrent read/write
- **Deferred Close:** Check error from `defer f.Close()` on writes
- **Context propagation:** Always pass context through the call chain
