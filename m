Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA55813B9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 15:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiGZNBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiGZNBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:01:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E6912AE8;
        Tue, 26 Jul 2022 06:01:15 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h8so20032309wrw.1;
        Tue, 26 Jul 2022 06:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Tfl3I6SlGsCT++NoswqP98O05LISpyk4WYgSlpLXEdI=;
        b=JEOMF9fXUySZudeoj0x/33aa3Pjb0Q7klWAhpeNeUFmKqCCzyZkeaMlGPN+mRpjFWi
         0esyBA+S3WRwoREPnJdlRSZLM7o0ObGommnL8NbqNZPttYnoD4uHpip3NnAqPhnmt3zT
         xAzF3orQ/IZvd5iJLJqqunzOaywHRQ491vE+RX3+rqPhQIxlGcs2UkXvAhjkMh+Bcewp
         MkF7Nd9rRX6tAa/jeqKE1keEkVYWx8bRr2BoWlKRK4xUkFD7/mTFS7oXxD605YWhCKkc
         PE9TBPuzabik1Vkx2gT0bDh1Q8J+e+NTQ3ntwe0f3c0SCCW6SRQnc1mdlIgHwUx51Y/E
         Ji2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Tfl3I6SlGsCT++NoswqP98O05LISpyk4WYgSlpLXEdI=;
        b=wtSg68LLrk/GEieuFXPe7+2d1OiNlDY9fwD4sTakSk9Q2XJ3iZi/fcmAJ1bH8yJXKM
         2xWxXVHOFlNq6/0vUCz+Zt6nIocBmxv0nODJmhmSOj4w2EJlDlxxVHgiG5SYuE36xQ4w
         KrUOH8wcqqyKalIaQkcfuE6/1IquGO1E8LjHJWKPX8Auh5bd87lDFrOJpxHmPuOqLJW6
         1EoJ8TtSSNLldZ8lk2dhYxDI3leXQJZrJn/vElRomLcD9cDmlgZuRgcwuoxLvUQ3FJxN
         fN80gSYkr17OvU7pKRat1/8KpjZ+J1BL1YJUofCw7iKzUuZbwRaJF0VgAdPE7WMcWy3P
         1xZw==
X-Gm-Message-State: AJIora8estcaVAl2AM7AoE0L+2JBj2xnkLLgVqrb9QElpTKduLZ3FRzi
        ArUdJcMfLpiH6lnjtuCTbNs=
X-Google-Smtp-Source: AGRyM1uMiOn0VKwRIQ3gICWUnZf3DWycc+4VmlwAF2XaWWeUR8P9DiPSwxuRKigS02tlLQHAKPQxmQ==
X-Received: by 2002:adf:ed10:0:b0:21d:a9a1:3526 with SMTP id a16-20020adfed10000000b0021da9a13526mr10885027wro.403.1658840473574;
        Tue, 26 Jul 2022 06:01:13 -0700 (PDT)
Received: from felia.fritz.box (200116b8266ba800287bb26100a73554.dip.versatel-1u1.de. [2001:16b8:266b:a800:287b:b261:a7:3554])
        by smtp.gmail.com with ESMTPSA id a20-20020a05600c225400b003a32167b8d4sm21327917wmm.13.2022.07.26.06.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 06:01:13 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] wireguard: selftests: update config fragments
Date:   Tue, 26 Jul 2022 15:00:58 +0200
Message-Id: <20220726130058.21833-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel.config and debug.config fragments in wireguard selftests mention
some config symbols that have been reworked:

Commit c5665868183f ("mm: kmemleak: use the memory pool for early
allocations") removes the config DEBUG_KMEMLEAK_EARLY_LOG_SIZE and since
then, the config's feature is available without further configuration.

Commit 4675ff05de2d ("kmemcheck: rip it out") removes kmemcheck and the
corresponding arch config HAVE_ARCH_KMEMCHECK. There is no need for this
config.

Commit 3bf195ae6037 ("netfilter: nat: merge nf_nat_ipv4,6 into nat core")
removes the config NF_NAT_IPV4 and since then, the config's feature is
available without further configuration.

Commit 41a2901e7d22 ("rcu: Remove SPARSE_RCU_POINTER Kconfig option")
removes the config SPARSE_RCU_POINTER and since then, the config's feature
is enabled by default.

Commit dfb4357da6dd ("time: Remove CONFIG_TIMER_STATS") removes the feature
and config CONFIG_TIMER_STATS without any replacement.

Commit 3ca17b1f3628 ("lib/ubsan: remove null-pointer checks") removes the
check and config UBSAN_NULL without any replacement.

Adjust the config fragments to those changes in configs.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 tools/testing/selftests/wireguard/qemu/debug.config  | 5 -----
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 2 files changed, 6 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index 2b321b8a96cf..9d172210e2c6 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -18,15 +18,12 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACKOVERFLOW=y
-CONFIG_HAVE_ARCH_KMEMCHECK=y
 CONFIG_HAVE_ARCH_KASAN=y
 CONFIG_KASAN=y
 CONFIG_KASAN_INLINE=y
 CONFIG_UBSAN=y
 CONFIG_UBSAN_SANITIZE_ALL=y
-CONFIG_UBSAN_NULL=y
 CONFIG_DEBUG_KMEMLEAK=y
-CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=8192
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_DEBUG_SHIRQ=y
 CONFIG_WQ_WATCHDOG=y
@@ -35,7 +32,6 @@ CONFIG_SCHED_INFO=y
 CONFIG_SCHEDSTATS=y
 CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_DEBUG_TIMEKEEPING=y
-CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_PREEMPT=y
 CONFIG_DEBUG_RT_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK=y
@@ -49,7 +45,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_LIST=y
 CONFIG_DEBUG_PLIST=y
 CONFIG_PROVE_RCU=y
-CONFIG_SPARSE_RCU_POINTER=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=21
 CONFIG_RCU_TRACE=y
 CONFIG_RCU_EQS_DEBUG=y
diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index e1858ce7003f..ce2a04717300 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -19,7 +19,6 @@ CONFIG_NETFILTER_XTABLES=y
 CONFIG_NETFILTER_XT_NAT=y
 CONFIG_NETFILTER_XT_MATCH_LENGTH=y
 CONFIG_NETFILTER_XT_MARK=y
-CONFIG_NF_NAT_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_MANGLE=y
-- 
2.17.1

