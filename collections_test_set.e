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

	-- Basic CONTAINER classes:
	---------------------------------------------------------------------------------------------------
	--	ARRAY [G -> ANY]								Simple arrays of G
	--  ARRAY2 [G -> ANY]								2D arrays of G
	--  ARRAYN [G -> ANY]								N-dimensional arrays of G
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
			typical_use: "[
				If your list content is stable or immutable, then use ARRAY.
				]"
			EIS: "name=video", "src=https://youtu.be/BP2FunNMtRM"
		local
			l_array: ARRAY [ANY]
			l_numbers: ARRAY [INTEGER]
		do
			create l_array.make_empty -- noisy or wordy way
			l_array := <<>> -- less noisy, but harder to understand for some

			create l_numbers.make (1, 100) -- prebuilt for 100 items, that are presently un-filled.

			create l_array.make_from_array (<<"THIS", "THAT">>) -- harder way
			l_array := <<"THIS", "THAT">> -- easier way, direct assignment to a manifest array.
			create l_array.make_from_array (l_numbers) -- making from another array reference.

			create l_array.make_filled ("def_string", 1, 100) -- array pre-filled with 100 string items.
		end

	array2_demo_test
		note
			testing:  "covers/{ARRAY2}",
						"execution/isolated",
						"execution/serial"
			typical_use: "[
				When you need an x,y or row,column array structure.
				]"
			EIS: "name=video", "src=https://youtu.be/gWLCjdrv-mY"
		local
			l_array: ARRAY2 [INTEGER]
			l_str_array: ARRAY2 [STRING]
		do
			create l_array.make (3, 5)				-- Make with rows, columns, but uninitialized.
			l_array.initialize (100)				-- Initialize cells with object values.
													-- Demonstrate going across all cells.
			assert_32 ("all_A", across l_array as ic all ic.item = 100 end)

			create l_str_array.make_filled ("X", 3, 5)	-- Do both at once.
			l_str_array.put ("ABC", 2, 4)				-- Replace content of a cell.
														-- Access cell at (2,4).
			assert_strings_equal ("at_2_4", "ABC", l_str_array [2, 4])
		end

	arrayn_demo_test
		note
			testing:  "covers/{ARRAYN}",
						"execution/isolated",
						"execution/serial"
			typical_use: "[
				Use this class for n-dimensional arrays. Be aware that it has a severe
				computational cost overhead as you add dimensions.
				]"
			disclaimer: "[
				This class is not a part of the typical ELKS Base library from Eiffel Software.
				This class is included here for your reference and unrestricted use as you
				may see fit to use it.
				]"
			EIS: "name=video", "src=https://youtu.be/wUQKF0vYGuI"
		local
			l_array: ARRAYN [INTEGER]
		do
				-- A 10 x 10 x 10 3D array. Each axis is bounded by ten elements, 1 .. 10.
			create l_array.make_n_based (<<[1, 10], [1, 10], [1, 10]>>)

				-- A 10 x 10 x 10 filled with 101 in each cell
			create l_array.make_n_based_filled (<<[1, 10], [1, 10], [1, 10]>>, 101)

			assert_integers_equal ("has_101", 101, l_array.at (10, 2, 10))		-- direct access version
			l_array.replace (199, <<10, 2, 10>>)
			assert_integers_equal ("has_199", 199, l_array @ ([10, 2, 10])) 	-- aliased access version
			assert_integers_equal ("has_199_item", 199, l_array [10, 2, 10])	-- another aliased access
		end

	arrayed_list_demo_test
		note
			testing:  "covers/{ARRAYED_LIST}",
						"execution/isolated",
						"execution/serial"
			typical_use: "[
				The ARRAYED_LIST class is a common go-to workhorse in Eiffel code and
				among Eiffel developers, but it comes with some caveats. Most notably
				is the resizable nature of the array, which can be memory intensive for
				allocation and garbage collection. The best-practice is to initialize
				these arrays with enough memory to get their jobs done. Another trick
				is to not throw arrays away, but to keep them in a cache for reuse as
				needed. Caching of just about anything saves you on computational cycles.
				]"
		local
			l_any_list: ARRAYED_LIST [ANY]
			l_int_list: ARRAYED_LIST [INTEGER]
		do
			create l_any_list.make (0) -- empty list with starting capacity of zero.
			create l_any_list.make_from_array (<<"THIS", "THAT", "OTHER">>) -- very useful!

			create l_int_list.make_filled (10) -- filled with 10 default integer items of zero.
			create l_int_list.make_from_iterable (1 |..| 1_000) -- A thousand integer items defaulted to 0

				-- For convenience, ARRAYED_LIST collections will grow by 50% (or so)
				--	when items are `forced' onto the list beyond current capacity.
				--	For very large list, this might be expensive in terms of memory
				--	allocation and garbage collection.

				-- All types of CONTAINER are ITERABLE, which means they will function
				--	as-expected in across-loops in all forms. This gives you easy iteration!
				--  In the example, l_int_list has 1_000 integers, which align perfectly with
				-- 	the cursor_index as we iterate across the collection, so our test passes.
			across l_int_list as ic_numbers loop
				assert_integers_equal ("right_value", ic_numbers.cursor_index, ic_numbers.item)
			end
				-- We could write this test differently ...
			assert_32 ("index_is_value", across l_int_list as ic all ic.cursor_index = ic.item end)
		end

	arrayed_stack_demo_test
		note
			testing:  "covers/{ARRAYED_STACK}",
						"execution/isolated",
						"execution/serial"
			typical_use: "[

				]"
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
			typical_use: "[

				]"
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
			typical_use: "[

				]"
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
			typical_use: "[

				]"
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


