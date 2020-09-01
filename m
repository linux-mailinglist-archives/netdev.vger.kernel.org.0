Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C894258F66
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgIANso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgIANsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43E7C061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YqadDmXcFCWSEPGIDdrNQRJPK9eqQOdYuy9a5URPH+U=; b=IILjXxD1L2/pYqwfLXQVGLbD/O
        8EayzP/kNKsbRGWKRV4xbhcDMMBnXP5naNdiSI3SrHiBhD3iuze5LQn82y1gPxfLNvxknk1tBmyw2
        UM2x1FyzTaUGnb+32e59KQvJ1I51Xgkrjb3VPu4Li7/N549BCJY5nee8/r0sZHPCXqviY1f1oA2Nb
        WDU4q7xOF2okLdtddcqyWP9XzxewxDPFOfEqAA+zehsAqiaxHcFXvqNgOWO2KOj6XgmOwqrfDf4ad
        zFpCWv712jbTU5Q1ocLKAeMFL7YWTuiBHRBPY26+7c2wTzbnj14ZJLuxJ2saUEciod4C9hxH+ilrR
        C29ADzLg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36078 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6dw-0002Y8-HS; Tue, 01 Sep 2020 14:48:12 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6dw-0007Ki-Am; Tue, 01 Sep 2020 14:48:12 +0100
In-Reply-To: <20200901134746.GM1551@shell.armlinux.org.uk>
References: <20200901134746.GM1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] net: mvpp2: tidy up ACPI hack
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kD6dw-0007Ki-Am@rmk-PC.armlinux.org.uk>
Date:   Tue, 01 Sep 2020 14:48:12 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tidy up the ACPI hack so that we can minimise the function prototypes
for this.  This avoids adding further prototypes unnecessarily.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2a8a5842eaef..c35871e31ab6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -57,13 +57,7 @@ static struct {
 /* The prototype is added here to be used in start_dev when using ACPI. This
  * will be removed once phylink is used for all modes (dt+ACPI).
  */
-static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
-			     const struct phylink_link_state *state);
-static void mvpp2_mac_link_up(struct phylink_config *config,
-			      struct phy_device *phy,
-			      unsigned int mode, phy_interface_t interface,
-			      int speed, int duplex,
-			      bool tx_pause, bool rx_pause);
+static void mvpp2_acpi_start(struct mvpp2_port *port);
 
 /* Queue modes */
 #define MVPP2_QDIST_SINGLE_MODE	0
@@ -4007,17 +4001,7 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
 	if (port->phylink) {
 		phylink_start(port->phylink);
 	} else {
-		/* Phylink isn't used as of now for ACPI, so the MAC has to be
-		 * configured manually when the interface is started. This will
-		 * be removed as soon as the phylink ACPI support lands in.
-		 */
-		struct phylink_link_state state = {
-			.interface = port->phy_interface,
-		};
-		mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
-		mvpp2_mac_link_up(&port->phylink_config, NULL,
-				  MLO_AN_INBAND, port->phy_interface,
-				  SPEED_UNKNOWN, DUPLEX_UNKNOWN, false, false);
+		mvpp2_acpi_start(port);
 	}
 
 	netif_tx_start_all_queues(port->dev);
@@ -5850,6 +5834,22 @@ static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.mac_link_down = mvpp2_mac_link_down,
 };
 
+/* Work-around for ACPI */
+static void mvpp2_acpi_start(struct mvpp2_port *port)
+{
+	/* Phylink isn't used as of now for ACPI, so the MAC has to be
+	 * configured manually when the interface is started. This will
+	 * be removed as soon as the phylink ACPI support lands in.
+	 */
+	struct phylink_link_state state = {
+		.interface = port->phy_interface,
+	};
+	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
+	mvpp2_mac_link_up(&port->phylink_config, NULL,
+			  MLO_AN_INBAND, port->phy_interface,
+			  SPEED_UNKNOWN, DUPLEX_UNKNOWN, false, false);
+}
+
 /* Ports initialization */
 static int mvpp2_port_probe(struct platform_device *pdev,
 			    struct fwnode_handle *port_fwnode,
-- 
2.20.1

