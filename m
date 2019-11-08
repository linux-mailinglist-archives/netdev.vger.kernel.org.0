Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC5F5899
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbfKHUfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:35:25 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:51245 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfKHUfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:35:24 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N33V5-1hlqNF3sD7-013KFA; Fri, 08 Nov 2019 21:34:45 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Corey Minyard <minyard@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linuxppc-dev@lists.ozlabs.org,
        openipmi-developer@lists.sourceforge.net,
        linux-input@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH 0/8] y2038: bug fixes from y2038 work
Date:   Fri,  8 Nov 2019 21:34:23 +0100
Message-Id: <20191108203435.112759-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:onYIVYfp5Mx1RrUFk0F9wq5iI+dqorjM5aBE72U93aTSbPGsiEH
 OgqmaTzcj80pu1s1hMBgp49QlgyJ7rNubi4HQ+SNtLKHlNHw7UDpadkGCFY+GcDVw41DVye
 FrU7tCGHXGj1wcbqKgqiBp/hv63ZhOmHxE5v1qZQbLWrHUnVlooIDiEJVfnnnRlsetqKDMj
 6/PfgmoNhjrn6CYi3P+AA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V3pT7w4OZMM=:zYEUjZknHOmFruRY3Tk/pl
 wRrkB9EkTxkg3VX6P5V+Sz7Mzw/U9rqfhCLPbV5K7bnCIOm6PPWp9uwvkvJPRNr/xaYhNNVDL
 HBhOO1RU2ihx43VfyjSymHoIRA4e8J6kXO0n+ff3+SvsuXV67dHzWdiJgJdF5fcHeuULLdOGM
 wEkUwrKPcDyYR2IP5FsRgltiX/Lq+Bh0rqiRA3p94HrILlG/sn6iSj9ZvDGEfMeJ1paYNCGl7
 K1GkrVql1wtqYBsrKBx9hibZ6cZ759vK8OskStBQQf1G8iFUeRCEmpVMUAPZ9sgkGKd4ETeFV
 xUJ//Vddt0O+5XMv4EBvpHgRBuqY/HuHqky1CIPHSbRCEVNsobz4XM9t1mJvfH1c/MD7a+azu
 h3okZcNpYLzCLyuML9cb16m1MQqIcXaN8ql7W7+jhj6tRhSNNWwRN3dvgapg9McTZLBmzu+KF
 7POpxVXIIIVfC3tCBYedhED2kopxojiTYfI2bZs6Gx9NaLdGQTabvZX5bYqIL3/SOPdU1gH6U
 TWAYwU83i4p7DEqD90Lubci9HhuB08X+QOBaBt0IAJEEDtwNU5XLD+lSkHcnluCAUiO9Ltu3E
 QgtdeFAFmvb6TgiVKr69oZrPobspdM0HrD76sFjegnfjPXFgCXF2exI+am2mash87OEVn3aB0
 KQrqKLUiNdfqa64AJ9txSQpXu/7YXUnedz76RMpQ/YZ+iaZ5okFTc3k170y2RvKY1VL8oWeM4
 T0FHUMaj1O35XhR0Cp6Rg6yqR9Top24p39TPTuI3jSJjBXQo/xRwKeAUKp7cOUUulMnWmij4c
 iyZ7TQZCCMQhwMHmv0ImigrqmoaXKuUYkolCj7pl5gSE30zlpfyPWeHE+jdOO8CqVztGI6UO/
 ibGTxu1AjHd9Ore1WJPg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've gone through the remaining uses of time_t etc and come up with a
set of 90 patches of varying complexity and importance, to the point
of being able to remove the old time_t/timeval/timespec from the kernel
headers completely.

This set includes the eight patches that I think should be merged
right away and backported into stable kernels if possible.

Please apply individual patches to the respective maintainer trees
for either v5.4 or v5.5 as appropriate.

For reference, the full series of 90 patches can be found at
https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-endgame

      Arnd

Arnd Bergmann (8):
  y2038: timex: remove incorrect time_t truncation
  timekeeping: optimize ns_to_timespec64
  powerpc: fix vdso32 for ppc64le
  ipmi: kill off 'timespec' usage again
  netfilter: xt_time: use time64_t
  lp: fix sparc64 LPSETTIMEOUT ioctl
  ppdev: fix PPGETTIME/PPSETTIME ioctls
  Input: input_event: fix struct padding on sparc64

 arch/powerpc/kernel/vdso32/gettimeofday.S |  2 +-
 drivers/char/ipmi/ipmi_si_intf.c          | 40 ++++++++---------------
 drivers/char/lp.c                         |  4 +++
 drivers/char/ppdev.c                      | 16 ++++++---
 drivers/input/evdev.c                     |  3 ++
 drivers/input/misc/uinput.c               |  3 ++
 include/uapi/linux/input.h                |  1 +
 kernel/time/ntp.c                         |  2 +-
 kernel/time/time.c                        | 21 +++++++-----
 net/netfilter/xt_time.c                   | 19 ++++++-----
 10 files changed, 61 insertions(+), 50 deletions(-)

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Corey Minyard <minyard@acm.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: openipmi-developer@lists.sourceforge.net
Cc: linux-input@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Cc: sparclinux@vger.kernel.org

-- 
2.20.0

