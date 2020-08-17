Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4682468DB
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgHQOzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:55:53 -0400
Received: from mail.intenta.de ([178.249.25.132]:41332 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbgHQOzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=eNeYOYLqRPrH4QMgS+phHvqZsDR01/ts1dXmb0Bc9xw=;
        b=gvDr7Q8MZP/m0Riuqa4DvsT7w0UFjiYJ7/ZbjY94WWoHwxIy3F6Ck8AYE/B48M2lgqUAeGF+vt48L1o3NyAlQOuHJf2KuBJlPgxLtOUIv0qvlidJJdHIFrleZWvu+DFsoXRDjbwDtZvTTZNHXjyNTM0k2ntZ2xXUR5GnEUcZJ/96bOf2EU0VKcqsbguU6ds/7+ccnBUGlnTX63dGuNtgvaJBP/SvNDnkaZ4cbjWfoxg/ZO+Lol6lVQl4U6wJa9cugBsN+JvSc8sXTxn76rNe1WpdiYqORc3u+4w6+dCD2nhhUotj1iuxdrUFfPbUF5g2+b4NltY8IA+jmyORQjZz1A==;
Date:   Mon, 17 Aug 2020 16:55:45 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 4/6] net: dsa: microchip: delete unused member
 ksz_device.last_port
Message-ID: <7d26b13709698dae79ed595382ff3cc9699eb0ea.1597675604.git.helmut.grohne@intenta.de>
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
 drivers/net/dsa/microchip/ksz8795.c    | 1 -
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index e62d54306765..3bdfe1f4d0f5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1150,7 +1150,6 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 			id2 = 0x65;
 	} else if (id2 == CHIP_ID_94) {
 		dev->port_cnt--;
-		dev->last_port = dev->port_cnt;
 		id2 = 0x94;
 	}
 	id16 &= ~0xff;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8e277033bff7..1791442f04ee 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -68,7 +68,6 @@ struct ksz_device {
 	int reg_mib_cnt;
 	int mib_cnt;
 	int mib_port_cnt;
-	int last_port;			/* ports after that not used */
 	phy_interface_t interface;
 	u32 regs_size;
 	bool phy_errata_9477;
-- 
2.20.1

