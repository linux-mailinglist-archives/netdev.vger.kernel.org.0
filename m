Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E7331A0A8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBLOdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:33:46 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:36376 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBLOdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:33:41 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11CEVf9t111660;
        Fri, 12 Feb 2021 08:31:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613140301;
        bh=lUakNV+CV5NffMQmGC2Drd4lNwe79cgtFz1V4jCRJcY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lbseuewDdWlwxmebUNQ0jeNXKuGvUuIfQVSJjNLEKm1S8j+KqXF7lDUpoaMmbawQt
         rkyu1MpMhaWm3RagWE/UhEIr4fK9IH6SlrSTnPvJylIoigO+WYMygLn6vOTTVByei5
         Lt3+0OIbkUVogWqSTMckQZguGd7RM9DKNpY34SXE=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11CEVfNa091029
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Feb 2021 08:31:41 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 12
 Feb 2021 08:31:41 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 12 Feb 2021 08:31:41 -0600
Received: from [10.250.234.120] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11CEVYtG076171;
        Fri, 12 Feb 2021 08:31:35 -0600
Subject: Re: [PATCH v4 net-next 0/9] Cleanup in brport flags switchdev offload
 for DSA
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210212010531.2722925-1-olteanv@gmail.com>
 <97ae293a-f59d-cc7c-21a6-f83880c69c71@ti.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <ba7350f1-f9ff-b77e-65c9-cd5a4ae652d8@ti.com>
Date:   Fri, 12 Feb 2021 20:01:33 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <97ae293a-f59d-cc7c-21a6-f83880c69c71@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 2/12/21 7:47 PM, Grygorii Strashko wrote:
> 
> 
> On 12/02/2021 03:05, Vladimir Oltean wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
[...]
> 
> Sorry, but we seems just added more work for you.
> https://lore.kernel.org/patchwork/cover/1379380/
> 

Could you squash these when you post new version:
Sorry for not noticing earlier.

-- >8 --

From 69f3a1ff1ea0777f5deceefdb0e79ce625e6488a Mon Sep 17 00:00:00 2001
From: Vignesh Raghavendra <vigneshr@ti.com>
Date: Fri, 12 Feb 2021 19:34:46 +0530
Subject: [PATCH 1/2] fixup! net: switchdev: propagate extack to port
 attributes

---
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 1067e7772dbf..314825acf0a0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -81,7 +81,8 @@ static int am65_cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
 }
 
 static int am65_cpsw_port_attr_set(struct net_device *ndev,
-				   const struct switchdev_attr *attr)
+				   const struct switchdev_attr *attr,
+				   struct netlink_ext_ack *extack)
 {
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret;


-- >8 --

From 7d7fdb79a8b255a1e9fe5d205b0ff1824a16ce56 Mon Sep 17 00:00:00 2001
From: Vignesh Raghavendra <vigneshr@ti.com>
Date: Fri, 12 Feb 2021 19:40:48 +0530
Subject: [PATCH 2/2] fixup! net: switchdev: pass flags and mask to both
 {PRE_,}BRIDGE_FLAGS attributes

---
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 314825acf0a0..03c7a012f5c5 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -55,12 +55,12 @@ static int am65_cpsw_port_stp_state_set(struct am65_cpsw_port *port, u8 state)
 
 static int am65_cpsw_port_attr_br_flags_set(struct am65_cpsw_port *port,
 					    struct net_device *orig_dev,
-					    unsigned long brport_flags)
+					    struct switchdev_brport_flags flags)
 {
 	struct am65_cpsw_common *cpsw = port->common;
 	bool unreg_mcast_add = false;
 
-	if (brport_flags & BR_MCAST_FLOOD)
+	if (flags.mask & BR_MCAST_FLOOD)
 		unreg_mcast_add = true;
 	netdev_dbg(port->ndev, "BR_MCAST_FLOOD: %d port %u\n",
 		   unreg_mcast_add, port->port_id);
@@ -72,9 +72,9 @@ static int am65_cpsw_port_attr_br_flags_set(struct am65_cpsw_port *port,
 }
 
 static int am65_cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
-						unsigned long flags)
+						struct switchdev_brport_flags flags)
 {
-	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	return 0;
-- 
2.30.0


