Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7855C9B8AE
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfHWXBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:01:49 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42831 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHWXBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 19:01:48 -0400
Received: by mail-ot1-f65.google.com with SMTP id j7so10218680ota.9
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 16:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=carlosedp-com.20150623.gappssmtp.com; s=20150623;
        h=sender:mime-version:references:in-reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=0pXIWT49qT99+MZqSX6J3qIkOa98enjaIWpmEfE3IPA=;
        b=Jl5d/uqkObPLx0iH9yZrJcloZb/epBBG+ZOpG+5BM35bvyU+j2FXYKQykwPsIKmni1
         4s9a6V9tpfMAPLD+bVtSCM1ehPdw4b9HDVnPHAZrH/wFVzsyF1e53oa4nRRjEGZr68/X
         XNc5uKoUP53m+GghArqfiiMRkv108FWQvdRaiaAZDCP9J4zVO+aUylyTom/QVzMeTr9W
         NqtUl4Mh2Fj8QEBdmz8GCfemwdMhUQYd6EOIdNkmaGe9MNsztG2SzR9M1c3Ho26lXa6l
         cSGsRJVxYaogzVog1vlgU9ilj/WfunMayQ2g0z+Sgj6s/Qxa4wfUkaB9bdnNnYZ7D9YM
         5nvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:mime-version:references:in-reply-to:from
         :date:message-id:subject:to:cc:content-transfer-encoding;
        bh=0pXIWT49qT99+MZqSX6J3qIkOa98enjaIWpmEfE3IPA=;
        b=J2xdbLA7OUasZd0+bjSHN4C01c2kepQq9LWP3aXTECoh9v+ZlId6rhSrspvrjfcMot
         g7KOnHRPldvChl1pHcvqk7CWjeMVMTT7gRQM/fUhWeIS9jBtspD5S/zj/n80aDL0JL/q
         5xl0NfRmzDF//HQw9NMG7xjEf0WtGgyjgA3sGOOrsxODaxj4DIj3TJ6mtuozqzFX7Z/B
         31nGICHbDGX8JrtsGwEuQ9JXy4x6T89/ARXVjuRBGT5otTUAXdnJeVN7ctIyyJ0aHcNz
         7FHHojzKTvXl/gqTBLqUdBk86QlMpfOYBQ3yDA7ZXED3Phd9jwOZUd+qR4sCHvOFsdEA
         eBvg==
X-Gm-Message-State: APjAAAVY0q4LmR0lSOcMPfVTj718HlcWcd3hVp/ulvWcq3645IAxQCtG
        5db2ub0WFDjbD5fgy+Gjmgl7QoxMxmsBhg==
X-Google-Smtp-Source: APXvYqxjdhYqTxe5EbW70/otAuTR1sEII3koQUg1ztzU/MDoB0CZqsYegiJoS8K/xWHT26sgFBTbAQ==
X-Received: by 2002:a9d:7f0f:: with SMTP id j15mr5900877otq.41.1566601307001;
        Fri, 23 Aug 2019 16:01:47 -0700 (PDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com. [209.85.167.173])
        by smtp.gmail.com with ESMTPSA id c3sm1356218otm.70.2019.08.23.16.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2019 16:01:46 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id y8so8209513oih.10;
        Fri, 23 Aug 2019 16:01:46 -0700 (PDT)
X-Received: by 2002:aca:2209:: with SMTP id b9mr4930123oic.54.1566601305670;
 Fri, 23 Aug 2019 16:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
In-Reply-To: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
From:   Carlos Eduardo de Paula <me@carlosedp.com>
Date:   Fri, 23 Aug 2019 20:01:34 -0300
X-Gmail-Original-Message-ID: <CADnnUqcmDMRe1f+3jG8SPR6jRrnBsY8VVD70VbKEm0NqYeoicA@mail.gmail.com>
Message-ID: <CADnnUqcmDMRe1f+3jG8SPR6jRrnBsY8VVD70VbKEm0NqYeoicA@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     David Abdurachmanov <david.abdurachmanov@gmail.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 5:56 PM David Abdurachmanov
<david.abdurachmanov@gmail.com> wrote:
>
> This patch was extensively tested on Fedora/RISCV (applied by default on
> top of 5.2-rc7 kernel for <2 months). The patch was also tested with 5.3-=
rc
> on QEMU and SiFive Unleashed board.
>
> libseccomp (userspace) was rebased:
> https://github.com/seccomp/libseccomp/pull/134
>
> Fully passes libseccomp regression testing (simulation and live).
>
> There is one failing kernel selftest: global.user_notification_signal
>
> v1 -> v2:
>   - return immediatly if secure_computing(NULL) returns -1
>   - fixed whitespace issues
>   - add missing seccomp.h
>   - remove patch #2 (solved now)
>   - add riscv to seccomp kernel selftest
>
> Cc: keescook@chromium.org
> Cc: me@carlosedp.com
>
> Signed-off-by: David Abdurachmanov <david.abdurachmanov@sifive.com>
> Tested-by: Carlos de Paula <me@carlosedp.com>
> ---
>  arch/riscv/Kconfig                            | 14 ++++++++++
>  arch/riscv/include/asm/seccomp.h              | 10 +++++++
>  arch/riscv/include/asm/thread_info.h          |  5 +++-
>  arch/riscv/kernel/entry.S                     | 27 +++++++++++++++++--
>  arch/riscv/kernel/ptrace.c                    | 10 +++++++
>  tools/testing/selftests/seccomp/seccomp_bpf.c |  8 +++++-
>  6 files changed, 70 insertions(+), 4 deletions(-)
>  create mode 100644 arch/riscv/include/asm/seccomp.h
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 59a4727ecd6c..441e63ff5adc 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -31,6 +31,7 @@ config RISCV
>         select GENERIC_SMP_IDLE_THREAD
>         select GENERIC_ATOMIC64 if !64BIT
>         select HAVE_ARCH_AUDITSYSCALL
> +       select HAVE_ARCH_SECCOMP_FILTER
>         select HAVE_MEMBLOCK_NODE_MAP
>         select HAVE_DMA_CONTIGUOUS
>         select HAVE_FUTEX_CMPXCHG if FUTEX
> @@ -235,6 +236,19 @@ menu "Kernel features"
>
>  source "kernel/Kconfig.hz"
>
> +config SECCOMP
> +       bool "Enable seccomp to safely compute untrusted bytecode"
> +       help
> +         This kernel feature is useful for number crunching applications
> +         that may need to compute untrusted bytecode during their
> +         execution. By using pipes or other transports made available to
> +         the process as file descriptors supporting the read/write
> +         syscalls, it's possible to isolate those applications in
> +         their own address space using seccomp. Once seccomp is
> +         enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
> +         and the task is only allowed to execute a few safe syscalls
> +         defined by each seccomp mode.
> +
>  endmenu
>
>  menu "Boot options"
> diff --git a/arch/riscv/include/asm/seccomp.h b/arch/riscv/include/asm/se=
ccomp.h
> new file mode 100644
> index 000000000000..bf7744ee3b3d
> --- /dev/null
> +++ b/arch/riscv/include/asm/seccomp.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _ASM_SECCOMP_H
> +#define _ASM_SECCOMP_H
> +
> +#include <asm/unistd.h>
> +
> +#include <asm-generic/seccomp.h>
> +
> +#endif /* _ASM_SECCOMP_H */
> diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/as=
m/thread_info.h
> index 905372d7eeb8..a0b2a29a0da1 100644
> --- a/arch/riscv/include/asm/thread_info.h
> +++ b/arch/riscv/include/asm/thread_info.h
> @@ -75,6 +75,7 @@ struct thread_info {
>  #define TIF_MEMDIE             5       /* is terminating due to OOM kill=
er */
>  #define TIF_SYSCALL_TRACEPOINT  6       /* syscall tracepoint instrument=
ation */
>  #define TIF_SYSCALL_AUDIT      7       /* syscall auditing */
> +#define TIF_SECCOMP            8       /* syscall secure computing */
>
>  #define _TIF_SYSCALL_TRACE     (1 << TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME     (1 << TIF_NOTIFY_RESUME)
> @@ -82,11 +83,13 @@ struct thread_info {
>  #define _TIF_NEED_RESCHED      (1 << TIF_NEED_RESCHED)
>  #define _TIF_SYSCALL_TRACEPOINT        (1 << TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_SYSCALL_AUDIT     (1 << TIF_SYSCALL_AUDIT)
> +#define _TIF_SECCOMP           (1 << TIF_SECCOMP)
>
>  #define _TIF_WORK_MASK \
>         (_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NEED_RESCHED)
>
>  #define _TIF_SYSCALL_WORK \
> -       (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDI=
T)
> +       (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDI=
T | \
> +        _TIF_SECCOMP )
>
>  #endif /* _ASM_RISCV_THREAD_INFO_H */
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index bc7a56e1ca6f..0bbedfa3e47d 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -203,8 +203,25 @@ check_syscall_nr:
>         /* Check to make sure we don't jump to a bogus syscall number. */
>         li t0, __NR_syscalls
>         la s0, sys_ni_syscall
> -       /* Syscall number held in a7 */
> -       bgeu a7, t0, 1f
> +       /*
> +        * The tracer can change syscall number to valid/invalid value.
> +        * We use syscall_set_nr helper in syscall_trace_enter thus we
> +        * cannot trust the current value in a7 and have to reload from
> +        * the current task pt_regs.
> +        */
> +       REG_L a7, PT_A7(sp)
> +       /*
> +        * Syscall number held in a7.
> +        * If syscall number is above allowed value, redirect to ni_sysca=
ll.
> +        */
> +       bge a7, t0, 1f
> +       /*
> +        * Check if syscall is rejected by tracer or seccomp, i.e., a7 =
=3D=3D -1.
> +        * If yes, we pretend it was executed.
> +        */
> +       li t1, -1
> +       beq a7, t1, ret_from_syscall_rejected
> +       /* Call syscall */
>         la s0, sys_call_table
>         slli t0, a7, RISCV_LGPTR
>         add s0, s0, t0
> @@ -215,6 +232,12 @@ check_syscall_nr:
>  ret_from_syscall:
>         /* Set user a0 to kernel a0 */
>         REG_S a0, PT_A0(sp)
> +       /*
> +        * We didn't execute the actual syscall.
> +        * Seccomp already set return value for the current task pt_regs.
> +        * (If it was configured with SECCOMP_RET_ERRNO/TRACE)
> +        */
> +ret_from_syscall_rejected:
>         /* Trace syscalls, but only if requested by the user. */
>         REG_L t0, TASK_TI_FLAGS(tp)
>         andi t0, t0, _TIF_SYSCALL_WORK
> diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> index 368751438366..63e47c9f85f0 100644
> --- a/arch/riscv/kernel/ptrace.c
> +++ b/arch/riscv/kernel/ptrace.c
> @@ -154,6 +154,16 @@ void do_syscall_trace_enter(struct pt_regs *regs)
>                 if (tracehook_report_syscall_entry(regs))
>                         syscall_set_nr(current, regs, -1);
>
> +       /*
> +        * Do the secure computing after ptrace; failures should be fast.
> +        * If this fails we might have return value in a0 from seccomp
> +        * (via SECCOMP_RET_ERRNO/TRACE).
> +        */
> +       if (secure_computing(NULL) =3D=3D -1) {
> +               syscall_set_nr(current, regs, -1);
> +               return;
> +       }
> +
>  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>         if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>                 trace_sys_enter(regs, syscall_get_nr(current, regs));
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testin=
g/selftests/seccomp/seccomp_bpf.c
> index 6ef7f16c4cf5..492e0adad9d3 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -112,6 +112,8 @@ struct seccomp_data {
>  #  define __NR_seccomp 383
>  # elif defined(__aarch64__)
>  #  define __NR_seccomp 277
> +# elif defined(__riscv)
> +#  define __NR_seccomp 277
>  # elif defined(__hppa__)
>  #  define __NR_seccomp 338
>  # elif defined(__powerpc__)
> @@ -1582,6 +1584,10 @@ TEST_F(TRACE_poke, getpid_runs_normally)
>  # define ARCH_REGS     struct user_pt_regs
>  # define SYSCALL_NUM   regs[8]
>  # define SYSCALL_RET   regs[0]
> +#elif defined(__riscv) && __riscv_xlen =3D=3D 64
> +# define ARCH_REGS     struct user_regs_struct
> +# define SYSCALL_NUM   a7
> +# define SYSCALL_RET   a0
>  #elif defined(__hppa__)
>  # define ARCH_REGS     struct user_regs_struct
>  # define SYSCALL_NUM   gr[20]
> @@ -1671,7 +1677,7 @@ void change_syscall(struct __test_metadata *_metada=
ta,
>         EXPECT_EQ(0, ret) {}
>
>  #if defined(__x86_64__) || defined(__i386__) || defined(__powerpc__) || =
\
> -    defined(__s390__) || defined(__hppa__)
> +    defined(__s390__) || defined(__hppa__) || defined(__riscv)
>         {
>                 regs.SYSCALL_NUM =3D syscall;
>         }
> --
> 2.21.0
>

Kernel selftests results:

=E2=9E=9C uname -a
Linux fedora-unleashed 5.2.0-rc7-30159-g2d072d4-dirty #3 SMP Thu Jul 4
20:18:21 -03 2019 riscv64 riscv64 riscv64 GNU/Linux

=E2=9E=9C sudo ./seccomp_bpf
[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] Running 74 tests from 1 test cases.
[ RUN      ] global.mode_strict_support
[       OK ] global.mode_strict_support
[ RUN      ] global.mode_strict_cannot_call_prctl
[       OK ] global.mode_strict_cannot_call_prctl
[ RUN      ] global.no_new_privs_support
[       OK ] global.no_new_privs_support
[ RUN      ] global.mode_filter_support
[       OK ] global.mode_filter_support
[ RUN      ] global.mode_filter_without_nnp
[       OK ] global.mode_filter_without_nnp
[ RUN      ] global.filter_size_limits
[       OK ] global.filter_size_limits
[ RUN      ] global.filter_chain_limits
[       OK ] global.filter_chain_limits
[ RUN      ] global.mode_filter_cannot_move_to_strict
[       OK ] global.mode_filter_cannot_move_to_strict
[ RUN      ] global.mode_filter_get_seccomp
[       OK ] global.mode_filter_get_seccomp
[ RUN      ] global.ALLOW_all
[       OK ] global.ALLOW_all
[ RUN      ] global.empty_prog
[       OK ] global.empty_prog
[ RUN      ] global.log_all
[       OK ] global.log_all
[ RUN      ] global.unknown_ret_is_kill_inside
[       OK ] global.unknown_ret_is_kill_inside
[ RUN      ] global.unknown_ret_is_kill_above_allow
[       OK ] global.unknown_ret_is_kill_above_allow
[ RUN      ] global.KILL_all
[       OK ] global.KILL_all
[ RUN      ] global.KILL_one
[       OK ] global.KILL_one
[ RUN      ] global.KILL_one_arg_one
[       OK ] global.KILL_one_arg_one
[ RUN      ] global.KILL_one_arg_six
[       OK ] global.KILL_one_arg_six
[ RUN      ] global.KILL_thread
[       OK ] global.KILL_thread
[ RUN      ] global.KILL_process
[       OK ] global.KILL_process
[ RUN      ] global.arg_out_of_range
[       OK ] global.arg_out_of_range
[ RUN      ] global.ERRNO_valid
[       OK ] global.ERRNO_valid
[ RUN      ] global.ERRNO_zero
[       OK ] global.ERRNO_zero
[ RUN      ] global.ERRNO_capped
[       OK ] global.ERRNO_capped
[ RUN      ] global.ERRNO_order
[       OK ] global.ERRNO_order
[ RUN      ] TRAP.dfl
[       OK ] TRAP.dfl
[ RUN      ] TRAP.ign
[       OK ] TRAP.ign
[ RUN      ] TRAP.handler
[       OK ] TRAP.handler
[ RUN      ] precedence.allow_ok
[       OK ] precedence.allow_ok
[ RUN      ] precedence.kill_is_highest
[       OK ] precedence.kill_is_highest
[ RUN      ] precedence.kill_is_highest_in_any_order
[       OK ] precedence.kill_is_highest_in_any_order
[ RUN      ] precedence.trap_is_second
[       OK ] precedence.trap_is_second
[ RUN      ] precedence.trap_is_second_in_any_order
[       OK ] precedence.trap_is_second_in_any_order
[ RUN      ] precedence.errno_is_third
[       OK ] precedence.errno_is_third
[ RUN      ] precedence.errno_is_third_in_any_order
[       OK ] precedence.errno_is_third_in_any_order
[ RUN      ] precedence.trace_is_fourth
[       OK ] precedence.trace_is_fourth
[ RUN      ] precedence.trace_is_fourth_in_any_order
[       OK ] precedence.trace_is_fourth_in_any_order
[ RUN      ] precedence.log_is_fifth
[       OK ] precedence.log_is_fifth
[ RUN      ] precedence.log_is_fifth_in_any_order
[       OK ] precedence.log_is_fifth_in_any_order
[ RUN      ] TRACE_poke.read_has_side_effects
[       OK ] TRACE_poke.read_has_side_effects
[ RUN      ] TRACE_poke.getpid_runs_normally
[       OK ] TRACE_poke.getpid_runs_normally
[ RUN      ] TRACE_syscall.ptrace_syscall_redirected
[       OK ] TRACE_syscall.ptrace_syscall_redirected
[ RUN      ] TRACE_syscall.ptrace_syscall_errno
[       OK ] TRACE_syscall.ptrace_syscall_errno
[ RUN      ] TRACE_syscall.ptrace_syscall_faked
[       OK ] TRACE_syscall.ptrace_syscall_faked
[ RUN      ] TRACE_syscall.syscall_allowed
[       OK ] TRACE_syscall.syscall_allowed
[ RUN      ] TRACE_syscall.syscall_redirected
[       OK ] TRACE_syscall.syscall_redirected
[ RUN      ] TRACE_syscall.syscall_errno
[       OK ] TRACE_syscall.syscall_errno
[ RUN      ] TRACE_syscall.syscall_faked
[       OK ] TRACE_syscall.syscall_faked
[ RUN      ] TRACE_syscall.skip_after_RET_TRACE
[       OK ] TRACE_syscall.skip_after_RET_TRACE
[ RUN      ] TRACE_syscall.kill_after_RET_TRACE
[       OK ] TRACE_syscall.kill_after_RET_TRACE
[ RUN      ] TRACE_syscall.skip_after_ptrace
[       OK ] TRACE_syscall.skip_after_ptrace
[ RUN      ] TRACE_syscall.kill_after_ptrace
[       OK ] TRACE_syscall.kill_after_ptrace
[ RUN      ] global.seccomp_syscall
[       OK ] global.seccomp_syscall
[ RUN      ] global.seccomp_syscall_mode_lock
[       OK ] global.seccomp_syscall_mode_lock
[ RUN      ] global.detect_seccomp_filter_flags
[       OK ] global.detect_seccomp_filter_flags
[ RUN      ] global.TSYNC_first
[       OK ] global.TSYNC_first
[ RUN      ] TSYNC.siblings_fail_prctl
[       OK ] TSYNC.siblings_fail_prctl
[ RUN      ] TSYNC.two_siblings_with_ancestor
[       OK ] TSYNC.two_siblings_with_ancestor
[ RUN      ] TSYNC.two_sibling_want_nnp
[       OK ] TSYNC.two_sibling_want_nnp
[ RUN      ] TSYNC.two_siblings_with_no_filter
[       OK ] TSYNC.two_siblings_with_no_filter
[ RUN      ] TSYNC.two_siblings_with_one_divergence
[       OK ] TSYNC.two_siblings_with_one_divergence
[ RUN      ] TSYNC.two_siblings_not_under_filter
[       OK ] TSYNC.two_siblings_not_under_filter
[ RUN      ] global.syscall_restart
[       OK ] global.syscall_restart
[ RUN      ] global.filter_flag_log
[       OK ] global.filter_flag_log
[ RUN      ] global.get_action_avail
[       OK ] global.get_action_avail
[ RUN      ] global.get_metadata
[       OK ] global.get_metadata
[ RUN      ] global.user_notification_basic
[       OK ] global.user_notification_basic
[ RUN      ] global.user_notification_kill_in_middle
[       OK ] global.user_notification_kill_in_middle
[ RUN      ] global.user_notification_signal
[1]    5951 alarm      sudo ./seccomp_bpf

carlosedp in ~ at fedora-unleashed
=E2=9E=9C sudo ./seccomp_benchmark
Calibrating reasonable sample size...
1564584448.964538790 - 1564584448.964529687 =3D 9103
1564584448.964588859 - 1564584448.964575204 =3D 13655
1564584448.964631342 - 1564584448.964604790 =3D 26552
1564584448.964710239 - 1564584448.964644997 =3D 65242
1564584448.964842239 - 1564584448.964726928 =3D 115311
1564584448.965072859 - 1564584448.964857411 =3D 215448
1564584448.965513618 - 1564584448.965089549 =3D 424069
1564584448.966417894 - 1564584448.965532584 =3D 885310
1564584448.968286377 - 1564584448.966443687 =3D 1842690
1564584448.971667549 - 1564584448.968314446 =3D 3353103
1564584448.978288790 - 1564584448.971694101 =3D 6594689
1564584448.991803618 - 1564584448.978313066 =3D 13490552
1564584449.017692308 - 1564584448.991836239 =3D 25856069
1564584449.069651756 - 1564584449.017713549 =3D 51938207
1564584449.173110928 - 1564584449.069673756 =3D 103437172
1564584449.380001204 - 1564584449.173132928 =3D 206868276
1564584449.793857618 - 1564584449.380041411 =3D 413816207
1564584450.625367342 - 1564584449.793898584 =3D 831468758
1564584452.299529411 - 1564584450.625426514 =3D 1674102897
1564584455.665938307 - 1564584452.299592376 =3D 3366345931
1564584462.331777479 - 1564584455.665973962 =3D 6665803517
Benchmarking 33554432 samples...
18.107882743 - 12.075641371 =3D 6032241372
getpid native: 179 ns
34.720410331 - 18.107978605 =3D 16612431726
getpid RET_ALLOW: 495 ns
Estimated seccomp overhead per syscall: 316 n


--=20
________________________________________
Carlos Eduardo de Paula
me@carlosedp.com
http://carlosedp.com
http://twitter.com/carlosedp
Linkedin
________________________________________
