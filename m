Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F99FBAF6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 22:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKMVlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 16:41:14 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:50117 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMVlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 16:41:13 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MA844-1ic77X1dpy-00Bazm; Wed, 13 Nov 2019 22:41:09 +0100
Received: by mail-qk1-f176.google.com with SMTP id e2so3179980qkn.5;
        Wed, 13 Nov 2019 13:41:08 -0800 (PST)
X-Gm-Message-State: APjAAAWUlaX5k/dh9wFHu/VYQujHorLDE1tZJWRaiN7EqHBTtUHZdvuu
        hnPzKvX07XhAG8FNwuxDaSTUA+kjnJYa92OjVQc=
X-Google-Smtp-Source: APXvYqyjRd+a6foxC3+k9qUEopPf1CRknFxQHbHw9aZuys53MC+zVt0jx9JeruKLHIsAWsaGcA9LllqlMRQxiR5o4ug=
X-Received: by 2002:a37:4f0a:: with SMTP id d10mr4703334qkb.286.1573681267104;
 Wed, 13 Nov 2019 13:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20191108210236.1296047-1-arnd@arndb.de>
In-Reply-To: <20191108210236.1296047-1-arnd@arndb.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 13 Nov 2019 22:40:50 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1CbDaPqNsOVOuq2UDPSOwzd2U_WEmmXBMwCOhv1=iaSQ@mail.gmail.com>
Message-ID: <CAK8P3a1CbDaPqNsOVOuq2UDPSOwzd2U_WEmmXBMwCOhv1=iaSQ@mail.gmail.com>
Subject: Re: [PATCH 00/23] y2038 cleanups
To:     y2038 Mailman List <y2038@lists.linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Tony Luck <tony.luck@intel.com>,
        Paul Burton <paul.burton@mips.com>,
        Greentime Hu <green.hu@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        christophe leroy <christophe.leroy@c-s.fr>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        alpha <linux-alpha@vger.kernel.org>, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-um@lists.infradead.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:t9jsa1d3irkSvjYT/rEVzAEkwZVcthQkNq7GL9PWrByG2yn/ofy
 8fgkWFb7yzBDhxggib3MFVAG5e4TExjEbTOk4rBmOFRV8Z0nAydeuemmrZedaWDRbilNXuy
 NmTQNhL2f4T7/p0oM9CgHzRhNyXfyVm+jWuv44PuQ4PFfCAkqAjtWz90qM5ZdfkGAf4n22W
 cO6/64/K+Hbl+/pD4TCAw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4GD3zQCUG/U=:u8KPHFHcLf73169L5bs8bd
 Z3kilw5OQOJ51slVfyv48BfHKjUeXcr+fJ2u45Kzx18zYiu2AKmH6ZjNMBv8Z1Fi95V25C/TC
 fpxwbADUtzoRKZwKTHxmLDwqc/bWFmkKgomoPalGRo18fIa8xiHrYanOdB9pr3ZlCYBpwne8/
 ygyOCaAIeB+5EUMvMd4gTk4JL4j4Lyxr3ghbVkZ5VyqjZ+1EbBbxjw1BbAb32gMNbGLc6QnKD
 XrM6i7uPvn5gDb8ckQDKQ1Zczz6PXXeXCUxXE/12lJNWRl+MJ9kyiHU4m+4JEL37n5bL7zhar
 gqoCvFCmTY8Nirsdm0tNGa7oM70YXf2eD6Yr4ZphgxE0rlP5cht0ROBWRkB5Z67OvFSKPcyy9
 q7aDiaGLMpVsX/TIk5GTKGw/9pr39C5aFcxXQDTsX/EO3Pks3UiL5zYbj7LATgElV/UAWLHNR
 QcQAHYRRSfrrf0nCVnJhOZiuJwYS3i23RjFjF2ZUDtzy85NfJBRdus4N5VtexqszcSpgIqAB0
 Z1helxbHW+pX4eff8B5DwM+xxkqLKVTbbGpbPRr+OyKQBEO5R4uzDHnBECPvkA7oHbAf9IoOG
 Xx/ZdkY79cqP1duDzuGkU/obiqfWEJI4KiUJYg1LqP4RaCH1pHIYkE8ZnJBuq9+wBEvOjbFTi
 BKOk4YBy22M0llu56auY0kznLVVknOE+fS4d2fpHG+skogpTkJ32csRy7QZDKKOHXCrSqIw0N
 eJvSfpBVcYmPhOR6E127MVUrLiXsnZTrgBybVqltTDrEZPpsPPWrn3zQ9jZ5QgKEXuPmHrOVy
 7Txdt9e0cr1UEc6SEe5lI1nmxP/uOHf3iHGiloI5gi9g986J9+vuZ7Q04BEetmXhvJBQfPI7x
 mbb7T23Q5o8NIb6sMiRw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 10:04 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> This is a series of cleanups for the y2038 work, mostly intended
> for namespace cleaning: the kernel defines the traditional
> time_t, timeval and timespec types that often lead to y2038-unsafe
> code. Even though the unsafe usage is mostly gone from the kernel,
> having the types and associated functions around means that we
> can still grow new users, and that we may be missing conversions
> to safe types that actually matter.
>
> As there is no rush on any of these patches, I would either
> queue them up in linux-next through my y2038 branch, or
> Thomas could add them to the tip tree if he wants.
>
> As mentioned in another series, this is part of a larger
> effort to fix all the remaining bits and pieces that are
> not completed yet from the y2038 conversion, and the full
> set can be found at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-endgame
>
> Maintainers, please review and provide Acks.
>
> Let me know if you have any opinion on whether we should do
> the include last two patches of this series or not.
>
>      Arnd
>
> Arnd Bergmann (23):
>   y2038: remove CONFIG_64BIT_TIME
>   y2038: add __kernel_old_timespec and __kernel_old_time_t
>   y2038: vdso: change timeval to __kernel_old_timeval
>   y2038: vdso: change timespec to __kernel_old_timespec
>   y2038: vdso: change time_t to __kernel_old_time_t
>   y2038: vdso: nds32: open-code timespec_add_ns()
>   y2038: vdso: powerpc: avoid timespec references
>   y2038: ipc: remove __kernel_time_t reference from headers
>   y2038: stat: avoid 'time_t' in 'struct stat'
>   y2038: uapi: change __kernel_time_t to __kernel_old_time_t
>   y2038: rusage: use __kernel_old_timeval
>   y2038: syscalls: change remaining timeval to __kernel_old_timeval
>   y2038: socket: remove timespec reference in timestamping
>   y2038: make ns_to_compat_timeval use __kernel_old_timeval
>   y2038: elfcore: Use __kernel_old_timeval for process times
>   y2038: timerfd: Use timespec64 internally
>   y2038: time: avoid timespec usage in settimeofday()
>   y2038: itimer: compat handling to itimer.c
>   y2038: use compat_{get,set}_itimer on alpha
>   y2038: move itimer reset into itimer.c
>   y2038: itimer: change implementation to timespec64
>   [RFC] y2038: itimer: use ktime_t internally
>   y2038: allow disabling time32 system calls

I've dropped the "[RFC] y2038: itimer: use ktime_t internally" patch
for the moment,
and added two other patches from other series:

y2038: remove CONFIG_64BIT_TIME
y2038: socket: use __kernel_old_timespec instead of timespec

Tentatively pushed out the patches with the Acks I have received so
far to my y2038 branch on git.kernel.org so it gets included in linux-next.

If I hear no complaints, I'll send a pull request for the merge window,
along with the compat-ioctl series I have already queued up in the same
branch.

    Arnd
