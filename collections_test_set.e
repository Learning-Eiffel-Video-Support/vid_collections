note
	description: "[
		Tests demonstrating various Eiffel collections ({CONTAINER}).
	]"
	testing: "type/manual"

			-- Hover and click open!
	EIS: "name=try", "src=https://www.eiffel.com"
	EIS: "name=buy", "src=https://account.eiffel.com/licenses/_/buy/"
			-- Code commercial for less than 41 cents a day!

	EiS: "name=other_demos", "src=https://github.com/Learning-Eiffel-Video-Support"

	EIS: "name=video_demo", "src=https://youtube.com"
	EIS: "name=learning_eiffel_channel", "src=https://www.youtube.com/playlist?list=PLf9JgTngKbj417KYiyb4iv88GYAlhN7FX"

class
	COLLECTIONS_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	-- CONTAINER
	--	ARRAY [G -> ANY]								Simple arrays of G
	--  ARRAY2 [G -> ANY]								2D arrays of G
	--	ARRAYED_LIST [G -> ANY]							Arrays as lists of G
	--	ARRAYED_STACK [G -> ANY]						Arrays as stacks of G
	--  ARRAYED_QUEUE [G -> ANY]						Arrays as queues of G
	-- 	HASH_TABLE [G -> ANY, K -> detachable HASHABLE]	Arrays as hash-maps (key:value) or (G, K)
	--	INTEGER_INTERVAL								Arrays of contiguous integer ranges (INTEGERs)

	array_demo_test
		note
			testing:  "covers/{ARRAY}",
						"execution/isolated",
						"execution/serial"
		local
			l_array: ARRAY [ANY]
			l_numbers: ARRAY [INTEGER]
		do
			create l_array.make_empty -- noisy or wordy way
			l_array := <<>> -- less noisy, but harder to understand for some

			create l_numbers.make (1, 100) -- prebuilt for 100 items, that are presently un-filled.

			create l_array.make_from_array (<<"THIS", "THAT">>) -- harder way
			l_array := <<"THIS", "THAT">> -- easier way

			create l_array.make_filled ("my_default_string", 1, 100) -- array pre-filled with 100 string items.
		end

	array2_demo_test
		note
			testing:  "covers/{ARRAY2}",
						"execution/isolated",
						"execution/serial"
		local
			l_2d: ARRAY2 [INTEGER]
		do
			create l_2d.make_filled (0, 3, 5)
		end

	arrayed_list_demo_test
		note
			testing:  "covers/{ARRAYED_LIST}",
						"execution/isolated",
						"execution/serial"
		local
			l_any_list: ARRAYED_LIST [ANY]
			l_int_list: ARRAYED_LIST [INTEGER]
		do
			create l_any_list.make (0) -- empty list with starting capacity of zero.
			create l_any_list.make_from_array (<<"THIS", "THAT", "OTHER">>) -- very useful!

			create l_int_list.make_filled (10) -- filled with 10 default integer items.
			create l_int_list.make_from_iterable (1 |..| 1_000) -- A thousand integer items defaulted to 0
		end

	arrayed_stack_demo_test
		note
			testing:  "covers/{ARRAYED_STACK}",
						"execution/isolated",
						"execution/serial"
		local
			l_stack: ARRAYED_STACK [STRING]
		do
			create l_stack.make (10)
			create l_stack.make_from_iterable (<<"THIS", "THAT", "OTHER">>)
			assert_32 ("last_other", l_stack.last.same_string ("OTHER"))
			assert_32 ("first_this", l_stack.first.same_string ("THIS"))

			l_stack.remove -- remove "top" item (e.g. OTHER)
			assert_integers_equal ("two", 2, l_stack.count)
			assert_strings_equal ("top_is_now_that", "THAT", l_stack.last)

			l_stack.put ("ANOTHER")
			assert_strings_equal ("top_is_now_another", "ANOTHER", l_stack.last)
			assert_integers_equal ("three", 3, l_stack.count)
		end

	arrayed_queue_demo_test
		note
			testing:  "covers/{ARRAYED_QUEUE}",
						"execution/isolated",
						"execution/serial"
		local
			l_queue: ARRAYED_QUEUE [STRING]
		do
			create l_queue.make (3)
			l_queue.put ("THIS")
			l_queue.put ("THAT")
			l_queue.put ("OTHER")

			assert_strings_equal ("first_in_line_this", "THIS", l_queue.item)
			l_queue.remove
			assert_strings_equal ("next_in_line_that", "THAT", l_queue.item)
			l_queue.remove
			assert_strings_equal ("last_in_line_other", "OTHER", l_queue.item)
			l_queue.remove
			assert_32 ("line_empty", l_queue.is_empty)
		end

	hash_table_demo_test
			-- Demonstration of HASH_TABLE [G, K]
			-- Key:Value pairs with {HASHABLE} keys.
		note
			testing:  "covers/{HASH_TABLE}",
						"execution/isolated",
						"execution/serial"
		local
			l_hash: HASH_TABLE [STRING, INTEGER]
				-- Extension classes created here to demonstrate convenience features
				--  for creation of "immutable" lists.
			l_hash_ext: HASH_TABLE_EXT [STRING, INTEGER]
			l_mixed_keys: HASH_TABLE_EXT [STRING, HASHABLE]
			l_set_ext: SET_EXT [STRING]

			l_array: ARRAY [STRING]
		do
				-- This ends up looking noisy simply to create a list.
			create l_hash.make (4)
			l_hash.put ("FRED", 10)
			l_hash.put ("WILMA", 20)
			l_hash.put ("BARNEY", 30)
			l_hash.put ("BETTY", 40)

				-- This is much more concise!
			create l_hash_ext.from_pairs (<<["FRED", 10], ["WILMA", 20],
											["BARNEY", 30], ["BETTY", 40]>>)

				-- If BARNEY has an actual "key", then we wil find HASH_TABLE_EXT.from_pairs useful.
			check has_barney: attached l_hash_ext.item (30) as al_item then
				assert_strings_equal ("found_barney_at_30", "BARNEY", al_item)
			end

				-- If we don't have specific keys, then these are okay
			create l_hash_ext.from_items (<<"FRED", "WILMA", "BARNEY", "BETTY">>)
			create l_set_ext.from_items (<<"FRED", "WILMA", "BARNEY", "BETTY">>)

			assert_32 ("not_extendible", not l_set_ext.extendible)

				-- BUT--they are not really needed because we have manifest arrays.
			l_array := <<"FRED", "WILMA", "BARNEY", "BETTY">> -- The best solution!
			assert_strings_equal ("found_barney_at_3", "BARNEY", l_array [3])

				-- And if we wanted to have keys of various types, we can do that too!
			create l_mixed_keys.from_pairs (<<["FRED", "YABBA"], ["WILMA", 200],
												["BARNEY", 501.3], ["BETTY", True]>>)

			check has_FRED: attached l_mixed_keys.item ("YABBA") as al_item then
				assert_strings_equal ("found_FRED", "FRED", al_item)
			end

			check has_WILMA: attached l_mixed_keys.item (200) as al_item then
				assert_strings_equal ("found_WILMA", "WILMA", al_item)
			end

			check has_BARNEY: attached l_mixed_keys.item (501.3) as al_item then
				assert_strings_equal ("found_BARNEY", "BARNEY", al_item)
			end

			check has_BETTY: attached l_mixed_keys.item (True) as al_item then
				assert_strings_equal ("found_BETTY", "BETTY", al_item)
			end
		end

	integer_interval_demo_test
		note
			testing:  "covers/{INTEGER_INTERVAL}",
						"execution/isolated",
						"execution/serial"
		local
			l_range: INTEGER_INTERVAL
		do
				-- range of numbers 1 to 100, inclusive
			across 1 |..| 100 as ic loop
				assert_integers_equal ("same_as_index", ic.item, ic.cursor_index)
			end

				-- different range - noodle this out ...
				-- the range is -100 to -1, inclusive
			across -100 |..| -1 as ic loop
				assert_integers_equal ("abs_of_index", ic.item.abs, 101 - ic.cursor_index)
			end

				-- Just like above, but without using a manifest range.
			l_range := 1 |..| 100 -- using a manifest
			create l_range.make (1, 100) -- same thing
			across l_range as ic loop
				assert_integers_equal ("same_as_index", ic.item, ic.cursor_index)
			end

				-- This one will require your noodle as well!
			across l_range.new_cursor.reversed as ic loop -- turn the set around the othe way (100 to 1)
				assert_integers_equal ("reversed", 101 - ic.item, ic.cursor_index)
			end
		end

end


