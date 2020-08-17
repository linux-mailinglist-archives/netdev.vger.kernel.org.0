Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143192468D6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgHQOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:55:40 -0400
Received: from mail.intenta.de ([178.249.25.132]:41314 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgHQOzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=MKQaz6MveHibIVc6CzUlSJUjmdnHdjraErzNAJq99Lo=;
        b=J1UNT+akYWqIz5Fafij6JXNf4FcT7M0kadQQCZt7cUG2NUfxwS55+s5JZ8Rz1i0sqKzjZOgv2JlcuaBwGrAQ0WXQn5reWJrmXzUwMQ2BpPAw8AQcAMKnuiLHLCY1C7NTZz2gO1SAGesyH/Myy/loM38c3IaQaxWQ6xXd/7+uMysYCXSbxkyYOOZ4Px10YhMVS+k0EtbWKbU0USN+WZgUz9DouAQvl030cWx3kNQJFnMhLIRcgBdRWYolcDGXqoogLaJK8TEtKnuFwtg3N3J2ipiH6SzEKMCKI9AOVCd2bts7QiBHoCpAAtCRuaUfz51HLdGJvffy4tbHAtqo7t7YFw==;
Date:   Mon, 17 Aug 2020 16:55:34 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 2/6] net: dsa: microchip: delete unused member
 ksz_port.sgmii
Message-ID: <a39d6d4019f3274587719e239cfce788310e9b86.1597675604.git.helmut.grohne@intenta.de>
References: <20200725174130.GL1472201@lunn.ch>
 <cover.1597675604.git.helmut.grohne@intenta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1597675604.git.helmut.grohne@intenta.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link: https://lore.kernel.org/netdev/20200721083300.GA12970@laureti-dev/
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz9477.c    | 2 --
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c548894553bc..0ff54ee4f963 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1305,8 +1305,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 		p->member = dev->port_mask;
 		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
-		if (dev->chip_id == 0x00947700 && i == 6)
-			p->sgmii = 1;
 	}
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0432cd38bf0b..83247140b784 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -32,7 +32,6 @@ struct ksz_port {
 
 	u32 on:1;			/* port is not disabled by hardware */
 	u32 fiber:1;			/* port is fiber */
-	u32 sgmii:1;			/* port is SGMII */
 	u32 force:1;
 	u32 read:1;			/* read MIB counters in background */
 	u32 freeze:1;			/* MIB counter freeze is enabled */
-- 
2.20.1

