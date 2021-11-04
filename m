Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979794453E8
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhKDNf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhKDNf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:35:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1303AC061714;
        Thu,  4 Nov 2021 06:32:49 -0700 (PDT)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636032767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xydqkvXQm53Y9pn4qUFqbV1ABXxo0FkjlCwBC4Gpyis=;
        b=APzoQbOtkOMZIqwsQQZI73KvxZg8snrMzm4T5+qDlNhSSpXajunjugrOqO9O5er+0ftnCM
        aGpR0npUZu7ZdWzZpYJOsJFbx8jMZXY9Td/i0Xn2k5EUz/d3zigrEAErw/uPrDGm3ly2ns
        cXD/0D/aOI8vEg+5Ck6QADyvXYBhJpo63NpCzTLB0LNsRXJlwqCRdwFDz1gf+LiHezoMWc
        hNFylsCf4XKrnJU1zmpYfi2HrxiTTBf4zlGQy7vrj4A6/7lukfmb2DQewe2bwUoudHUMvf
        d5UwkFz+r30wLlZow2cOb/kwFGxDnCRrqdlVOJXCl2UN9O1JR3nkr8CmpkxQaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636032767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xydqkvXQm53Y9pn4qUFqbV1ABXxo0FkjlCwBC4Gpyis=;
        b=T3T+aW34CCYGdalAtCHSvWzxVtY0MZQXWV/uH8MfMr6FCfr1wOjXHSbpeqrrcz1W/FtY82
        rG9I41mwsiPBOEBw==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/7] net: dsa: b53: Add BroadSync HD register definitions
Date:   Thu,  4 Nov 2021 14:31:55 +0100
Message-Id: <20211104133204.19757-2-martin.kaistra@linutronix.de>
In-Reply-To: <20211104133204.19757-1-martin.kaistra@linutronix.de>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

Add register definitions for the BroadSync HD features of
BCM53128. These will be used to enable PTP support.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 drivers/net/dsa/b53/b53_regs.h | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index b2c539a42154..c8a9d633f78b 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -50,6 +50,12 @@
 /* Jumbo Frame Registers */
 #define B53_JUMBO_PAGE			0x40
 
+/* BroadSync HD Register Page */
+#define B53_BROADSYNC_PAGE		0x90
+
+/* Traffic Remarking Register Page */
+#define B53_TRAFFICREMARKING_PAGE	0x91
+
 /* EEE Control Registers Page */
 #define B53_EEE_PAGE			0x92
 
@@ -479,6 +485,38 @@
 #define   JMS_MIN_SIZE			1518
 #define   JMS_MAX_SIZE			9724
 
+/*************************************************************************
+ * BroadSync HD Page Registers
+ *************************************************************************/
+
+#define B53_BROADSYNC_EN_CTRL1		0x00
+#define B53_BROADSYNC_EN_CTRL2		0x01
+#define B53_BROADSYNC_TS_REPORT_CTRL	0x02
+#define B53_BROADSYNC_PCP_CTRL		0x03
+#define B53_BROADSYNC_MAX_SDU		0x04
+#define B53_BROADSYNC_TIMEBASE1		0x10
+#define B53_BROADSYNC_TIMEBASE2		0x11
+#define B53_BROADSYNC_TIMEBASE3		0x12
+#define B53_BROADSYNC_TIMEBASE4		0x13
+#define B53_BROADSYNC_TIMEBASE_ADJ1	0x14
+#define B53_BROADSYNC_TIMEBASE_ADJ2	0x15
+#define B53_BROADSYNC_TIMEBASE_ADJ3	0x16
+#define B53_BROADSYNC_TIMEBASE_ADJ4	0x17
+#define B53_BROADSYNC_SLOT_CNT1		0x18
+#define B53_BROADSYNC_SLOT_CNT2		0x19
+#define B53_BROADSYNC_SLOT_CNT3		0x1a
+#define B53_BROADSYNC_SLOT_CNT4		0x1b
+#define B53_BROADSYNC_SLOT_ADJ1		0x1c
+#define B53_BROADSYNC_SLOT_ADJ2		0x1d
+#define B53_BROADSYNC_SLOT_ADJ3		0x1e
+#define B53_BROADSYNC_SLOT_ADJ4		0x1f
+#define B53_BROADSYNC_CLS5_BW_CTRL	0x30
+#define B53_BROADSYNC_CLS4_BW_CTRL	0x60
+#define B53_BROADSYNC_EGRESS_TS		0x90
+#define B53_BROADSYNC_EGRESS_TS_STS	0xd0
+#define B53_BROADSYNC_LINK_STS1		0xe0
+#define B53_BROADSYNC_LINK_STS2		0xe1
+
 /*************************************************************************
  * EEE Configuration Page Registers
  *************************************************************************/
-- 
2.20.1

