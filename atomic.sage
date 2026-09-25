gc_disable()
# Native atomic operations for threaded execution
# Provides compare-and-swap, atomic counters, and spin locks

# ============================================================================
# Atomic integer
# ============================================================================

proc atomic_int(initial):
    return atomic_new(initial)

@inline
proc load(atom):
    return atomic_load(atom)

@inline
proc store(atom, value):
    return atomic_store(atom, value)

@inline
proc add(atom, delta):
    atomic_add(atom, delta)
    return atomic_load(atom)

@inline
proc sub(atom, delta):
    atomic_add(atom, 0 - delta)
    return atomic_load(atom)

@inline
proc increment(atom):
    return add(atom, 1)

@inline
proc decrement(atom):
    return sub(atom, 1)

# Compare-and-swap: if current == expected, set to new_val, return old
proc cas(atom, expected, new_val):
    return atomic_cas(atom, expected, new_val)

proc exchange(atom, new_val):
    return atomic_exchange(atom, new_val)

# ============================================================================
# Atomic flag (boolean)
# ============================================================================

proc atomic_flag():
    return atomic_new(0)

@inline
proc test_and_set(flag):
    return atomic_exchange(flag, 1) == 1

@inline
proc clear_flag(flag):
    atomic_store(flag, 0)

# ============================================================================
# Spin lock (based on atomic flag)
# ============================================================================

proc create_spinlock():
    return atomic_new(0)

proc spin_lock(lock):
    while not atomic_cas(lock, 0, 1):
        pass

proc spin_unlock(lock):
    atomic_store(lock, 0)

proc spin_try_lock(lock):
    return atomic_cas(lock, 0, 1)

@inline
proc is_locked(lock):
    return atomic_load(lock) != 0

# ============================================================================
# Atomic counter with stats
# ============================================================================

proc counter(name):
    let c = {}
    c["name"] = name
    c["value"] = 0
    c["max"] = 0
    c["min"] = 0
    c["ops"] = 0
    return c

proc counter_add(c, delta):
    c["value"] = c["value"] + delta
    c["ops"] = c["ops"] + 1
    if c["value"] > c["max"]:
        c["max"] = c["value"]
    if c["value"] < c["min"]:
        c["min"] = c["value"]
    return c["value"]

proc counter_reset(c):
    c["value"] = 0
    c["ops"] = 0

proc counter_stats(c):
    let s = {}
    s["name"] = c["name"]
    s["value"] = c["value"]
    s["max"] = c["max"]
    s["min"] = c["min"]
    s["ops"] = c["ops"]
    return s

# ============================================================================
# Memory ordering constants (documentation only — Sage is single-threaded)
# ============================================================================

comptime:
    let RELAXED = 0
    let ACQUIRE = 1
    let RELEASE = 2
    let ACQ_REL = 3
    let SEQ_CST = 4
