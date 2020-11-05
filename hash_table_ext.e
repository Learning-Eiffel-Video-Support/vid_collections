note
	description: "Convenience features for HASH_TABLEs"

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
