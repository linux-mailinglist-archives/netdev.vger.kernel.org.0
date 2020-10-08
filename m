Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4192877D5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgJHPrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:47:17 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:52335 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJHPrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:47:08 -0400
Received: from localhost.localdomain ([192.30.34.233]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MlO5j-1knTx10mGD-00ljlP; Thu, 08 Oct 2020 17:46:34 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] timekeeping: remove arch_gettimeoffset
Date:   Thu,  8 Oct 2020 17:46:01 +0200
Message-Id: <20201008154601.1901004-4-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201008154601.1901004-1-arnd@arndb.de>
References: <20201008154601.1901004-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lVCdrFN7aQtlv6ZLGG8sl4e7NVP8pYMq8t6Xp+LJmjGAqhjv355
 q4MgoarNqMA1MJyZGed8HUrhDPimCTN51GlWReO5q938qYnnJ3n34VxHZTUldqH9EZoXYCz
 AKYv8aP/4MsxwQI5Lk9y+uLVThE/ETykexqkuMiiu3dLoKmukX+yP4DqW0iuyTDHDK5E5m6
 z4o9pz7nEEHZ2+IsY2liw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:F4i4G34RXK0=:2SwHRDvPFj+/gX7jtv1jIC
 agUS9ThPenwjFcPnOWf+ki8+JW/uOsQMWH3KWlJAXfJHmZ11KNq6Gu01qoj0TpuNM1w2RXdMw
 Y3UZRJsQ+VRH7inR2qtzjC2pJVQgHa3fXiNjHhoDJ3uEEhrDFeU1iADqCSeZiD3mpmYDjisb3
 kskbjNruhSs4Ofdgbmr7zmZ+uoIP/Xa5FgDZZYc9Evmy8TAcILUNPqPMjldxqQ5grJQUfbH23
 3+dDgvAEQh1hztnhkyIA6OImlGmXAERGumb+ND+ivsXwTuGWWw990ITI77v/hfTGDTlDUWHs2
 MxLRFjWBuU6kz3G+c7Z2AGT2WU/aKHxXQHegziU209jfpnWvBJqBtb8EcYm+W1ucLPNf+1NZr
 M6RsOQgLRHdU7Xm/I1R/g57a69N57WBV1crJvP2FNjpt7Ug4s+4ZUSG0fTdYWFiQjBzjTmd5w
 +LcAhZHyRjxt0rfYy28VJ9aJCIGW2qBjWSRkWsdU89HmXctPMRSApvmRcrTN4kFgUXM0gcWKs
 +HLxOW39VVcO7Bp/HWuAH957//NF/UFVOmuXsYuoperjo5bPqVMrXrYjFlmwjglLD4VigIp55
 z+WUERNVfsmEvb8nUKXrpKHXAoi3rOx9+YLpe/TzQpB7F+/fNWuRg8I0shfHrEnDhbz0SqaYc
 o26bEsKayQL7DtDOgB9HgkTA0k8OhvmSmNZVAuG1NHFpAVtY7UUVvatlMkfPFVShUZ9CO3NIx
 onMSHMA0U+4jbo6cthUcZJC5LLLFi124y55zG9kCNF7HvB2Q6KfaX8pWYPAtOa7Q/yH5zo9oO
 Nig6QaFe9O4MAQMGQix/u4D8QDd7uG4cpzG111fdntyGqst2otcbZdoG7sy0hys2l1EfK53
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Arm EBSA110 gone, nothing uses it any more, so the corresponding
code and the Kconfig option can be removed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../time/modern-timekeeping/arch-support.txt  | 33 -------------------
 drivers/Makefile                              |  2 --
 drivers/clocksource/Kconfig                   |  2 +-
 include/linux/time.h                          | 13 --------
 kernel/time/Kconfig                           |  9 -----
 kernel/time/clocksource.c                     |  8 -----
 kernel/time/timekeeping.c                     | 25 +-------------
 kernel/trace/Kconfig                          |  2 --
 8 files changed, 2 insertions(+), 92 deletions(-)
 delete mode 100644 Documentation/features/time/modern-timekeeping/arch-support.txt

diff --git a/Documentation/features/time/modern-timekeeping/arch-support.txt b/Documentation/features/time/modern-timekeeping/arch-support.txt
deleted file mode 100644
index a84c3b9d9a94..000000000000
--- a/Documentation/features/time/modern-timekeeping/arch-support.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-#
-# Feature name:          modern-timekeeping
-#         Kconfig:       !ARCH_USES_GETTIMEOFFSET
-#         description:   arch does not use arch_gettimeoffset() anymore
-#
-    -----------------------
-    |         arch |status|
-    -----------------------
-    |       alpha: |  ok  |
-    |         arc: |  ok  |
-    |         arm: | TODO |
-    |       arm64: |  ok  |
-    |         c6x: |  ok  |
-    |        csky: |  ok  |
-    |       h8300: |  ok  |
-    |     hexagon: |  ok  |
-    |        ia64: |  ok  |
-    |        m68k: |  ok  |
-    |  microblaze: |  ok  |
-    |        mips: |  ok  |
-    |       nds32: |  ok  |
-    |       nios2: |  ok  |
-    |    openrisc: |  ok  |
-    |      parisc: |  ok  |
-    |     powerpc: |  ok  |
-    |       riscv: |  ok  |
-    |        s390: |  ok  |
-    |          sh: |  ok  |
-    |       sparc: |  ok  |
-    |          um: |  ok  |
-    |         x86: |  ok  |
-    |      xtensa: |  ok  |
-    -----------------------
diff --git a/drivers/Makefile b/drivers/Makefile
index c0cd1b9075e3..4ff1e4459512 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -135,9 +135,7 @@ obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
-ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 obj-y				+= clocksource/
-endif
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 68b087bff59c..764936bfcb2c 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -563,7 +563,7 @@ config CLKSRC_QCOM
 
 config CLKSRC_VERSATILE
 	bool "ARM Versatile (Express) reference platforms clock source" if COMPILE_TEST
-	depends on GENERIC_SCHED_CLOCK && !ARCH_USES_GETTIMEOFFSET
+	depends on GENERIC_SCHED_CLOCK
 	select TIMER_OF
 	default y if (ARCH_VEXPRESS || ARCH_VERSATILE) && ARM
 	help
diff --git a/include/linux/time.h b/include/linux/time.h
index b142cb5f5a53..16cf4522d6f3 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -21,19 +21,6 @@ extern time64_t mktime64(const unsigned int year, const unsigned int mon,
 			const unsigned int day, const unsigned int hour,
 			const unsigned int min, const unsigned int sec);
 
-/* Some architectures do not supply their own clocksource.
- * This is mainly the case in architectures that get their
- * inter-tick times by reading the counter on their interval
- * timer. Since these timers wrap every tick, they're not really
- * useful as clocksources. Wrapping them to act like one is possible
- * but not very efficient. So we provide a callout these arches
- * can implement for use with the jiffies clocksource to provide
- * finer then tick granular time.
- */
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-extern u32 (*arch_gettimeoffset)(void);
-#endif
-
 #ifdef CONFIG_POSIX_TIMERS
 extern void clear_itimer(void);
 #else
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index a09b1d61df6a..51d298ccbe05 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -26,10 +26,6 @@ config CLOCKSOURCE_VALIDATE_LAST_CYCLE
 config GENERIC_TIME_VSYSCALL
 	bool
 
-# Old style timekeeping
-config ARCH_USES_GETTIMEOFFSET
-	bool
-
 # The generic clock events infrastructure
 config GENERIC_CLOCKEVENTS
 	bool
@@ -72,7 +68,6 @@ config TICK_ONESHOT
 
 config NO_HZ_COMMON
 	bool
-	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 
 choice
@@ -87,7 +82,6 @@ config HZ_PERIODIC
 
 config NO_HZ_IDLE
 	bool "Idle dynticks system (tickless idle)"
-	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select NO_HZ_COMMON
 	help
 	  This option enables a tickless idle system: timer interrupts
@@ -99,7 +93,6 @@ config NO_HZ_IDLE
 config NO_HZ_FULL
 	bool "Full dynticks system (tickless)"
 	# NO_HZ_COMMON dependency
-	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	# We need at least one periodic CPU for timekeeping
 	depends on SMP
 	depends on HAVE_CONTEXT_TRACKING
@@ -158,7 +151,6 @@ config CONTEXT_TRACKING_FORCE
 
 config NO_HZ
 	bool "Old Idle dynticks config"
-	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	help
 	  This is the old config entry that enables dynticks idle.
 	  We keep it around for a little while to enforce backward
@@ -166,7 +158,6 @@ config NO_HZ
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
-	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables high resolution timer support. If your
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 02441ead3c3b..cce484a2cc7c 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -705,8 +705,6 @@ static inline void clocksource_update_max_deferment(struct clocksource *cs)
 						&cs->max_cycles);
 }
 
-#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
-
 static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
 {
 	struct clocksource *cs;
@@ -798,12 +796,6 @@ static void clocksource_select_fallback(void)
 	__clocksource_select(true);
 }
 
-#else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
-static inline void clocksource_select(void) { }
-static inline void clocksource_select_fallback(void) { }
-
-#endif
-
 /*
  * clocksource_done_booting - Called near the end of core bootup
  *
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4c47f388a83f..cf99a9a00716 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -352,13 +352,6 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 
 /* Timekeeper helper functions. */
 
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-static u32 default_arch_gettimeoffset(void) { return 0; }
-u32 (*arch_gettimeoffset)(void) = default_arch_gettimeoffset;
-#else
-static inline u32 arch_gettimeoffset(void) { return 0; }
-#endif
-
 static inline u64 timekeeping_delta_to_ns(const struct tk_read_base *tkr, u64 delta)
 {
 	u64 nsec;
@@ -366,8 +359,7 @@ static inline u64 timekeeping_delta_to_ns(const struct tk_read_base *tkr, u64 de
 	nsec = delta * tkr->mult + tkr->xtime_nsec;
 	nsec >>= tkr->shift;
 
-	/* If arch requires, add in get_arch_timeoffset() */
-	return nsec + arch_gettimeoffset();
+	return nsec;
 }
 
 static inline u64 timekeeping_get_ns(const struct tk_read_base *tkr)
@@ -707,16 +699,8 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	tk->tkr_raw.cycle_last  = cycle_now;
 
 	tk->tkr_mono.xtime_nsec += delta * tk->tkr_mono.mult;
-
-	/* If arch requires, add in get_arch_timeoffset() */
-	tk->tkr_mono.xtime_nsec += (u64)arch_gettimeoffset() << tk->tkr_mono.shift;
-
-
 	tk->tkr_raw.xtime_nsec += delta * tk->tkr_raw.mult;
 
-	/* If arch requires, add in get_arch_timeoffset() */
-	tk->tkr_raw.xtime_nsec += (u64)arch_gettimeoffset() << tk->tkr_raw.shift;
-
 	tk_normalize_xtime(tk);
 }
 
@@ -2062,19 +2046,12 @@ static void timekeeping_advance(enum timekeeping_adv_mode mode)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = real_tk->cycle_interval;
-
-	if (mode != TK_ADV_TICK)
-		goto out;
-#else
 	offset = clocksource_delta(tk_clock_read(&tk->tkr_mono),
 				   tk->tkr_mono.cycle_last, tk->tkr_mono.mask);
 
 	/* Check if there's really nothing to do */
 	if (offset < real_tk->cycle_interval && mode == TK_ADV_TICK)
 		goto out;
-#endif
 
 	/* Do some additional sanity checking */
 	timekeeping_check_update(tk, offset);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a4020c0b4508..b74099f990bf 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -253,7 +253,6 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on !ARCH_USES_GETTIMEOFFSET
 	select TRACE_IRQFLAGS
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
@@ -277,7 +276,6 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPTION
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
-- 
2.27.0

