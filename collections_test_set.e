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

	hash_table_demo_test
			-- Demonstration of HASH_TABLE [G, K]
			-- Key:Value pairs with {HASHABLE} keys.
		note
			testing:  "covers/{HASH_TABLE [STRING, STRING]}.make",
						"execution/isolated",
						"execution/serial"
		local
			l_hash: HASH_TABLE [STRING, INTEGER]
				-- Extension classes created here to demonstrate convenience features
				--  for creation of "immutable" lists.
			l_hash_ext: HASH_TABLE_EXT [STRING, INTEGER]
			l_set_ext: SET_EXT [STRING]
		do
			create l_hash.make (4)
			l_hash.put ("FRED", 10)
			l_hash.put ("WILMA", 20)
			l_hash.put ("BARNEY", 30)
			l_hash.put ("BETTY", 40)

			create l_hash_ext.from_pairs (<<["FRED", 10], ["WILMA", 20],
											["BARNEY", 30], ["BETTY", 40]>>)

			create l_hash_ext.from_items (<<"FRED", "WILMA", "BARNEY", "BETTY">>)
			create l_set_ext.from_items (<<"FRED", "WILMA", "BARNEY", "BETTY">>)

			assert_32 ("not_extendible", not l_set_ext.extendible)

		end

end


