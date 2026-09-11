#include <aws/io/io.h>
#include <aws/io/event_loop.h>
#include <aws/common/allocator.h>
#include <aws/common/thread.h>
#include <stdio.h>

int main(void) {
    struct aws_allocator *allocator = aws_default_allocator();
    struct aws_event_loop_group_options options = {0};
    struct aws_event_loop_group *group;
    struct aws_event_loop *loop;
    uint64_t now = 0;
    options.loop_count = 1;
    aws_io_library_init(allocator);
    group = aws_event_loop_group_new(allocator, &options);
    if (!group) return 1;
    loop = aws_event_loop_group_get_next_loop(group);
    if (!loop || aws_event_loop_current_clock_time(loop, &now) || now == 0) return 2;
    aws_event_loop_group_release(group);
    if (aws_thread_join_all_managed()) return 3;
    aws_io_library_clean_up();
    puts("Installed AWS IO event-loop creation, clock and shutdown passed");
    return 0;
}
