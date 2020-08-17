Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6752468F0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHQO7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:59:52 -0400
Received: from mail.intenta.de ([178.249.25.132]:41348 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHQO7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=ul781r9xJv0u1sbu832MaRaQH5Qhz5+ZPGqxs6N/Qao=;
        b=QLsMuHBiwoheRtu8lP3TPYqL5oKE3GJHAMduSUeTux6oStrwAqs/j7fWh8V55R9OIawQaYxP6Wm6g28v2YIPvJnIS0huFH055yKoAf1mQ14wQhJnXCy6KMdJSYdne44eA+kX6wQG3S22nNSaz1vhe888+2gLfcKomtf0sJavM+3l9OtfvR8ks13aeK1JdOLOEjrqWY2Ibfut8uRuWeuvyqlWvQHLGTKAIbmkctyAmWxRYFwyKtUAjoxsou7Sp9APYUAGzPHVlr1m7fWvpMxs7O2Qtqw+wkglr6qTRoN4aYOIWJL3L9/0V66RMaCZehnpbTkk5U+sbbnS1+RT+ig5sw==;
Date:   Mon, 17 Aug 2020 16:59:43 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 5/6] net: dsa: microchip: delete unused member
 ksz_device.regs_size
Message-ID: <1415e9762aedbdd522f28b15e35049a4e1291696.1597675604.git.helmut.grohne@intenta.de>
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
index 1791442f04ee..0120f2b72091 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -69,7 +69,6 @@ struct ksz_device {
 	int mib_cnt;
 	int mib_port_cnt;
 	phy_interface_t interface;
-	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
 
-- 
2.20.1

