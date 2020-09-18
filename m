Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABED326FB0F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgIRK6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgIRK6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:12 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6499DC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:12 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so7484576ejo.9
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+p4t9Y7PHpqMJyTr22QTWbnKUgVOmdEqNEoqHpx2MqY=;
        b=r8x8rXHNjQkLAt4G8UPlmyBC+Me6L90K+GWfoFTGmXUntx+vmTZltDsozLTQ/LifwK
         D2W8Bb8iCv+dhpsJIsA4tudKimqWyW7TEFz2OGud4Pnb7juIzUlxsE6YnFBlQQesXQ6w
         6ZIjrPQJqousWPPWCOUkHbsGoOnq2ySmeVP1Wclp8agFaEsMRPaW3OC2bANQqwhPrNxs
         ARt3Db9USxFYfH05GCajySAUVpb7fqpKur/pWppRXU28RRnwk1MDIF+KUfjXkmzDULRV
         JJX8ycL4I1MR9IAksCNCp8JKY6h3qXdTi0u9Hc6utOWIQjEDY9iSWlRmxhMQjDWs7UM3
         u0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+p4t9Y7PHpqMJyTr22QTWbnKUgVOmdEqNEoqHpx2MqY=;
        b=StZI77/RGAI6GSouxRobkMZ87Qe3SNYbIfx33LKASA9XyXYzEq/S6E4Gq5AXD9mUpU
         lqNQiaPMVWHCkCvxXabEd/PKXQ+CzZAS4ujU+X2E+bisvjnCpI9ICSihCP7r85nd1sir
         coRGbMjwTDlwt1S4F/NF5dtzkK0QKbDHrGQS/nJGNf8LxRWOAN0oAweJyd8W8H3gymoC
         s4LqeCMVhevYw890tp06R+XFl1bYqxUnDobZHV5aXa/fbdsfeiVCnh+iAmGrq6JT2aN2
         gf9A4PYCem6Q/V+iN93ri2drR3cN/SE5UwTIiwyuVV2NI/XG7jUHMYp6hPG+92w9yHgv
         kCAg==
X-Gm-Message-State: AOAM531RpgY4+2krSks4YTBjUL9w/0x3jXsuMh2WUvXh7MgfPDjQ34g5
        RbCRUQvoxaxwj/vPkPjqXGI=
X-Google-Smtp-Source: ABdhPJxf3JrZm7K7F4Vu3y8spsskPGOU4VmQQUWiKcUSd9APRZgs4HeS/76TCoS0z9xMLtEvfEIxXw==
X-Received: by 2002:a17:907:3301:: with SMTP id ym1mr37305746ejb.367.1600426691096;
        Fri, 18 Sep 2020 03:58:11 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 07/11] net: dsa: felix: replace tabs with spaces
Date:   Fri, 18 Sep 2020 13:57:49 +0300
Message-Id: <20200918105753.3473725-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Over the time, some patches have introduced structures aligned with
spaces, near structures aligned with tabs. Fix the inconsistencies.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  2 +-
 drivers/net/dsa/ocelot/felix.h         |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 +++++++++++-----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 64939ee14648..b523ea3a2e5f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -803,7 +803,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_add		= felix_cls_flower_add,
 	.cls_flower_del		= felix_cls_flower_del,
 	.cls_flower_stats	= felix_cls_flower_stats,
-	.port_setup_tc          = felix_port_setup_tc,
+	.port_setup_tc		= felix_port_setup_tc,
 };
 
 static int __init felix_init(void)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9bceb994b7db..807f18b74847 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -20,7 +20,7 @@ struct felix_info {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 	int				num_ports;
-	int                             num_tx_queues;
+	int				num_tx_queues;
 	struct vcap_field		*vcap_is2_keys;
 	struct vcap_field		*vcap_is2_actions;
 	const struct vcap_props		*vcap;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 6f6e4ef299c3..4dbc3283f7ea 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -296,15 +296,15 @@ static const u32 vsc9959_sys_regmap[] = {
 };
 
 static const u32 vsc9959_ptp_regmap[] = {
-	REG(PTP_PIN_CFG,                   0x000000),
-	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
-	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
-	REG(PTP_PIN_TOD_NSEC,              0x00000c),
-	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
-	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
-	REG(PTP_CFG_MISC,                  0x0000a0),
-	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
-	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
+	REG(PTP_PIN_CFG,			0x000000),
+	REG(PTP_PIN_TOD_SEC_MSB,		0x000004),
+	REG(PTP_PIN_TOD_SEC_LSB,		0x000008),
+	REG(PTP_PIN_TOD_NSEC,			0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,		0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,		0x000018),
+	REG(PTP_CFG_MISC,			0x0000a0),
+	REG(PTP_CLK_CFG_ADJ_CFG,		0x0000a4),
+	REG(PTP_CLK_CFG_ADJ_FREQ,		0x0000a8),
 };
 
 static const u32 vsc9959_gcb_regmap[] = {
@@ -1173,8 +1173,8 @@ static const struct felix_info felix_info_vsc9959 = {
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
 	.phylink_validate	= vsc9959_phylink_validate,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
-	.port_setup_tc          = vsc9959_port_setup_tc,
-	.port_sched_speed_set   = vsc9959_sched_speed_set,
+	.port_setup_tc		= vsc9959_port_setup_tc,
+	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.xmit_template_populate	= vsc9959_xmit_template_populate,
 };
 
-- 
2.25.1

