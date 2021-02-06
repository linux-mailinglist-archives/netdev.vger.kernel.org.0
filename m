Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFCB312037
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 22:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBFVv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 16:51:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23345 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhBFVvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 16:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612648284; x=1644184284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y0LF0QiYzcdX2y6gwZ07FxsFEt3swqe56rzuZlawFZY=;
  b=cDYNu+y0QI8Zs/iCh2jHO61uZbp+dt3c4VRjGTBP0dKcb0CTfsOIZtvC
   WUh6sNqYltr2tD43X7/DrVjK93vAJUDpbb5XniAI87CLgBNQEPGoI0fqG
   BajPc7nMIvPcIVglQLE8TX2f32oQwKC5PgLrRG1vOxguNnyTSNogG4Pxz
   iFd2oCHevPXvMRot7yGdaGexjEMNRus0MhQTz1AJ+m+qS+XTxBz/G3D+4
   pkqLjwubcYjUYiAQp789ri8nM5Gfh4N8h2tMDoexptfPj2RpMLSVxY0tL
   SOyh3z2il9E1A0qR6EtALlA9819IJzxFR86IE6xpN916STEXWGVlVvfgy
   w==;
IronPort-SDR: gcsT9Pl+dqnMyULVGuASekAJ8cQq3N7GU2uvRFbX2u22exT5uskHtEuInH4D1G92ZidNUElUCj
 UsVlloBGTnVKheEQPtsV942divjR9FZLY1mSfEvrF31jIoXOZxcyhzCg0B6k74tQ9pU9SLQWbu
 v3xeNizgY5SUCsJV9nGOSZkXh73an31+crWYTENs0hbeLf7YYkPBy6rg54V9JC8Is/qgQNF/M6
 TGBaIkIAFNQJobu9Q5SaVxIBhH9VFU+dSfPZ4Zb+Dur/dNMG0Sen3jqSF0Gflx84n79ktffPQK
 nns=
X-IronPort-AV: E=Sophos;i="5.81,158,1610434800"; 
   d="scan'208";a="102871017"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2021 14:49:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 6 Feb 2021 14:49:48 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 6 Feb 2021 14:49:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 2/2] switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT
Date:   Sat, 6 Feb 2021 22:47:34 +0100
Message-ID: <20210206214734.1577849-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
References: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that MRP started to use also SWITCHDEV_ATTR_ID_PORT_STP_STATE to
notify HW, then SWITCHDEV_ATTR_ID_MRP_PORT_STAT is not used anywhere
else, therefore we can remove it.

Fixes: c284b545900830 ("switchdev: mrp: Extend switchdev API to offload MRP")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 99cd538d6519..afdf8bd1b4fe 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -42,7 +42,6 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 #endif
 };
@@ -62,7 +61,6 @@ struct switchdev_attr {
 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
 		bool mc_disabled;			/* MC_DISABLED */
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-		u8 mrp_port_state;			/* MRP_PORT_STATE */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
 #endif
 	} u;
-- 
2.27.0

