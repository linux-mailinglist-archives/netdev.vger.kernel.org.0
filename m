Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE31C66B29F
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 17:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjAOQmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 11:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjAOQmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 11:42:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C5E1041A
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=XJcv7DHeiGlPDGDNQyQxReZeIFHn0vWzYdNeyYqqylo=; b=4uii3Vu1qskTsGWLzFa+C/+qfb
        GWuCeEPj5FOMH4hp90jtRqQ3RfPzKiJaJMATyeHYQnyDkNJA0+65FmQ/BRk/CuU9ObHStsjrub5Ya
        djgMbq5SF+0LO6hcnhjRQKed/jutJ6+fGoCUQ7z8Mxn7O4E5hNStlCx+ltzep6KTWCIE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pH655-0028pu-U8; Sun, 15 Jan 2023 17:42:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: mdio: cavium: Remove unneeded simicolons
Date:   Sun, 15 Jan 2023 17:42:03 +0100
Message-Id: <20230115164203.510615-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent refactoring to split C22 and C45 introduced two unneeded
semiconons which the kernel test bot reported. Remove them.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 93641ecbaa1f ("net: mdio: cavium: Separate C22 and C45 transactions")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/mdio/mdio-cavium.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-cavium.c b/drivers/net/mdio/mdio-cavium.c
index fd81546a4d3d..100e46a702ee 100644
--- a/drivers/net/mdio/mdio-cavium.c
+++ b/drivers/net/mdio/mdio-cavium.c
@@ -67,7 +67,7 @@ int cavium_mdiobus_read_c22(struct mii_bus *bus, int phy_id, int regnum)
 	cavium_mdiobus_set_mode(p, C22);
 
 	smi_cmd.u64 = 0;
-	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_22_READ */;
+	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_22_READ */
 	smi_cmd.s.phy_adr = phy_id;
 	smi_cmd.s.reg_adr = regnum;
 	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
@@ -136,7 +136,7 @@ int cavium_mdiobus_write_c22(struct mii_bus *bus, int phy_id, int regnum,
 	oct_mdio_writeq(smi_wr.u64, p->register_base + SMI_WR_DAT);
 
 	smi_cmd.u64 = 0;
-	smi_cmd.s.phy_op = 0; /* MDIO_CLAUSE_22_WRITE */;
+	smi_cmd.s.phy_op = 0; /* MDIO_CLAUSE_22_WRITE */
 	smi_cmd.s.phy_adr = phy_id;
 	smi_cmd.s.reg_adr = regnum;
 	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
-- 
2.39.0

