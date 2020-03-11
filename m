Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80DA182290
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgCKTd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:33:59 -0400
Received: from balrog.mythic-beasts.com ([46.235.227.24]:37785 "EHLO
        balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731414AbgCKTd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:33:59 -0400
Received: from 204.33.90.146.dyn.plus.net ([146.90.33.204]:40284 helo=slartibartfast.quignogs.org.uk)
        by balrog.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <peter@bikeshed.quignogs.org.uk>)
        id 1jC728-0001Gt-6D; Wed, 11 Mar 2020 19:28:48 +0000
From:   peter@bikeshed.quignogs.org.uk
To:     linux-doc@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Peter Lister <peter@bikeshed.quignogs.org.uk>
Subject: [PATCH 1/1] Reformat return value descriptions as ReST lists.
Date:   Wed, 11 Mar 2020 19:28:23 +0000
Message-Id: <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
References: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 65
X-Spam-Status: No, score=6.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Lister <peter@bikeshed.quignogs.org.uk>

Added line breaks and blank lines to separate list items and escaped end-of-line
colons.

This removes these warnings from doc build...

./drivers/net/phy/sfp-bus.c:579: WARNING: Unexpected indentation.
./drivers/net/phy/sfp-bus.c:619: WARNING: Unexpected indentation.

Signed-off-by: Peter Lister <peter@bikeshed.quignogs.org.uk>
---
 drivers/net/phy/sfp-bus.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index d949ea7b4f8c..df1c66df830f 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -572,12 +572,18 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
  * the sfp_bus structure, incrementing its reference count.  This must
  * be put via sfp_bus_put() when done.
  *
- * Returns: on success, a pointer to the sfp_bus structure,
+ * Returns\:
+ *
+ *          on success, a pointer to the sfp_bus structure,
  *	    %NULL if no SFP is specified,
+ *
  * 	    on failure, an error pointer value:
+ *
  * 		corresponding to the errors detailed for
  * 		fwnode_property_get_reference_args().
+ *
  * 	        %-ENOMEM if we failed to allocate the bus.
+ *
  *		an error from the upstream's connect_phy() method.
  */
 struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
@@ -612,12 +618,18 @@ EXPORT_SYMBOL_GPL(sfp_bus_find_fwnode);
  * the SFP bus using sfp_register_upstream().  This takes a reference on the
  * bus, so it is safe to put the bus after this call.
  *
- * Returns: on success, a pointer to the sfp_bus structure,
+ * Returns\:
+ *
+ *          on success, a pointer to the sfp_bus structure,
  *	    %NULL if no SFP is specified,
+ *
  * 	    on failure, an error pointer value:
+ *
  * 		corresponding to the errors detailed for
  * 		fwnode_property_get_reference_args().
+ *
  * 	        %-ENOMEM if we failed to allocate the bus.
+ *
  *		an error from the upstream's connect_phy() method.
  */
 int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
-- 
2.24.1

