note
	description: "[
		Tests demonstrating various Eiffel collections.
	]"
	testing: "type/manual"

class
	COLLECTIONS_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	-- CONTAINER
	--	ARRAY
	--	ARRAYED_LIST
	--	ARRAYED_STACK
	--  ARRAYED_QUEUE
	-- 	HASH_TABLE
	--	INTEGER_INTERVAL

	array_demo_test
		note
			testing:  "covers/{ARRAY}",
						"execution/isolated",
						"execution/serial"
		do

		end

	arrayed_list_demo_test
		note
			testing:  "covers/{ARRAYED_LIST}",
						"execution/isolated",
						"execution/serial"
		do

		end

	arrayed_stack_demo_test
		note
			testing:  "covers/{ARRAYED_STACK}",
						"execution/isolated",
						"execution/serial"
		do

		end

	arrayed_queue_demo_test
		note
			testing:  "covers/{ARRAYED_QUEUE}",
						"execution/isolated",
						"execution/serial"
		do

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
		do

		end

end


