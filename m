Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97188585DB4
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 08:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiGaF7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 01:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiGaF7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 01:59:17 -0400
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD4712AA4
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 22:59:15 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id I1ypo1mN3ghoJI1ypop3be; Sun, 31 Jul 2022 07:59:13 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 31 Jul 2022 07:59:13 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Rob Herring <robh@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] doc: sfp-phylink: Fix a broken reference
Date:   Sun, 31 Jul 2022 07:59:00 +0200
Message-Id: <be3c7e87ca7f027703247eccfe000b8e34805094.1659247114.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit in Fixes: has changed a .txt file into a .yaml file. Update the
documentation accordingly.

While at it add some `` around some file names to improve the output.

Fixes: 70991f1e6858 ("dt-bindings: net: convert sff,sfp to dtschema")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 Documentation/networking/sfp-phylink.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index 328f8d39eeb3..55b65f607a64 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -203,7 +203,7 @@ this documentation.
    The :c:func:`validate` method should mask the supplied supported mask,
    and ``state->advertising`` with the supported ethtool link modes.
    These are the new ethtool link modes, so bitmask operations must be
-   used. For an example, see drivers/net/ethernet/marvell/mvneta.c.
+   used. For an example, see ``drivers/net/ethernet/marvell/mvneta.c``.
 
    The :c:func:`mac_link_state` method is used to read the link state
    from the MAC, and report back the settings that the MAC is currently
@@ -224,7 +224,7 @@ this documentation.
    function should modify the state and only take the link down when
    absolutely necessary to change the MAC configuration.  An example
    of how to do this can be found in :c:func:`mvneta_mac_config` in
-   drivers/net/ethernet/marvell/mvneta.c.
+   ``drivers/net/ethernet/marvell/mvneta.c``.
 
    For further information on these methods, please see the inline
    documentation in :c:type:`struct phylink_mac_ops <phylink_mac_ops>`.
@@ -281,4 +281,4 @@ as necessary.
 
 For information describing the SFP cage in DT, please see the binding
 documentation in the kernel source tree
-``Documentation/devicetree/bindings/net/sff,sfp.txt``
+``Documentation/devicetree/bindings/net/sff,sfp.yaml``.
-- 
2.34.1

