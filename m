Return-Path: <netdev+bounces-7472-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E2C72067C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35B6B2819F7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70351B91E;
	Fri,  2 Jun 2023 15:45:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA521B910
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:45:50 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AED518C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5Yri5zTLMwqtY189y122EOnnzmFonxPfU7xL3miev/k=; b=aPNLK/gXowf/3BEkDqgMEL2U07
	wC9CkXxLzD8PM7UoY55jb1eEmbLSf8goum5ZkUoyWToP1bOkvcXs4cvsXG7GpKMYnql0A9o7hdED/
	gpwgr1KOwyikfiJ+FORkojrJ13LxTn1oHKmXFuvb1PMqSDFQQA7ouDwi7sMgU0JCLkSNGG8ZlDVwp
	E7lzB2A7VBcUV21zDNzovWRn57GVis9IqXznBpRzVYa6g9n+5uHaD445NvAL/FUPB9GEvEXtwXVeX
	uVL8HK+tCTJyu9YEDXb4dBgTwzf3DjYKLFv+JFGhG+VPH99t/OBdbbsGQw2lwnPHew+S+YaQwwaPx
	igO9dHNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44022 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q56yH-0008Ec-FX; Fri, 02 Jun 2023 16:45:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q56yG-00Bsv4-St; Fri, 02 Jun 2023 16:45:44 +0100
In-Reply-To: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
References: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 7/8] net: pcs: lynx: make lynx_pcs_create() static
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q56yG-00Bsv4-St@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 02 Jun 2023 16:45:44 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We no longer need to export lynx_pcs_create() for drivers to use as we
now have all the functionality we need in the two new creation helpers.
Remove the export and prototype, and make it static.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 3 +--
 include/linux/pcs-lynx.h   | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index b0907c67d469..b8c66137e28d 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -307,7 +307,7 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
+static struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
 	struct lynx_pcs *lynx;
 
@@ -322,7 +322,6 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 
 	return lynx_to_phylink_pcs(lynx);
 }
-EXPORT_SYMBOL(lynx_pcs_create);
 
 struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
 {
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 123e813df771..7958cccd16f2 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,7 +9,6 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr);
 struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node);
 
-- 
2.30.2


