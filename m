Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3395531521
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfEaTSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:18:33 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:48575 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbfEaTSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:18:32 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJIA2n021847
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 13:18:10 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJI9W6010639
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:18:09 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: sfp: Set 1000BaseX support flag for 1000BaseT modules
Date:   Fri, 31 May 2019 13:18:01 -0600
Message-Id: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modules which support 1000BaseT should also have 1000BaseX support. Set
this support flag to allow drivers supporting only 1000BaseX to work.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/sfp-bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index e9c1879..96cdf85 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -158,6 +158,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	if (id->base.e1000_base_t) {
 		phylink_set(modes, 1000baseT_Half);
 		phylink_set(modes, 1000baseT_Full);
+		phylink_set(modes, 1000baseX_Full);
 	}
 
 	/* 1000Base-PX or 1000Base-BX10 */
-- 
1.8.3.1

