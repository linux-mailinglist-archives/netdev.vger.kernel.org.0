Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC5DF5942
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfKHVIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:08:46 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:43469 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKHVIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:08:45 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mv2pC-1hcBKf32ie-00r1bf; Fri, 08 Nov 2019 22:08:29 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        netdev@vger.kernel.org
Subject: [PATCH 01/23] y2038: remove CONFIG_64BIT_TIME
Date:   Fri,  8 Nov 2019 22:07:21 +0100
Message-Id: <20191108210824.1534248-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108210236.1296047-1-arnd@arndb.de>
References: <20191108210236.1296047-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:H2tiCmOPXYw8s1qtnX/2cKq67XKFxksIA+eJap+sUEcVUWZWb+Y
 8qBIXKy6r6bmI22vV77RnVQUuIj7iwJikQx6acqRH7nHsZTPjpxMcyvlS/WoqsCQJhc+0bI
 X/svWIrOH3ivqFs2+WfQmIBo7M1x9Coag63s5V0Nz6hOszrZ4K8t595MS92PQ3lbhuIvQop
 IEsAxjRtAtCpbkolITw/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ga9diiCQdOk=:i8WuivqPZNstauNeRgqfYF
 XxoGLuFx6ewBMCyp9wIrs18C/yqZN+6404yWmhT82msLSJeX2vSKHrAFnYnzg/8MdJ803WspP
 SeKEga2VQG3SKNkMdXbrPU8qlEGog0T3nd0aK+j7NxqbixbqnfRcgFyPRznM6I7CFpYXuhNG3
 hwBLs01rZjsBnn6CjQbQvPkvcNUXdW4u09kN5yoJ3EjXlItrfLObZSd7JLBUZC9+TXFRQf3z8
 Uq6KzhBTPCtKpmVHbGKmR5PAcuZIQ+oh8BpDo+r9+8KXGg7U6ePPPvFj5bdJU/CmGbTnbxuHK
 4lvg0GaC/SouPKAT5KxCVR9w3ltBoVdSyEx/nDFNYTVU8nM1oFoU/mwhdQzyQYh87cuQZ3dUc
 c8xyLsvMCae1P4y9EjSF3z3U8KMBmlNOqBokGX/GVYghcOR2zvJyVT3IsepSNkfW+CHBlqWCV
 AIW9zf/jfzxipCBsntrLzHma+84YW0ajLN6J0pn7ZB+H3tlMdOM1YDRwhuX3ABeqSPv7Vjorv
 Xf11OoHQuaKkncSn9mfJRaPD050DbTjRckQjyKxRDHw8uDB0GxqHcv22gE5Qi051n44ItIxdM
 09xIWJQQlN+Dz0XlXU2/h4Fqi40/NAAQm8m21mzw0BzuiYw+yEVDmTDC+aqhBAFTTsJU6bLOy
 j++yfRwfHZh0lgIcWboO7bYTO6gWwQ64I4U1YWyipuR571DU1pL3429Ca8FZOMrbMFG9g8hrp
 ugSbD3CgtnzJmTpy41Xc8CWytO8HqrSc7JdKcb4U1HK4c5XwlcVg+L3stkOQBKmy4qlP/0GIb
 12JmTyvu9QAMNB2OeZwl9LfD8GHfEoWlW7JbT2kVWaPgydoIjMugiKOPDMqwCP0gtbbePHmlG
 5GfM8WBlOtDbzNDlEwQQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CONFIG_64BIT_TIME option is defined on all architectures, and can
be removed for simplicity now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig          | 8 --------
 fs/aio.c              | 2 +-
 ipc/syscall.c         | 2 +-
 kernel/time/hrtimer.c | 2 +-
 kernel/time/time.c    | 4 ++--
 net/socket.c          | 2 +-
 6 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 5f8a5d84dbbe..0e1fded2940e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -796,14 +796,6 @@ config OLD_SIGACTION
 config COMPAT_OLD_SIGACTION
 	bool
 
-config 64BIT_TIME
-	def_bool y
-	help
-	  This should be selected by all architectures that need to support
-	  new system calls with a 64-bit time_t. This is relevant on all 32-bit
-	  architectures, and 64-bit architectures as part of compat syscall
-	  handling.
-
 config COMPAT_32BIT_TIME
 	def_bool !64BIT || COMPAT
 	help
diff --git a/fs/aio.c b/fs/aio.c
index 01e0fb9ae45a..447e3a0c572c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2056,7 +2056,7 @@ static long do_io_getevents(aio_context_t ctx_id,
  *	specifies an infinite timeout. Note that the timeout pointed to by
  *	timeout is relative.  Will fail with -ENOSYS if not implemented.
  */
-#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 
 SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 581bdff4e7c5..dfb0e988d542 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -30,7 +30,7 @@ int ksys_ipc(unsigned int call, int first, unsigned long second,
 		return ksys_semtimedop(first, (struct sembuf __user *)ptr,
 				       second, NULL);
 	case SEMTIMEDOP:
-		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+		if (IS_ENABLED(CONFIG_64BIT))
 			return ksys_semtimedop(first, ptr, second,
 			        (const struct __kernel_timespec __user *)fifth);
 		else if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 65605530ee34..9e20873148c6 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1940,7 +1940,7 @@ long hrtimer_nanosleep(const struct timespec64 *rqtp,
 	return ret;
 }
 
-#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 
 SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 		struct __kernel_timespec __user *, rmtp)
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 45a358953f09..ddbddf504c23 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -267,7 +267,7 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
 }
 #endif
 
-#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 SYSCALL_DEFINE1(adjtimex, struct __kernel_timex __user *, txc_p)
 {
 	struct __kernel_timex txc;		/* Local copy of parameter */
@@ -884,7 +884,7 @@ int get_timespec64(struct timespec64 *ts,
 	ts->tv_sec = kts.tv_sec;
 
 	/* Zero out the padding for 32 bit systems or in compat mode */
-	if (IS_ENABLED(CONFIG_64BIT_TIME) && in_compat_syscall())
+	if (in_compat_syscall())
 		kts.tv_nsec &= 0xFFFFFFFFUL;
 
 	ts->tv_nsec = kts.tv_nsec;
diff --git a/net/socket.c b/net/socket.c
index 6a9ab7a8b1d2..98f6544b0096 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2833,7 +2833,7 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 				    a[2], true);
 		break;
 	case SYS_RECVMMSG:
-		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+		if (IS_ENABLED(CONFIG_64BIT))
 			err = __sys_recvmmsg(a0, (struct mmsghdr __user *)a1,
 					     a[2], a[3],
 					     (struct __kernel_timespec __user *)a[4],
-- 
2.20.0

