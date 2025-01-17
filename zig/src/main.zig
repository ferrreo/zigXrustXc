const std = @import("std");

pub fn sieve_of_eratosthenes(n: usize, allocator: std.mem.Allocator) !usize {
    var arr = try allocator.alloc(bool, n + 1);

    arr[0] = false;
    arr[1] = false;

    for (arr) |*e| e.* = true;

    var i: f64 = 2;
    const n_float: f64 = @floatFromInt(n);
    while (i < @sqrt(n_float)) : (i += 1) {
        if (arr[@intFromFloat(i)]) {
            var j: f64 = i * i;
            while (j <= n_float) : (j += i) {
                arr[@intFromFloat(j)] = false;
            }
        }
    }

    var count: usize = 0;
    for (arr) |e| {
        if (e) {
            count += 1;
        }
    }

    return count - 2;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const args = try std.process.argsAlloc(allocator);

    const first_arg = args[1];

    const n = try std.fmt.parseInt(usize, first_arg, 10);

    const primes = try sieve_of_eratosthenes(n, allocator);

    try stdout.print("Primes up to {d} are: {d}\n", .{ n, primes });
}
