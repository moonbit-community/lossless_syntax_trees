// Simple test to verify basic functionality

test "basic trivia creation" {
    let ws = whitespace_trivia("   ")
    let comment = comment_trivia("// test")
    let newline = newline_trivia("\n")
    
    if !is_whitespace_trivia(ws) { panic() }
    if !is_comment_trivia(comment) { panic() }
    if !is_newline_trivia(newline) { panic() }
}

test "basic token creation" {
    let leading = [whitespace_trivia(" ")]
    let trailing = [newline_trivia("\n")]
    let token = make_token("hello", leading, trailing)
    
    if syntax_kind(token) != "token" { panic() }
    if syntax_text(token) != "hello" { panic() }
    if !is_token(token) { panic() }
    if is_missing(token) { panic() }
}

test "basic node creation" {
    let children = [
        make_token("child1", [], []),
        make_token("child2", [], []),
        make_token("child3", [], [])
    ]
    let node = make_node(children, [], [])
    
    if syntax_kind(node) != "node" { panic() }
    if !is_node(node) { panic() }
    if child_count(node) != 3 { panic() }
}

test "missing and error nodes" {
    let missing = make_missing()
    if syntax_kind(missing) != "missing" { panic() }
    if !is_missing(missing) { panic() }
    if is_complete(missing) { panic() }
    
    let error = make_error("test error")
    if syntax_kind(error) != "error" { panic() }
    if !is_error(error) { panic() }
    if syntax_text(error) != "test error" { panic() }
}

test "text reconstruction" {
    let leading = [whitespace_trivia("  ")]
    let trailing = [newline_trivia("\n")]
    let token = make_token("hello", leading, trailing)
    
    let reconstructed = rebuild_text(token)
    if reconstructed != "  hello\n" { panic() }
}

test "syntax wrapper" {
    let raw = make_token("test", [], [])
    let wrapped = syntax(raw, "Identifier")
    
    if node_type(wrapped) != "Identifier" { panic() }
    
    let unwrapped = raw_syntax(wrapped)
    if syntax_text(unwrapped) != "test" { panic() }
}

test "builder pattern" {
    let builder = new_builder()
    let builder1 = add_child(builder, make_token("var", [], []))
    let builder2 = add_child(builder1, make_token("x", [], []))
    let builder3 = add_leading_trivia(builder2, whitespace_trivia("  "))
    let builder4 = add_trailing_trivia(builder3, newline_trivia("\n"))
    
    let assignment = build_from_builder(builder4, "assignment", "")
    
    if syntax_kind(assignment) != "assignment" { panic() }
    if child_count(assignment) != 2 { panic() }
    // Test trivia counts by checking if arrays are not empty
    let leading = leading_trivia(assignment)
    let trailing = trailing_trivia(assignment)
    if leading.length() == 0 { panic() }
    if trailing.length() == 0 { panic() }
}

test "with APIs" {
    let original = make_token("test", [], [])
    
    let with_text = with_text(original, "modified")
    if syntax_text(with_text) != "modified" { panic() }
    
    let with_leading = with_leading_trivia(original, [whitespace_trivia("  ")])
    let leading = leading_trivia(with_leading)
    if leading.length() == 0 { panic() }
    
    let with_trailing = with_trailing_trivia(original, [newline_trivia("\n")])
    let trailing = trailing_trivia(with_trailing)
    if trailing.length() == 0 { panic() }
}

test "tree analysis basic" {
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let node = make_node(children, [], [])
    
    if is_leaf_node(node) { panic() }
    
    let token = make_token("test", [], [])
    if !is_leaf_node(token) { panic() }
}

test "search functions" {
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let node = make_node(children, [], [])
    
    let results = find_nodes_of_kind(node, "node")
    if results.length() == 0 { panic() }
    
    let token = make_token("hello", [], [])
    let token_results = find_tokens_with_text(token, "hello")
    if token_results.length() == 0 { panic() }
}

test "tree traversal" {
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let node = make_node(children, [], [])
    
    let preorder = preorder_traversal(node)
    if preorder.length() == 0 { panic() }
    
    let postorder = postorder_traversal(node)
    if postorder.length() == 0 { panic() }
    
    let breadth_first = breadth_first_traversal(node)
    if breadth_first.length() == 0 { panic() }
}

test "validation and counting" {
    let valid_node = make_token("test", [], [])
    let errors = validate_syntax_tree(valid_node)
    if errors != [] { panic() }
    
    let missing_node = make_missing()
    let missing_errors = validate_syntax_tree(missing_node)
    if missing_errors == [] { panic() }
    
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let node = make_node(children, [], [])
    let node_count = count_nodes(node)
    if node_count != 3 { panic() }
    
    let token = make_token("hello", [], [])
    let token_count = count_tokens(token)
    if token_count != 1 { panic() }
}

test "advanced trivia functions" {
    let leading = [whitespace_trivia("  "), newline_trivia("\n")]
    let trailing = [comment_trivia("// comment")]
    let token = make_token("test", leading, trailing)
    
    if !has_newline_trivia(token) { panic() }
    
    let comment_count = count_comment_trivia(token)
    if comment_count != 1 { panic() }
    
    let all_trivia = extract_all_trivia(token)
    if all_trivia.length() == 0 { panic() }
}

test "node manipulation" {
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let node = make_node(children, [], [])
    
    let with_inserted = insert_child(node, 1, make_token("inserted", [], []))
    if child_count(with_inserted) != 3 { panic() }
    
    let with_appended = append_child(node, make_token("appended", [], []))
    if child_count(with_appended) != 3 { panic() }
    
    let with_prepended = prepend_child(node, make_token("prepended", [], []))
    if child_count(with_prepended) != 3 { panic() }
}

test "error recovery" {
    let error_node = create_error_recovery_node("identifier", "keyword")
    if !is_error(error_node) { panic() }
    
    let token = make_token("test", [], [])
    let wrapped = wrap_in_error_recovery(token, "test context")
    let leading = leading_trivia(wrapped)
    if leading.length() == 0 { panic() }
}

test "performance optimization" {
    let leading = [whitespace_trivia(" "), whitespace_trivia(" "), comment_trivia("// test")]
    let token = make_token("test", leading, [])
    
    let optimized = optimize_trivia(token)
    let optimized_leading = leading_trivia(optimized)
    if optimized_leading.length() == 0 { panic() }
}

test "child access functions" {
    // Test first_child and last_child
    let children = [make_token("first", [], []), make_token("middle", [], []), make_token("last", [], [])]
    let node = make_node(children, [], [])
    
    let first = first_child(node)
    match first {
        None => panic()
        Some(child) => if syntax_text(child) != "first" { panic() }
    }
    
    let last = last_child(node)
    match last {
        None => panic()
        Some(child) => if syntax_text(child) != "last" { panic() }
    }
    
    // Test empty node
    let empty_node = make_node([], [], [])
    let empty_first = first_child(empty_node)
    match empty_first {
        None => () // Expected
        Some(_) => panic()
    }
    
    let empty_last = last_child(empty_node)
    match empty_last {
        None => () // Expected
        Some(_) => panic()
    }
}

test "with_child function" {
    let children = [make_token("child1", [], []), make_token("child2", [], []), make_token("child3", [], [])]
    let node = make_node(children, [], [])
    
    // Replace child at index 1
    let modified = with_child(node, 1, make_token("new_child", [], []))
    if child_count(modified) != 3 { panic() }
    let new_children = syntax_children(modified)
    let mid = new_children[1]
    if syntax_text(mid) != "new_child" { panic() }
}

test "advanced search functions" {
    // Test find_error_nodes
    let error_node = make_error("syntax error")
    let errors = find_error_nodes(error_node)
    if errors.length() == 0 { panic() }
    
    // Test find_tokens_with_text
    let token = make_token("target", [], [])
    let found_tokens = find_tokens_with_text(token, "target")
    if found_tokens.length() == 0 { panic() }
}

test "tree depth and width analysis" {
    // Test single node depth
    let leaf = make_token("leaf", [], [])
    let depth = get_node_depth(leaf)
    if depth != 1 { panic() }
    
    let width = get_tree_width(leaf)
    if width != 1 { panic() }
    
    // Test nested structure
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let parent = make_node(children, [], [])
    let parent_depth = get_node_depth(parent)
    if parent_depth <= 1 { panic() }
    
    let parent_width = get_tree_width(parent)
    if parent_width <= 1 { panic() }
}

test "leaf node collection" {
    // Test leaf node detection and collection
    let token = make_token("leaf", [], [])
    if !is_leaf_node(token) { panic() }
    
    let leaves = get_all_leaf_nodes(token)
    if leaves.length() == 0 { panic() }
    
    // Test with nested structure
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let parent = make_node(children, [], [])
    let all_leaves = get_all_leaf_nodes(parent)
    if all_leaves.length() == 0 { panic() }
}

test "validation edge cases" {
    // Test empty node validation
    let empty_text_node = make_node([], [], [])
    let empty_errors = validate_syntax_tree(empty_text_node)
    if empty_errors.length() == 0 { panic() }
    
    // Test nested validation
    let children = [make_token("child", [], [])]
    let nested_node = make_node(children, [], [])
    let nested_errors = validate_syntax_tree(nested_node)
    if nested_errors != [] { panic() }
}

test "trivia edge cases" {
    // Test trailing trivia with newlines
    let trailing = [newline_trivia("\n"), comment_trivia("// test")]
    let token = make_token("test", [], trailing)
    
    if !has_newline_trivia(token) { panic() }
    
    // Test leading comment count
    let leading = [comment_trivia("// first"), whitespace_trivia(" "), comment_trivia("// second")]
    let comment_token = make_token("test", leading, [])
    let count = count_comment_trivia(comment_token)
    if count != 2 { panic() }
    
    // Test trivia extraction
    let all_trivia = extract_all_trivia(comment_token)
    if all_trivia == [] { panic() }
}

test "trivia optimization edge cases" {
    // Test optimization with only whitespace
    let all_whitespace = [whitespace_trivia(" "), whitespace_trivia("  "), whitespace_trivia("\t")]
    let token = make_token("test", all_whitespace, [])
    let optimized = optimize_trivia(token)
    let opt_leading = leading_trivia(optimized)
    
    // Should be optimized to single whitespace trivia
    if opt_leading == [] { panic() }
}

test "advanced counting functions" {
    // Test token counting
    let token = make_token("token1", [], [])
    let token_count = count_tokens(token)
    if token_count != 1 { panic() }
    
    // Test node counting
    let children = [make_token("child1", [], []), make_token("child2", [], [])]
    let node = make_node(children, [], [])
    let node_count = count_nodes(node)
    if node_count == 0 { panic() }
}

test "remove child functionality" {
    let children = [make_token("first", [], []), make_token("second", [], []), make_token("third", [], [])]
    let node = make_node(children, [], [])
    
    // Remove middle child
    let removed = remove_child(node, 1)
    if child_count(removed) != 2 { panic() }
    
    // Remove first child
    let removed_first = remove_child(node, 0)
    if child_count(removed_first) != 2 { panic() }
    
    // Remove last child
    let removed_last = remove_child(node, 2)
    if child_count(removed_last) != 2 { panic() }
}

test "recursive search with nested nodes" {
    // Create nested structure to test recursive search
    let inner_children = [make_token("inner_token", [], [])]
    let inner_node = make_node(inner_children, [], [])
    
    let outer_children = [inner_node, make_token("outer_token", [], [])]
    let outer_node = make_node(outer_children, [], [])
    
    // Test recursive token search
    let found_tokens = find_tokens_with_text(outer_node, "inner_token")
    if found_tokens.length() == 0 { panic() }
    
    // Test recursive error node search
    let error_children = [make_error("nested_error")]
    let error_container = make_node(error_children, [], [])
    let found_errors = find_error_nodes(error_container)
    if found_errors.length() == 0 { panic() }
}

test "recursive trivia extraction" {
    // Test trivia extraction with nested structure
    let token_with_trivia = make_token("test", [comment_trivia("// comment")], [])
    let children = [token_with_trivia]
    let nested_node = make_node(children, [], [])
    
    // This should trigger recursive trivia extraction
    let all_trivia = extract_all_trivia(nested_node)
    if all_trivia.length() == 0 { panic() }
}

test "recursive token counting" {
    // Test recursive token counting with nested structure
    let token = make_token("nested_token", [], [])
    let children = [token]
    let container = make_node(children, [], [])
    
    // This should trigger recursive token counting
    let count = count_tokens(container)
    if count != 1 { panic() } // One token inside container
}

test "insert edge cases" {
    // Test inserting at the end of array (to trigger the edge case)
    let children = [make_token("first", [], []), make_token("second", [], [])]
    let node = make_node(children, [], [])
    
    // Insert at the end (index == array length)
    let inserted_at_end = insert_child(node, 2, make_token("last", [], []))
    if child_count(inserted_at_end) != 3 { panic() }
}

test "lossless print normalization" {
    let builder = new_builder()
    let b1 = add_child(builder, make_token("a", [], []))
    let b2 = add_child(b1, make_token("b", [], []))
    let b3 = add_leading_trivia(b2, whitespace_trivia(" "))
    let b4 = add_trailing_trivia(b3, newline_trivia("\n"))
    let node = build_from_builder(b4, "node", "")

    let plain = rebuild_text(node)
    if plain != "ab" { panic() }

    let printed = lossless_print(node)
    if printed != " ab\n" { panic() }
}

test "strict trivia normalization - move trailing newline to next leading" {
    // token1 has trailing: [whitespace, newline, comment]
    let t1 = make_token("a", [], [whitespace_trivia(" "), newline_trivia("\n"), comment_trivia("// after")])
    // token2 has leading: [whitespace]
    let t2 = make_token("b", [whitespace_trivia(" ")], [])
    let node = make_node([t1, t2], [], [])

    let printed_before = lossless_print(node)
    if printed_before != "a \n// after b" { panic() }

    let strict_node = normalize_trivia_ownership_strict(node)
    let tokens = collect_tokens(strict_node)
    let first = tokens[0]
    let second = tokens[1]

    // After strict: first trailing should only keep inline whitespace (no newline)
    let first_trailing = trailing_trivia(first)
    if first_trailing.length() != 1 { panic() }
    if !is_whitespace_trivia(first_trailing[0]) { panic() }

    // Second leading should start with newline then comment then its original whitespace
    let second_leading = leading_trivia(second)
    if second_leading.length() != 3 { panic() }
    if !is_newline_trivia(second_leading[0]) { panic() }
    if !is_comment_trivia(second_leading[1]) { panic() }
    if !is_whitespace_trivia(second_leading[2]) { panic() }

    // Text must be identical
    let printed_after = lossless_print_strict(node)
    if printed_after != "a \n// after b" { panic() }
}

test "strict trivia normalization - move leading w/o newline back to previous trailing" {
    let t1 = make_token("x", [], [])
    let t2 = make_token("y", [whitespace_trivia("  "), comment_trivia("// c")], [])
    let node = make_node([t1, t2], [], [])

    let before = lossless_print(node)
    if before != "x  // cy" { panic() }

    let strict = normalize_trivia_ownership_strict(node)
    let toks = collect_tokens(strict)
    let first = toks[0]
    let second = toks[1]

    // Second leading should be empty (no newline originally)
    if leading_trivia(second).length() != 0 { panic() }
    // First trailing should contain the moved two trivia pieces
    let ft = trailing_trivia(first)
    if ft.length() != 2 { panic() }
    if !is_whitespace_trivia(ft[0]) { panic() }
    if !is_comment_trivia(ft[1]) { panic() }

    let after = lossless_print_strict(node)
    if after != "x  // cy" { panic() }
}


// New tests for offsets, equality, path finding and replacement

test "offset computation and lookup" {
    let t1 = make_token("a", [whitespace_trivia(" ")], [comment_trivia("// c")])
    let t2 = make_token("b", [newline_trivia("\n")], [])
    let node = make_node([t1, t2], [], [])

    // Offsets for lossless_print
    let printed = lossless_print(node)
    if printed == "" { panic() }

    let ranges = compute_token_offsets(node)
    if ranges.length() != 2 { panic() }
    // start of first token should be 0
    if ranges[0].1 != 0 { panic() }
    // end must be a positive offset
    let total = ranges[1].2
    if total <= 0 { panic() }

    // Lookup
    match find_token_at_offset(node, 0) {
        None => panic()
        Some(tok) => if syntax_text(tok) != "a" { panic() }
    }
}

test "structural equality" {
    let a = make_node([make_token("x", [], [])], [], [])
    let b = make_node([make_token("x", [], [])], [], [])
    if !structural_equal(a, b) { panic() }

    let c = make_node([make_token("y", [], [])], [], [])
    if structural_equal(a, c) { panic() }
}

test "find path to token text and get by path" {
    let inner = make_node([make_token("leaf", [], [])], [], [])
    let root = make_node([make_token("head", [], []), inner], [], [])

    match find_path_to_token_text(root, "leaf") {
        None => panic()
        Some(path) => {
            match get_node_by_path(root, path) {
                None => panic()
                Some(node) => if syntax_text(node) != "leaf" { panic() }
            }
        }
    }
}

test "replace tokens text recursive" {
    let root = make_node([make_token("x", [], []), make_node([make_token("x", [], [])], [], [])], [], [])
    let updated = replace_tokens_text(root, "x", "y")

    let found = find_tokens_with_text(updated, "y")
    if found.length() != 2 { panic() }
    let not_found = find_tokens_with_text(updated, "x")
    if not_found.length() != 0 { panic() }
}

test "strict trivia validator" {
    let t1 = make_token("a", [], [newline_trivia("\n")])
    let t2 = make_token("b", [], [])
    let node = make_node([t1, t2], [], [])

    let strict = normalize_trivia_ownership_strict(node)
    let errs = validate_trivia_ownership_strict(strict)
    if errs.length() != 0 { panic() }
}

test "replace node by path" {
    let inner = make_node([make_token("leaf", [], [])], [], [])
    let root = make_node([make_token("head", [], []), inner], [], [])

    match find_path_to_token_text(root, "leaf") {
        None => panic()
        Some(path) => {
            let replaced = replace_node_by_path(root, path, make_token("LEAF", [], []))
            match find_path_to_token_text(replaced, "LEAF") {
                None => panic()
                Some(_) => ()
            }
        }
    }
}

test "extended trivia kinds" {
    let t = make_token(
        "x",
        [shebang_trivia("#!/usr/bin/env x\n"), doc_comment_trivia("/// doc"), whitespace_trivia(" ")],
        [block_comment_trivia("/* c */")]
    )
    // basic sanity
    let l = leading_trivia(t)
    let r = trailing_trivia(t)
    if l.length() == 0 { panic() }
    if r.length() == 0 { panic() }
    if !is_shebang_trivia(l[0]) { panic() }
    if !is_doc_comment_trivia(l[1]) { panic() }
    if !is_block_comment_trivia(r[0]) { panic() }
}

test "additional path utilities" {
    let inner = make_node([make_token("leaf", [], []), make_token("leaf", [], [])], [], [])
    let root = make_node([inner, make_token("tail", [], [])], [], [])

    // all paths to text
    let paths = find_paths_to_token_text_all(root, "leaf")
    if paths.length() != 2 { panic() }

    // nth token paths
    // tokens in preorder: leaf, leaf, tail
    match find_path_to_nth_token(root, 0) {
        None => panic()
        Some(p0) => {
            match get_node_by_path(root, p0) {
                None => panic()
                Some(n0) => {
                    if syntax_text(n0) != "leaf" { panic() }
                }
            }
        }
    }
    match find_path_to_nth_token(root, 2) {
        None => panic()
        Some(p2) => {
            match get_node_by_path(root, p2) {
                None => panic()
                Some(n2) => {
                    if syntax_text(n2) != "tail" { panic() }
                }
            }
        }
    }

    // delete by path (delete first leaf under inner)
    let path0 = paths[0]
    let deleted = delete_node_by_path(root, path0)
    let printed_before = lossless_print(root)
    let printed_after = lossless_print(deleted)
    if printed_before == "" { panic() }
    if printed_after == "" { panic() }

    // insert at path (insert a new token into inner at index 0)
    let inner_path = [0]
    let inserted = insert_node_at_path(root, inner_path, 0, make_token("HEAD", [], []))
    match find_path_to_token_text(inserted, "HEAD") {
        None => panic()
        Some(_) => ()
    }

    // append at path (append to inner)
    let appended = append_node_at_path(root, inner_path, make_token("APP", [], []))
    match find_path_to_token_text(appended, "APP") {
        None => panic()
        Some(_) => ()
    }
}

test "arena interning" {
    let arena0 = new_arena()

    // Intern identical tokens twice
    let (arena1, tok1) = arena_intern_token(arena0, "id", [whitespace_trivia(" ")], [newline_trivia("\n")])
    let (arena2, tok2) = arena_intern_token(arena1, "id", [whitespace_trivia(" ")], [newline_trivia("\n")])

    // Should reuse
    if !structural_equal(tok1, tok2) { panic() }
    if arena_token_count(arena2) != 1 { panic() }

    // Intern a different token
    let (arena3, _tok3) = arena_intern_token(arena2, "ID", [], [])
    if arena_token_count(arena3) != 2 { panic() }

    // Intern nodes
    let children = [tok1, make_token("=", [], []), make_token("1", [], [])]
    let (arena4, node1) = arena_intern_node(arena3, children, [], [])
    let (arena5, node2) = arena_intern_node(arena4, children, [], [])

    if !structural_equal(node1, node2) { panic() }
    if arena_node_count(arena5) != 1 { panic() }
}

// Minimal roundtrip tests using the trivial tokenizer

test "roundtrip: empty string" {
    let src = ""
    let out = roundtrip_print_simple(src)
    if out != src { panic() }
}

test "roundtrip: spaces and newlines only" {
    let src = "  \n\t\n"
    let out = roundtrip_print_simple(src)
    if out != src { panic() }
}

test "roundtrip: simple words with spaces" {
    let src = "hello  world\nmoonbit"
    let out = roundtrip_print_simple(src)
    if out != src { panic() }
}

test "crlf: rebuild and offsets" {
    let t1 = make_token("a", [], [newline_trivia("\r\n")])
    let t2 = make_token("b", [], [])
    let root = make_node([t1, t2], [], [])

    let printed = lossless_print(root)
    if printed != "a\r\nb" { panic() }

    // non-strict offsets include trailing CRLF in first token
    let ranges = compute_token_offsets(root)
    if ranges.length() != 2 { panic() }

    let r0 = ranges[0]
    let r1 = ranges[1]
    if r0.1 != 0 { panic() }
    if r0.2 != 3 { panic() }
    if r1.1 != 3 { panic() }
    if r1.2 != 4 { panic() }

    // strict offsets move newline to next token's leading
    let s_ranges = compute_token_offsets_strict(root)
    if s_ranges.length() != 2 { panic() }
    let s0 = s_ranges[0]
    let s1 = s_ranges[1]
    if s0.1 != 0 { panic() }
    if s0.2 != 1 { panic() }
    if s1.1 != 1 { panic() }
    if s1.2 != 4 { panic() }

    let printed_strict = lossless_print_strict(root)
    if printed_strict != "a\r\nb" { panic() }
}

test "minimal lexer adapter roundtrip" {
    let src = "a /*c*/ b\r\n// line\n\tend"
    let root = lex_minimal_build_tree(src)
    let printed = lossless_print(root)
    if printed != src { panic() }
}

test "minimal lexer adapter structure" {
    let src = "hello world\n"
    let root = lex_minimal_build_tree(src)
    // Should be a node wrapping a single token per current adapter
    let children = syntax_children(root)
    if children.length() != 1 { panic() }
    let tok = children[0]
    if !is_token(tok) { panic() }
    if syntax_text(tok) != src { panic() }
}

// 覆盖更多分支：节点级前后缀回退（无 token）

test "normalize: node-level trivia preserved when no tokens" {
    let node = make_node([], [whitespace_trivia(" ")], [newline_trivia("\n")])
    let normalized = normalize_trivia_ownership(node)
    let lt = leading_trivia(normalized)
    let tt = trailing_trivia(normalized)
    if lt.length() != 1 { panic() }
    if !is_whitespace_trivia(lt[0]) { panic() }
    if tt.length() != 1 { panic() }
    if !is_newline_trivia(tt[0]) { panic() }
}

// 覆盖严格规范步骤1末尾分支：最后一个 token 仍保留换行及其后的内容在 trailing

test "strict: last token keeps newline in trailing" {
    let t1 = make_token("a", [], [whitespace_trivia(" "), newline_trivia("\n"), comment_trivia("// c")])
    let root = make_node([t1], [], [])
    let strict = normalize_trivia_ownership_strict(root)
    let toks = collect_tokens(strict)
    let tr = trailing_trivia(toks[0])
    if tr.length() != 3 { panic() }
    if !is_whitespace_trivia(tr[0]) { panic() }
    if !is_newline_trivia(tr[1]) { panic() }
    if !is_comment_trivia(tr[2]) { panic() }
}

// 覆盖严格校验器三类错误分支

test "strict validator: trailing newline before last token" {
    let t1 = make_token("a", [], [newline_trivia("\n")])
    let t2 = make_token("b", [], [])
    let root = make_node([t1, t2], [], [])
    let errs = validate_trivia_ownership_strict(root)
    let mut found = false
    for e in errs { if e == "Trailing trivia before last token contains newline" { found = true } }
    if !found { panic() }
}

test "strict validator: non-first leading without newline" {
    let t1 = make_token("a", [], [])
    let t2 = make_token("b", [whitespace_trivia(" ")], [])
    let root = make_node([t1, t2], [], [])
    let errs = validate_trivia_ownership_strict(root)
    let mut found = false
    for e in errs { if e == "Leading trivia on non-first token has no newline" { found = true } }
    if !found { panic() }
}

test "strict validator: non-first leading must start with newline" {
    let t1 = make_token("a", [], [])
    let t2 = make_token("b", [whitespace_trivia(" "), newline_trivia("\n")], [])
    let root = make_node([t1, t2], [], [])
    let errs = validate_trivia_ownership_strict(root)
    let mut found = false
    for e in errs { if e == "Leading trivia on non-first token must start with newline" { found = true } }
    if !found { panic() }
}

// 覆盖 builder 的 mark_missing 分支

test "builder: mark missing" {
    let b0 = new_builder()
    let b1 = add_child(b0, make_token("x", [], []))
    let b2 = mark_missing(b1, true)
    let node = build_from_builder(b2, "node", "")
    if !is_missing(node) { panic() }
}


