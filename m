Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FF188848
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgCQOzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbgCQOyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:54:31 -0400
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F0C2076E;
        Tue, 17 Mar 2020 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584456870;
        bh=+tWg3awZHYeUlHfuDttl7kdQdrVI80/B6dM9qQLuAfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAg2rDen4aRhFDMEsTITiVwvtPHMSyu6taTbqxTNSY7YOMPe9RVndlS48lKL7HKBo
         7ik04EKJab7YjYL6Oq8cmbfsA4JLb+2OnrQWVrHG+2N32myl5Ov1RYlAm9YASYytXP
         Ywf2jHO1WUgqxdzRE4xE+g81bGS1vtCo3hQ9tpRo=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jEDbw-000AMu-NE; Tue, 17 Mar 2020 15:54:28 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 10/17] net: phy: sfp-bus.c: get rid of docs warnings
Date:   Tue, 17 Mar 2020 15:54:19 +0100
Message-Id: <0d4835042a03ecda3514c1de0254d30134b0e8e0.1584456635.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584456635.git.mchehab+huawei@kernel.org>
References: <cover.1584456635.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The indentation for the returned values are weird, causing those
warnings:

	./drivers/net/phy/sfp-bus.c:579: WARNING: Unexpected indentation.
	./drivers/net/phy/sfp-bus.c:619: WARNING: Unexpected indentation.

Use a list and change the identation for it to be properly
parsed by the documentation toolchain.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index d949ea7b4f8c..6900c68260e0 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -572,13 +572,15 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
  * the sfp_bus structure, incrementing its reference count.  This must
  * be put via sfp_bus_put() when done.
  *
- * Returns: on success, a pointer to the sfp_bus structure,
- *	    %NULL if no SFP is specified,
- * 	    on failure, an error pointer value:
- * 		corresponding to the errors detailed for
- * 		fwnode_property_get_reference_args().
- * 	        %-ENOMEM if we failed to allocate the bus.
- *		an error from the upstream's connect_phy() method.
+ * Returns:
+ * 	    - on success, a pointer to the sfp_bus structure,
+ *	    - %NULL if no SFP is specified,
+ * 	    - on failure, an error pointer value:
+ *
+ * 	      - corresponding to the errors detailed for
+ * 	        fwnode_property_get_reference_args().
+ * 	      - %-ENOMEM if we failed to allocate the bus.
+ *	      - an error from the upstream's connect_phy() method.
  */
 struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
 {
@@ -612,13 +614,15 @@ EXPORT_SYMBOL_GPL(sfp_bus_find_fwnode);
  * the SFP bus using sfp_register_upstream().  This takes a reference on the
  * bus, so it is safe to put the bus after this call.
  *
- * Returns: on success, a pointer to the sfp_bus structure,
- *	    %NULL if no SFP is specified,
- * 	    on failure, an error pointer value:
- * 		corresponding to the errors detailed for
- * 		fwnode_property_get_reference_args().
- * 	        %-ENOMEM if we failed to allocate the bus.
- *		an error from the upstream's connect_phy() method.
+ * Returns:
+ * 	    - on success, a pointer to the sfp_bus structure,
+ *	    - %NULL if no SFP is specified,
+ * 	    - on failure, an error pointer value:
+ *
+ * 	      - corresponding to the errors detailed for
+ * 	        fwnode_property_get_reference_args().
+ * 	      - %-ENOMEM if we failed to allocate the bus.
+ *	      - an error from the upstream's connect_phy() method.
  */
 int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
 			 const struct sfp_upstream_ops *ops)
-- 
2.24.1

