{% docs category_goal_cadence %}

The category goal cadence. Value in range 0-14. There are two subsets of these values which behave differently.

For values 0, 1, 2, and 13, the goal's due date repeats every goal_cadence * goal_cadence_frequency, where 0 = None, 1 = Monthly, 2 = Weekly, and 13 = Yearly.
  - For example, goal_cadence 1 with goal_cadence_frequency 2 means the goal is due every other month.

For values 3-12 and 14, goal_cadence_frequency is ignored and the goal's due date repeats every goal_cadence, where 3 = Every 2 Months, 4 = Every 3 Months, ..., 12 = Every 11 Months, and 14 = Every 2 Years.

{% enddocs %}


{% docs category_goal_cadence_frequency %}

The category goal cadence frequency. When goal_cadence is 0, 1, 2, or 13, a goal's due date repeats every goal_cadence * goal_cadence_frequency. For example, goal_cadence 1 with goal_cadence_frequency 2 means the goal is due every other month. When goal_cadence is 3-12 or 14, goal_cadence_frequency is ignored.

{% enddocs %}