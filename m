Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC582F0DBD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbhAKIS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:18:56 -0500
Received: from mail.loongson.cn ([114.242.206.163]:59566 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727556AbhAKISz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 03:18:55 -0500
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Ax1by0CfxffXcCAA--.1888S3;
        Mon, 11 Jan 2021 16:17:59 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [QUESTION] build errors and warnings when make M=samples/bpf
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Message-ID: <e344c3fb-b541-0479-1218-23e4752daf1a@loongson.cn>
Date:   Mon, 11 Jan 2021 16:17:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Ax1by0CfxffXcCAA--.1888S3
X-Coremail-Antispam: 1UD129KBjvAXoW3urWkWFyrtr4rZrWUKr1kAFb_yoW8AFW3Co
        Z3Ar15Ar4rXa4xJFW0yr18Jr4DurZYqrn7tFyI9r4Ygr13Aa93Krn3JanFqay0grWjqw1x
        Za1Fvw47Xr47Grykn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUO87AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
        JVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
        xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        64x0Y40En7xvr7AKxVWUJVW8JwAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI
        0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8v
        x2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIec
        xEwVAFwVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
        F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
        ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1I6r4UMIIF0xvEx4A2jsIE14v26r
        1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUO
        YFZUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I found the following build errors and warnings when make M=samples/bpf
on the Loongson 3A3000 platform which belongs to MIPS arch.

Are theseknown issues? Should I submit patches to fix them? (1) fatal error: 
'asm/rwonce.h' file not found

CLANG-bpf samples/bpf/xdpsock_kern.o In file included from 
samples/bpf/xdpsock_kern.c:2: In file included from 
./include/linux/bpf.h:9: In file included from 
./include/linux/workqueue.h:9: In file included from 
./include/linux/timer.h:5: In file included from 
./include/linux/list.h:9: In file included from 
./include/linux/kernel.h:10: ./include/linux/compiler.h:246:10: fatal 
error: 'asm/rwonce.h' file not found #include <asm/rwonce.h> 
^~~~~~~~~~~~~~ 1 error generated. HEAD is now at 7c53f6b... Linux 
5.11-rc3 [yangtiezhu@linux linux.git]$ find . -name rwonce.h 
./include/asm-generic/rwonce.h ./arch/arm64/include/asm/rwonce.h 
./arch/alpha/include/asm/rwonce.h The following changes can fix the 
above errors, is it right? [yangtiezhu@linux linux.git]$ vim 
include/linux/compiler.h [yangtiezhu@linux linux.git]$ git diff diff 
--git a/include/linux/compiler.h b/include/linux/compiler.h index 
b8fe0c2..b73b18c 100644 --- a/include/linux/compiler.h +++ 
b/include/linux/compiler.h @@ -243,6 +243,8 @@ static inline void 
*offset_to_ptr(const int *off) */ #define 
prevent_tail_call_optimization() mb() +#ifdef CONFIG_ARM64 || 
CONFIG_ALPHA #include <asm/rwonce.h> +#endif #endif /* 
__LINUX_COMPILER_H */ (2) printf format warnings

   CC  samples/bpf/ibumad_user.o
samples/bpf/ibumad_user.c: In function ‘dump_counts’:
samples/bpf/ibumad_user.c:46:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("0x%02x : %llu\n", key, value);
                      ~~~^          ~~~~~
                      %lu
   CC  samples/bpf/lathist_user.o
   CC  samples/bpf/lwt_len_hist_user.o
   CC  samples/bpf/map_perf_test_user.o
   CC  samples/bpf/offwaketime_user.o
samples/bpf/offwaketime_user.c: In function ‘print_ksym’:
samples/bpf/offwaketime_user.c:34:17: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("%s/%llx;", sym->name, addr);
               ~~~^               ~~~~
               %lx
samples/bpf/offwaketime_user.c: In function ‘print_stack’:
samples/bpf/offwaketime_user.c:68:17: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf(";%s %lld\n", key->waker, count);
               ~~~^                 ~~~~~
               %ld
   CC  samples/bpf/sampleip_user.o
samples/bpf/sampleip_user.c: In function ‘print_ip_map’:
samples/bpf/sampleip_user.c:118:20: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("0x%-17llx %-32s %u\n", counts[i].ip, sym->name,
               ~~~~~~^              ~~~~~~~~~~~~
               %-17lx
samples/bpf/sampleip_user.c:121:20: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("0x%-17llx %-32s %u\n", counts[i].ip, "(user)",
               ~~~~~~^              ~~~~~~~~~~~~
               %-17lx
   CC  samples/bpf/sockex1_user.o
   CC  samples/bpf/sockex2_user.o
samples/bpf/sockex2_user.c: In function ‘main’:
samples/bpf/sockex2_user.c:47:27: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("ip %s bytes %lld packets %lld\n",
                         ~~~^
                         %ld
samples/bpf/sockex2_user.c:49:11:
            value.bytes, value.packets);
            ~~~~~~~~~~~
samples/bpf/sockex2_user.c:47:40: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("ip %s bytes %lld packets %lld\n",
                                      ~~~^
                                      %ld
samples/bpf/sockex2_user.c:49:24:
            value.bytes, value.packets);
                         ~~~~~~~~~~~~~
   CC  samples/bpf/sockex3_user.o
samples/bpf/sockex3_user.c: In function ‘main’:
samples/bpf/sockex3_user.c:91:36: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 6 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("%s.%05d -> %s.%05d %12lld %12lld\n",
                                ~~~~~^
                                %12ld
samples/bpf/sockex3_user.c:96:11:
            value.bytes, value.packets);
            ~~~~~~~~~~~
samples/bpf/sockex3_user.c:91:43: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 7 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("%s.%05d -> %s.%05d %12lld %12lld\n",
                                       ~~~~~^
                                       %12ld
samples/bpf/sockex3_user.c:96:24:
            value.bytes, value.packets);
                         ~~~~~~~~~~~~~
   CC  samples/bpf/spintest_user.o
   CC  samples/bpf/syscall_tp_user.o
   CC  samples/bpf/task_fd_query_user.o
samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_kprobe’:
samples/bpf/task_fd_query_user.c:116:52: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("buf: %s, fd_type: %u, probe_offset: 0x%llx,"
                                                  ~~~^
                                                  %lx
samples/bpf/task_fd_query_user.c:118:24:
           buf, fd_type, probe_offset, probe_addr);
                         ~~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:116:10: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("buf: %s, fd_type: %u, probe_offset: 0x%llx,"
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:118:38:
           buf, fd_type, probe_offset, probe_addr);
                                       ~~~~~~~~~~
samples/bpf/task_fd_query_user.c:117:29: note: format string is defined here
           " probe_addr: 0x%llx\n",
                           ~~~^
                           %lx
samples/bpf/task_fd_query_user.c: In function ‘test_nondebug_fs_probe’:
samples/bpf/task_fd_query_user.c:190:10: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("FAIL: %s, "
           ^~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:192:38:
           __func__, name ? name : "", offset, addr, is_return);
                                       ~~~~~~
samples/bpf/task_fd_query_user.c:191:36: note: format string is defined here
           "for name %s, offset 0x%llx, addr 0x%llx, is_return %d\n",
                                  ~~~^
                                  %lx
samples/bpf/task_fd_query_user.c:190:10: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("FAIL: %s, "
           ^~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:192:46:
           __func__, name ? name : "", offset, addr, is_return);
                                               ~~~~
samples/bpf/task_fd_query_user.c:191:49: note: format string is defined here
           "for name %s, offset 0x%llx, addr 0x%llx, is_return %d\n",
                                               ~~~^
                                               %lx
samples/bpf/task_fd_query_user.c:208:50: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("FAIL: %s, incorrect probe_offset 0x%llx\n",
                                                ~~~^
                                                %lx
            __func__, probe_offset);
                      ~~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:220:48: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("FAIL: %s, incorrect probe_addr 0x%llx\n",
                                              ~~~^
                                              %lx
            __func__, probe_addr);
                      ~~~~~~~~~~
samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_uprobe’:
samples/bpf/task_fd_query_user.c:300:49: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("FAIL: %s, incorrect probe_offset 0x%llx\n", __func__,
                                               ~~~^
                                               %lx
           probe_offset);
           ~~~~~~~~~~~~
   CC  samples/bpf/tc_l2_redirect_user.o
   CC  samples/bpf/test_cgrp2_array_pin.o
   CC  samples/bpf/test_cgrp2_attach.o
   CC  samples/bpf/test_cgrp2_sock.o
   CC  samples/bpf/test_cgrp2_sock2.o
   CC  samples/bpf/test_current_task_under_cgroup_user.o
   CC  samples/bpf/test_map_in_map_user.o
   CC  samples/bpf/test_overhead_user.o
   CC  samples/bpf/test_probe_write_user_user.o
   CC  samples/bpf/trace_event_user.o
samples/bpf/trace_event_user.c: In function ‘print_addr’:
samples/bpf/trace_event_user.c:50:13: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf("%llx;", addr);
           ~~~^    ~~~~
           %lx
samples/bpf/trace_event_user.c: In function ‘print_stack’:
samples/bpf/trace_event_user.c:67:14: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf("%3lld %s;", count, key->comm);
           ~~~~^       ~~~~~
           %3ld
   CC  samples/bpf/trace_output_user.o
samples/bpf/trace_output_user.c: In function ‘print_bpf_output’:
samples/bpf/trace_output_user.c:30:22: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("BUG pid %llx cookie %llx sized %d\n",
                    ~~~^
                    %lx
           e->pid, e->cookie, size);
           ~~~~~~
samples/bpf/trace_output_user.c:30:34: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("BUG pid %llx cookie %llx sized %d\n",
                                ~~~^
                                %lx
           e->pid, e->cookie, size);
                   ~~~~~~~~~
   CC  samples/bpf/tracex1_user.o
   CC  samples/bpf/tracex2_user.o
   CC  samples/bpf/tracex3_user.o
samples/bpf/tracex3_user.c: In function ‘print_hist’:
samples/bpf/tracex3_user.c:105:16: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf(" # %lld\n", total_events);
              ~~~^     ~~~~~~~~~~~~
              %ld
   CC  samples/bpf/tracex4_user.o
samples/bpf/tracex4_user.c: In function ‘print_old_objects’:
samples/bpf/tracex4_user.c:44:20: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("obj 0x%llx is %2lldsec old was allocated at ip %llx\n",
                  ~~~^
                  %lx
           next_key, (val - v.val) / 1000000000ll, v.ip);
           ~~~~~~~~
samples/bpf/tracex4_user.c:44:61: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("obj 0x%llx is %2lldsec old was allocated at ip %llx\n",
                                                           ~~~^
                                                           %lx
           next_key, (val - v.val) / 1000000000ll, v.ip);
                                                   ~~~~
   CC  samples/bpf/tracex5_user.o
   CC  samples/bpf/tracex6_user.o
samples/bpf/tracex6_user.c: In function ‘check_on_cpu’:
samples/bpf/tracex6_user.c:54:31: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    fprintf(stderr, "CPU %d: %llu\n", cpu, value);
                             ~~~^          ~~~~~
                             %lu
samples/bpf/tracex6_user.c:62:40: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    fprintf(stderr, "CPU %d: counter: %llu, enabled: %llu, running: %llu\n", cpu,
                                      ~~~^
                                      %lu
     value2.counter, value2.enabled, value2.running);
     ~~~~~~~~~~~~~~
samples/bpf/tracex6_user.c:62:55: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    fprintf(stderr, "CPU %d: counter: %llu, enabled: %llu, running: %llu\n", cpu,
                                                     ~~~^
                                                     %lu
     value2.counter, value2.enabled, value2.running);
                     ~~~~~~~~~~~~~~
samples/bpf/tracex6_user.c:62:70: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 6 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    fprintf(stderr, "CPU %d: counter: %llu, enabled: %llu, running: %llu\n", cpu,
                                                                    ~~~^
                                                                    %lu
     value2.counter, value2.enabled, value2.running);
                                     ~~~~~~~~~~~~~~
   CC  samples/bpf/tracex7_user.o
   CC  samples/bpf/xdp1_user.o
samples/bpf/xdp1_user.c: In function ‘poll_stats’:
samples/bpf/xdp1_user.c:62:28: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
      printf("proto %u: %10llu pkt/s\n",
                        ~~~~~^
                        %10lu
             key, (sum - prev[key]) / interval);
                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   CC  samples/bpf/xdp_adjust_tail_user.o
samples/bpf/xdp_adjust_tail_user.c: In function ‘poll_stats’:
samples/bpf/xdp_adjust_tail_user.c:65:46: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("icmp \"packet too big\" sent: %10llu pkts\n", value);
                                          ~~~~~^          ~~~~~
                                          %10lu
   CC  samples/bpf/xdp_fwd_user.o
   CC  samples/bpf/xdp_monitor_user.o
   CC  samples/bpf/xdp_redirect_cpu_user.o
   CC  samples/bpf/xdp_redirect_map_user.o
samples/bpf/xdp_redirect_map_user.c: In function ‘poll_stats’:
samples/bpf/xdp_redirect_map_user.c:80:29: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("ifindex %i: %10llu pkt/s\n",
                         ~~~~~^
                         %10lu
            ifindex, sum / interval);
                     ~~~~~~~~~~~~~~
   CC  samples/bpf/xdp_redirect_user.o
samples/bpf/xdp_redirect_user.c: In function ‘poll_stats’:
samples/bpf/xdp_redirect_user.c:80:29: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
     printf("ifindex %i: %10llu pkt/s\n",
                         ~~~~~^
                         %10lu
            ifindex, sum / interval);
                     ~~~~~~~~~~~~~~
   CC  samples/bpf/xdp_router_ipv4_user.o
samples/bpf/xdp_router_ipv4_user.c: In function ‘read_arp’:
samples/bpf/xdp_router_ipv4_user.c:409:22: warning: format ‘%lld’ expects argument of type ‘long long int’, but argument 3 has type ‘__be64’ {aka ‘long unsigned int’} [-Wformat=]
      sprintf(mac, "%lld",
                    ~~~^
                    %ld
       *((__be64 *)RTA_DATA(rt_attr)));
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
samples/bpf/xdp_router_ipv4_user.c:418:20: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__be64’ {aka ‘long unsigned int’} [-Wformat=]
    printf("%x\t\t%llx\n", arp_entry.dst, arp_entry.mac);
                  ~~~^                    ~~~~~~~~~~~~~
                  %lx
samples/bpf/xdp_router_ipv4_user.c: In function ‘monitor_route’:
samples/bpf/xdp_router_ipv4_user.c:579:28: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
      printf("proto %u: %10llu pkt/s\n",
                        ~~~~~^
                        %10lu
             key, sum / interval);
                  ~~~~~~~~~~~~~~
   CC  samples/bpf/xdp_rxq_info_user.o
   CC  samples/bpf/xdp_sample_pkts_user.o
   CC  samples/bpf/xdp_tx_iptunnel_user.o
samples/bpf/xdp_tx_iptunnel_user.c: In function ‘poll_stats’:
samples/bpf/xdp_tx_iptunnel_user.c:74:32: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
      printf("proto %u: sum:%10llu pkts, rate:%10llu pkts/s\n",
                            ~~~~~^
                            %10lu
             proto, sum, sum / STATS_INTERVAL_S);
                    ~~~
samples/bpf/xdp_tx_iptunnel_user.c:74:50: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
      printf("proto %u: sum:%10llu pkts, rate:%10llu pkts/s\n",
                                              ~~~~~^
                                              %10lu
   CC  samples/bpf/xdpsock_ctrl_proc.o
   CC  samples/bpf/xdpsock_user.o
samples/bpf/xdpsock_user.c: In function ‘hex_dump’:
samples/bpf/xdpsock_user.c:542:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘u64’ {aka ‘long unsigned int’} [-Wformat=]
   sprintf(buf, "addr=%llu", addr);
                      ~~~^   ~~~~
                      %lu
   CC  samples/bpf/xsk_fwd.o
samples/bpf/xsk_fwd.c: In function ‘print_port_stats’:
samples/bpf/xsk_fwd.c:939:23: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf("| %4d | %12llu | %13.0f | %12llu | %13.0f |\n",
                   ~~~~~^
                   %12lu
samples/bpf/xsk_fwd.c:941:9:
          p->n_pkts_rx,
          ~~~~~~~~~~~~
samples/bpf/xsk_fwd.c:939:41: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘u64’ {aka ‘long unsigned int’} [-Wformat=]
   printf("| %4d | %12llu | %13.0f | %12llu | %13.0f |\n",
                                     ~~~~~^
                                     %12lu
samples/bpf/xsk_fwd.c:943:9:
          p->n_pkts_tx,
          ~~~~~~~~~~~~

Thanks,
Tiezhu

