Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FBB35EBE7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 06:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhDNEdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 00:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230188AbhDNEd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 00:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618374788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oQDjPtD3WvuvXM4eQvNcLKFd7+TjM2tF15O9Rwlosks=;
        b=A3iuBkNGddfHDQ5iCY6ch8U9myFdeRAVFuWB+KIbqHUAjVnFjNg0I+H4cuPemW036OtB8a
        +EQC5xDQznoiXMd3SqS3FhRlnrJ1KBpt2UjA+VkWH1gCj/Jd3jgxof/3HPIgP3O91Yl7YQ
        fjuASQXaissyXcD7L64F7P2gXbTTig0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-9G43fYr3MiiCOGlw_JMOfg-1; Wed, 14 Apr 2021 00:33:07 -0400
X-MC-Unique: 9G43fYr3MiiCOGlw_JMOfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E28401006C83;
        Wed, 14 Apr 2021 04:33:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D65B310023BE;
        Wed, 14 Apr 2021 04:33:04 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org
Subject: [PATCH 2/2] m68k: update configs to match the proper KUNIT syntax
Date:   Wed, 14 Apr 2021 00:33:03 -0400
Message-Id: <20210414043303.1072552-2-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes other than CONFIG name changes
Signed-off-by: Nico Pache <npache@redhat.com>
---
 arch/m68k/configs/amiga_defconfig    | 6 +++---
 arch/m68k/configs/apollo_defconfig   | 6 +++---
 arch/m68k/configs/atari_defconfig    | 6 +++---
 arch/m68k/configs/bvme6000_defconfig | 6 +++---
 arch/m68k/configs/hp300_defconfig    | 6 +++---
 arch/m68k/configs/mac_defconfig      | 6 +++---
 arch/m68k/configs/multi_defconfig    | 6 +++---
 arch/m68k/configs/mvme147_defconfig  | 6 +++---
 arch/m68k/configs/mvme16x_defconfig  | 6 +++---
 arch/m68k/configs/q40_defconfig      | 6 +++---
 arch/m68k/configs/sun3_defconfig     | 6 +++---
 arch/m68k/configs/sun3x_defconfig    | 6 +++---
 12 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 786656090c50..77cc4ff7ae3a 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -655,11 +655,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 9bb12be4a38e..86913bdb265b 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -611,11 +611,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 413232626d9d..6b5c35e7be44 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -633,11 +633,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 819cc70b06d8..8fbd238d9d29 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -604,11 +604,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 8f8d5968713b..dbebbc079611 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -613,11 +613,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index bf15e6c1c939..3ccafd1db067 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -636,11 +636,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 5466d48fcd9d..572c95f1c8d7 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -722,11 +722,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 93c305918838..a92d6c4ab9ff 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -603,11 +603,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index cacd6c617f69..e1dbe9208a92 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -604,11 +604,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 3ae421cb24a4..957aa0277c3c 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -622,11 +622,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 6da97e28c48e..ebe23c0414fb 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -605,11 +605,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index f54481bb789a..c913aa7635d8 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -605,11 +605,11 @@ CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_FIND_BIT_BENCHMARK=m
 CONFIG_TEST_FIRMWARE=m
 CONFIG_TEST_SYSCTL=m
-CONFIG_BITFIELD_KUNIT=m
+CONFIG_BITFIELD_KUNIT_TEST=m
 CONFIG_RESOURCE_KUNIT_TEST=m
-CONFIG_LINEAR_RANGES_TEST=m
+CONFIG_LINEAR_RANGES_KUNIT_TEST=m
 CONFIG_CMDLINE_KUNIT_TEST=m
-CONFIG_BITS_TEST=m
+CONFIG_BITS_KUNIT_TEST=m
 CONFIG_TEST_UDELAY=m
 CONFIG_TEST_STATIC_KEYS=m
 CONFIG_TEST_KMOD=m
-- 
2.30.2

