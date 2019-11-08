Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9439F591E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbfKHVFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:05:37 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:38665 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfKHVFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:05:36 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MI41P-1ifa9R3rIV-00FECL; Fri, 08 Nov 2019 22:03:03 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        rth@twiddle.net, tony.luck@intel.com, paul.burton@mips.com,
        green.hu@gmail.com, deller@gmx.de, mpe@ellerman.id.au,
        davem@davemloft.net, tglx@linutronix.de, x86@kernel.org,
        jdike@addtoit.com, richard@nod.at, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, john.stultz@linaro.org, sboyd@kernel.org,
        rostedt@goodmis.org, vincenzo.frascino@arm.com,
        paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        peterz@infradead.org, will@kernel.org, deepa.kernel@gmail.com,
        christian@brauner.io, heiko.carstens@de.ibm.com,
        christophe.leroy@c-s.fr, ebiederm@xmission.com,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org
Subject: [PATCH 00/23] y2038 cleanups
Date:   Fri,  8 Nov 2019 22:02:21 +0100
Message-Id: <20191108210236.1296047-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:UnBnEVvh9e/TAlbVJpAgl+cZfINqrWh9dLOxhM2cR8aLh8bxi43
 imnX6NUaeePS5+DRA0WRYUJVamsiPbbVcIxpp/4FOrH5eYIasgtQ9F4iNEhxTjL7CjcCc5K
 bAv59di7IK248c9R001Bzfk5n9zBi6XSKGbbURpyvKXfff1XY6BWVKsSxLxE879MSpi2NAc
 hQzqPBvdAyeO+K+Sge1xw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OIDj0+r1Q9A=:9gN4BqFLWG42/ujpgO6Cgr
 o8zqBPZmLIUIEnDlrrAXeH2vLeBpIadNXhV86RgylTicv9xsmYlpVaFpBMf/H/Yjlzbw54cpy
 eh/U17TACQhr/ys8Bi+1eshVGdQxS5ivhF8awvsaZnAXg9mNAA8jkqXgpcpwWt367C/8Kd86R
 PArvSuqzyeR9kXxr8BvqUTmoaE4g6Rd8F0lY4P97kcm/hZDDTFU9lm0mHxnM0bHAyM+SvOHYd
 iw+439TjI1JHDeQqBpLukAr0wnd9IY2f05cEO8b48Hy7kYtbaI2rom9bTJZ3BbKszOykd7H0q
 oK4Ya32pPC2rfGc0OBMvlJAfW+U7J0Y2JHzAkyUMd/7/mal+bfzBkSg8A0O6/exDyl/Z/WNJy
 m3TRmxcGqeD+mrruFnCOYH9J91b9cbHcwtFZD/CAY9jd9786DVfTW8CKd5BLmZRsHl71EyEi5
 K6mfaAx63kT3i52V/5zPjVHi/xplJ3YpYGzCTEeY7jgkxp6i6NqIi2ghC/8j5/eYAtCM51h3d
 Z8Ob7p2gDLZwWhpdQ4b78C5ehph2lPjnzxiqzxTyMT+MD96QhPQWmWVKsWIK0FAs0qvDqsP2a
 GKGNlVHb+qr7JyGt+fF9+SvIKG13x6Bhw26DKuQtLgfO6qnyM9jMr6nN5/5EV/9nPPKgeZMi6
 a1svux7RWVOd64AYgjbwsp2PjdbU/xpWDDSVGOMhQmktNt60nxmbkWIkGbMHoosfsFgXXEfB4
 i7LmjSLuzVGAOXL0n7HULZV9tfkZIv5cbllBdYB5FinD1QYgQQG36yK6WhFCFvCPmv1hlou8U
 ye11gYsvTwOfF7tDpZ1QmTJ1v1Q1y1VYzfbIpHyUIMvlz8YcXL2vDgC6IMOdob8B3C6bh7EPJ
 j24sn73RDOt7PznprOsg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a series of cleanups for the y2038 work, mostly intended
for namespace cleaning: the kernel defines the traditional
time_t, timeval and timespec types that often lead to y2038-unsafe
code. Even though the unsafe usage is mostly gone from the kernel,
having the types and associated functions around means that we
can still grow new users, and that we may be missing conversions
to safe types that actually matter.

As there is no rush on any of these patches, I would either
queue them up in linux-next through my y2038 branch, or
Thomas could add them to the tip tree if he wants.

As mentioned in another series, this is part of a larger
effort to fix all the remaining bits and pieces that are
not completed yet from the y2038 conversion, and the full
set can be found at:

https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-endgame

Maintainers, please review and provide Acks.

Let me know if you have any opinion on whether we should do
the include last two patches of this series or not.

     Arnd

Arnd Bergmann (23):
  y2038: remove CONFIG_64BIT_TIME
  y2038: add __kernel_old_timespec and __kernel_old_time_t
  y2038: vdso: change timeval to __kernel_old_timeval
  y2038: vdso: change timespec to __kernel_old_timespec
  y2038: vdso: change time_t to __kernel_old_time_t
  y2038: vdso: nds32: open-code timespec_add_ns()
  y2038: vdso: powerpc: avoid timespec references
  y2038: ipc: remove __kernel_time_t reference from headers
  y2038: stat: avoid 'time_t' in 'struct stat'
  y2038: uapi: change __kernel_time_t to __kernel_old_time_t
  y2038: rusage: use __kernel_old_timeval
  y2038: syscalls: change remaining timeval to __kernel_old_timeval
  y2038: socket: remove timespec reference in timestamping
  y2038: make ns_to_compat_timeval use __kernel_old_timeval
  y2038: elfcore: Use __kernel_old_timeval for process times
  y2038: timerfd: Use timespec64 internally
  y2038: time: avoid timespec usage in settimeofday()
  y2038: itimer: compat handling to itimer.c
  y2038: use compat_{get,set}_itimer on alpha
  y2038: move itimer reset into itimer.c
  y2038: itimer: change implementation to timespec64
  [RFC] y2038: itimer: use ktime_t internally
  y2038: allow disabling time32 system calls

 arch/Kconfig                              |  11 +-
 arch/alpha/kernel/osf_sys.c               |  67 +-----
 arch/alpha/kernel/syscalls/syscall.tbl    |   4 +-
 arch/ia64/kernel/asm-offsets.c            |   2 +-
 arch/mips/include/uapi/asm/msgbuf.h       |   6 +-
 arch/mips/include/uapi/asm/sembuf.h       |   4 +-
 arch/mips/include/uapi/asm/shmbuf.h       |   6 +-
 arch/mips/include/uapi/asm/stat.h         |  16 +-
 arch/mips/kernel/binfmt_elfn32.c          |   4 +-
 arch/mips/kernel/binfmt_elfo32.c          |   4 +-
 arch/nds32/kernel/vdso/gettimeofday.c     |  61 +++--
 arch/parisc/include/uapi/asm/msgbuf.h     |   6 +-
 arch/parisc/include/uapi/asm/sembuf.h     |   4 +-
 arch/parisc/include/uapi/asm/shmbuf.h     |   6 +-
 arch/powerpc/include/asm/asm-prototypes.h |   3 +-
 arch/powerpc/include/asm/vdso_datapage.h  |   6 +-
 arch/powerpc/include/uapi/asm/msgbuf.h    |   6 +-
 arch/powerpc/include/uapi/asm/sembuf.h    |   4 +-
 arch/powerpc/include/uapi/asm/shmbuf.h    |   6 +-
 arch/powerpc/include/uapi/asm/stat.h      |   2 +-
 arch/powerpc/kernel/asm-offsets.c         |  18 +-
 arch/powerpc/kernel/syscalls.c            |   4 +-
 arch/powerpc/kernel/time.c                |   5 +-
 arch/powerpc/kernel/vdso32/gettimeofday.S |   6 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S |   8 +-
 arch/sparc/include/uapi/asm/msgbuf.h      |   6 +-
 arch/sparc/include/uapi/asm/sembuf.h      |   4 +-
 arch/sparc/include/uapi/asm/shmbuf.h      |   6 +-
 arch/sparc/include/uapi/asm/stat.h        |  24 +-
 arch/sparc/vdso/vclock_gettime.c          |  36 +--
 arch/x86/entry/vdso/vclock_gettime.c      |   6 +-
 arch/x86/entry/vsyscall/vsyscall_64.c     |   4 +-
 arch/x86/include/uapi/asm/msgbuf.h        |   6 +-
 arch/x86/include/uapi/asm/sembuf.h        |   4 +-
 arch/x86/include/uapi/asm/shmbuf.h        |   6 +-
 arch/x86/um/vdso/um_vdso.c                |  12 +-
 fs/aio.c                                  |   2 +-
 fs/binfmt_elf.c                           |  12 +-
 fs/binfmt_elf_fdpic.c                     |  12 +-
 fs/compat_binfmt_elf.c                    |   4 +-
 fs/select.c                               |  10 +-
 fs/timerfd.c                              |  14 +-
 fs/utimes.c                               |   8 +-
 include/linux/compat.h                    |  19 +-
 include/linux/syscalls.h                  |  16 +-
 include/linux/time.h                      |   9 +-
 include/linux/time32.h                    |   2 +-
 include/linux/types.h                     |   2 +-
 include/trace/events/timer.h              |  29 +--
 include/uapi/asm-generic/msgbuf.h         |  12 +-
 include/uapi/asm-generic/posix_types.h    |   1 +
 include/uapi/asm-generic/sembuf.h         |   7 +-
 include/uapi/asm-generic/shmbuf.h         |  12 +-
 include/uapi/linux/cyclades.h             |   6 +-
 include/uapi/linux/elfcore.h              |   8 +-
 include/uapi/linux/errqueue.h             |   7 +
 include/uapi/linux/msg.h                  |   6 +-
 include/uapi/linux/ppp_defs.h             |   4 +-
 include/uapi/linux/resource.h             |   4 +-
 include/uapi/linux/sem.h                  |   4 +-
 include/uapi/linux/shm.h                  |   6 +-
 include/uapi/linux/time.h                 |   6 +-
 include/uapi/linux/time_types.h           |   5 +
 include/uapi/linux/utime.h                |   4 +-
 ipc/syscall.c                             |   2 +-
 kernel/compat.c                           |  24 --
 kernel/power/power.h                      |   2 +-
 kernel/sys.c                              |   4 +-
 kernel/sys_ni.c                           |  23 ++
 kernel/time/hrtimer.c                     |   2 +-
 kernel/time/itimer.c                      | 280 ++++++++++++++--------
 kernel/time/time.c                        |  32 ++-
 lib/vdso/gettimeofday.c                   |   4 +-
 net/core/scm.c                            |   6 +-
 net/socket.c                              |   2 +-
 security/selinux/hooks.c                  |  10 +-
 76 files changed, 501 insertions(+), 504 deletions(-)

-- 
2.20.0

Cc: rth@twiddle.net
Cc: tony.luck@intel.com
Cc: paul.burton@mips.com
Cc: green.hu@gmail.com
Cc: deller@gmx.de
Cc: mpe@ellerman.id.au
Cc: davem@davemloft.net
Cc: tglx@linutronix.de
Cc: x86@kernel.org
Cc: jdike@addtoit.com
Cc: richard@nod.at
Cc: viro@zeniv.linux.org.uk
Cc: bcrl@kvack.org
Cc: john.stultz@linaro.org
Cc: sboyd@kernel.org
Cc: rostedt@goodmis.org
Cc: arnd@arndb.de
Cc: vincenzo.frascino@arm.com
Cc: paul@paul-moore.com
Cc: sds@tycho.nsa.gov
Cc: eparis@parisplace.org
Cc: peterz@infradead.org
Cc: will@kernel.org
Cc: deepa.kernel@gmail.com
Cc: christian@brauner.io
Cc: heiko.carstens@de.ibm.com
Cc: christophe.leroy@c-s.fr
Cc: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-alpha@vger.kernel.org>
Cc: linux-ia64@vger.kernel.org>
Cc: linux-mips@vger.kernel.org>
Cc: linux-parisc@vger.kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org>
Cc: sparclinux@vger.kernel.org>
Cc: linux-um@lists.infradead.org>
Cc: linux-fsdevel@vger.kernel.org>
Cc: linux-aio@kvack.org>
Cc: linux-api@vger.kernel.org>
Cc: linux-arch@vger.kernel.org>
Cc: netdev@vger.kernel.org>
Cc: selinux@vger.kernel.org>

