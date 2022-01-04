Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A46348444F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiADPLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:11:55 -0500
Received: from mx4.wp.pl ([212.77.101.12]:12851 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234709AbiADPLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 10:11:54 -0500
Received: (wp-smtpd smtp.wp.pl 29318 invoked from network); 4 Jan 2022 16:11:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641309111; bh=TONj569bd0MUCHT5Fm+djUvQugQbN0cGqfgDDpHe0G0=;
          h=From:To:Subject;
          b=Q2K2USwDb+uCKJGM5VEKW1sXynOciuqB/M3TwUbRE6ghkfc6UYQ8Yr2aBvktYsWV4
           gr2oqFRuwTXm4FS8OEqfukVn5gvMWuU50eOWZPbcusp376G0lsXxcR++n7yG9G0tYZ
           xcXtF53HkCMD6BqrWTqWvHMXd2ztwD08jvpnAjPU=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <tsbogend@alpha.franken.de>; 4 Jan 2022 16:11:51 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     tsbogend@alpha.franken.de, olek2@wp.pl, hauke@hauke-m.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] MIPS: lantiq: dma: increase descritor count
Date:   Tue,  4 Jan 2022 16:11:42 +0100
Message-Id: <20220104151144.181736-2-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104151144.181736-1-olek2@wp.pl>
References: <20220104151144.181736-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 9e8dc35f86da11de04421f6bec29b1dc
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gXMU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):

	Down		Up
Before	539 Mbps	599 Mbps
After	545 Mbps	625 Mbps

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 arch/mips/include/asm/mach-lantiq/xway/xway_dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h b/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h
index 31ca9151b539..3dee15c61c8a 100644
--- a/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h
+++ b/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h
@@ -8,7 +8,7 @@
 #define LTQ_DMA_H__
 
 #define LTQ_DESC_SIZE		0x08	/* each descriptor is 64bit */
-#define LTQ_DESC_NUM		0x40	/* 64 descriptors / channel */
+#define LTQ_DESC_NUM		0xC0	/* 192 descriptors / channel */
 
 #define LTQ_DMA_OWN		BIT(31) /* owner bit */
 #define LTQ_DMA_C		BIT(30) /* complete bit */
-- 
2.30.2

