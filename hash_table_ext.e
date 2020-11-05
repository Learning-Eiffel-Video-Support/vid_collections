note
	description: "Convenience features for HASH_TABLEs"
	explanation: "[
		The basic Eiffel ELKS version of HASH_TABLE does not have any
		convenience features for creating new lists. This class is here
		as an example of how to provide useful convenience features.
		
		The most notably missing convenience features are those for creating
		a new HASH_TABLE from a limited list of items. In one case, `from_pairs',
		we want to control both the key and the value. In the other case, we
		only want to control the value and relegate the key to a hash-code of
		the item (e.g. we won't be looking up our item by its key).
		]"
	disclaimer: "[
		The second case is rather odd. The better approach is to simply use a manifest array.
		
		For example: <<"FRED", "WILMA", "BARNEY", "BETTY">>. Using the notion
		of HASH_TABLE_EXT.from_items (<<"FRED", "WILMA", "BARNEY", "BETTY">>) is
		rather wasteful at the end of the day. So, this class is merely here for
		demonstration.
		]"

			-- Hover and click open!
	EIS: "name=try", "src=https://www.eiffel.com"
	EIS: "name=buy", "src=https://account.eiffel.com/licenses/_/buy/"
			-- Code commercial for less than 41 cents a day!

	EiS: "name=other_demos", "src=https://github.com/Learning-Eiffel-Video-Support"

	EIS: "name=video_demo", "src=https://youtube.com"
	EIS: "name=learning_eiffel_channel", "src=https://www.youtube.com/playlist?list=PLf9JgTngKbj417KYiyb4iv88GYAlhN7FX"

class
	HASH_TABLE_EXT [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE [G, K]

	IMMUTABLE_LIST

create
	make,
	make_equal,
	from_pairs,
	from_items

feature {NONE} -- Initialization

	from_pairs (a_pairs: ARRAY [TUPLE [value: G; key: K]])
			-- Make `from_pairs' of key:value items in `a_pairs'.
			--	(keys may be of any type that is HASHABLE)
		do
			make (a_pairs.count)
			across a_pairs as ic
			invariant
				no_conflict: control /= conflict_constant
			loop
				put (ic.item.value, ic.item.key)
				check is_inserted: inserted and then not replaced end
				check has_position: item_position > 0 end
			end
		ensure
			same_count: count = a_pairs.count
		end

	from_items (a_items: ARRAY [G])
			-- Make `from_items' in `a_items' using {INTEGER_32} hash keys.
			-- 	(keys will be computed as a hash_code derived from each item)
		do
			make (a_items.count)
			across
				a_items as ic
			invariant
				no_conflict: control /= conflict_constant
			loop
				check all_hashable_to_integer:
					attached {HASHABLE} ic.item as al_item and then
					attached {K} al_item.hash_code as al_key
				then
					put (ic.item, al_key)
					check is_inserted: inserted and then not replaced end
				end
			end
		end

feature {IMMUTABLE_LIST} -- Conversion

	to_arrayed_list: ARRAYED_LIST [G]
			-- Convert `to_arrayed_list'
		do
			create Result.make (count)
			across Current as ic loop
				Result.force (ic.item)
			end
		end

end
