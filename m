Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD932468F2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgHQO74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:59:56 -0400
Received: from mail.intenta.de ([178.249.25.132]:41357 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHQO7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=DdHx8cvx8GNyWolx4FGyEq6qtgvNHmpmJypkc7o70bA=;
        b=tIB/YheO3b1KvNA9TBQfklbDi5AyBXJTVIscfDp7Z7kro/Qe4fD54pMIonkF0zyKraF6UUFATkHIU/MwtmZVXE2iwoxI9k3GUcaYrDWVL8g6k+l6yGxchJSLrmNtG3RjwSbBZN2jDUgdW7GfVLkekWrt0ljNvWOlimGFjiNXdMzUAmOsCH+lgTwkK0n9v3b4ztGNRR+yQtd2v9f38HGVF5X1aERc7e9BqAF2JXqxWUnJvuYloH9qqwLhyKv2iiD91gzawOV6bRGZOaXcx87Xnc2b2lu6RkgYQZ5hamMNYj3ljlafVvjeYCI80JQp1PlCNfonhiwSWOk9CyNpPUHGWQ==;
Date:   Mon, 17 Aug 2020 16:59:51 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 6/6] net: dsa: microchip: delete unused member
 ksz_device.overrides
Message-ID: <ddc9b570450c9522b45c368dffc098d18d3d7e72.1597675604.git.helmut.grohne@intenta.de>
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
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0120f2b72091..10ff7774a867 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -82,7 +82,6 @@ struct ksz_device {
 	u16 mirror_rx;
 	u16 mirror_tx;
 	u32 features;			/* chip specific features */
-	u32 overrides;			/* chip functions set by user */
 	u16 host_mask;
 	u16 port_mask;
 };
-- 
2.20.1

