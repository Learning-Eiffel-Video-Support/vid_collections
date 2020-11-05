note
	description: "A {SET} of any {HASHABLE} items of [G]"
	explanation: "[
		This is really just {SET} wrapped around {HASH_TABLE_EXT}.
		Why? Look at {INTEGER_INTERVAL} to see it is a contiguous
		set of integers. In {SET}, all we want is just a unique
		set of items, but where those items are guarenteed unique
		based on a hash-code.
		]"
	disclaimer: "[
		This is not a full specialization of {HASH_TABLE_EXT} because
		this class would still need all of the "after-features" described
		in {HASH_TABLE} in the notes at the end of that class. For example.
		After a call to `put' there are features you can "check" (access)
		to discover if you `put'-call did what you expected it to do. These
		checkable features have not been fully implemented in this example class.
		]"

			-- Hover and click open!
	EIS: "name=try", "src=https://www.eiffel.com"
	EIS: "name=buy", "src=https://account.eiffel.com/licenses/_/buy/"
			-- Code commercial for less than 41 cents a day!

	EiS: "name=other_demos", "src=https://github.com/Learning-Eiffel-Video-Support"

	EIS: "name=video_demo", "src=https://youtube.com"
	EIS: "name=learning_eiffel_channel", "src=https://www.youtube.com/playlist?list=PLf9JgTngKbj417KYiyb4iv88GYAlhN7FX"

class
	SET_EXT [G -> detachable HASHABLE]

inherit
	SET [G]
		export {LIST_MUTATOR}
			prune_all,
			fill
		end

	IMMUTABLE_LIST

create
	from_items

feature {NONE} -- Initialization

	from_items (a_items: ARRAY [G])
		do
			create items.from_items (a_items)
		end

feature -- Access

	count: INTEGER
			-- How many items in Set?
		do
			Result := items.count
		end

	linear_representation: LINEAR [G]
			-- Items in Set as a linear collection.
		do
			Result := items.to_arrayed_list
		end

	new_cursor: ITERATION_CURSOR [G]
			-- A new cursor for iteration of Set.
		do
			Result := linear_representation.new_cursor
		end

feature {LIST_MUTATOR} -- Basic Ops

	extend, insert_fast (v: G)
			-- `extend' or `insert_fast' item of `v' into Set.
			-- (Use `extend' if you are sure there is no item with
			--	  the same hash key of `v', enabling faster insertion (but
			--	  unpredictable behavior if this assumption is not true).)
		do
			check has_item: attached v as al_item then
				items.extend (al_item, al_item.hash_code)
			end
		end

	put, insert_unique (v: G)
			-- `put' or `insert_unique' item of `v' into Set.
			--  (Use `put' if you want to do an insertion only if
			--	  there was no item with the same hash key of `v')
		require else
			extendible: extendible
			has_item: attached v as al_item
		do
			check has_item: attached v as al_item then
				items.put (al_item, al_item.hash_code)
			end
		end

	force, insert_or_replace (v: G)
			-- `force' `v' into Set.
			-- (Use `force' if you always want to insert the item;
			--	  if there was one for the given key it will be removed,
			--	  (and you can find out on return what it was).)
		do
			check has_item: attached v as al_item then
				items.force (al_item, al_item.hash_code)
			end
		end

	prune, remove (v: G)
			-- `prune' or `remove' item of `v' from Set.
		do
			items.prune (v)
		end

	wipe_out
			-- `wipe_out' all items in Set.
		do
			items.wipe_out
		end

feature -- Settings

	extendible: BOOLEAN
			-- Is this Set `extendible'?
		do
			Result := items.extendible
		end

	prunable: BOOLEAN
			-- Is this Set `prunable'?
		do
			Result := items.prunable
		end

	has alias "∋" (v: G): BOOLEAN
			-- Does this Set have an instance of `v'?
		do
			Result := items.has_item (v)
		end

	is_empty: BOOLEAN
			-- Is this Set empty?
		do
			Result := items.is_empty
		end

feature {NONE} -- Implementation

	items: HASH_TABLE_EXT [G, INTEGER]
			-- `items' listed in Current with {INTEGER} hashes
		note
			design: "[
				This feature is what makes this class a specialized
				wrapper of {HASH_TABLE_EXT}, such that the keys are
				type-anchord to INTEGER, which is why [G -> detachable HASHABLE]
				is in the inhert clause (see top of class)
				]"
		attribute
			create Result.make (0)
		ensure
			not_extendible: not Result.extendible
		end

note
	instruction: "[
		Here is how to choose between them:

			- Use `put' if you want to do an insertion only if
			  there was no item with the given key, doing nothing
			  otherwise. (You can find out on return if there was one,
			  and what it was.)

			- Use `force' if you always want to insert the item;
			  if there was one for the given key it will be removed,
			  (and you can find out on return what it was).

			- Use `extend' if you are sure there is no item with
			  the given key, enabling faster insertion (but
			  unpredictable behavior if this assumption is not true).

			- Use `replace' if you want to replace an already present
			  item with the given key, and do nothing if there is none.

		]"

end
