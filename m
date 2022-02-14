Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E34B59F2
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353761AbiBNSdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 13:33:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiBNSdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 13:33:18 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4411652E3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 10:33:09 -0800 (PST)
Received: (qmail 3144 invoked from network); 14 Feb 2022 18:31:22 -0000
Received: from p200300cf070c090076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70c:900:76d4:35ff:feb7:be92]:55230 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 19:31:22 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     netdev@vger.kernel.org
Subject: [PATCH 2/3 v2] sunhme: fix the version number in struct ethtool_drvinfo
Date:   Mon, 14 Feb 2022 19:33:07 +0100
Message-ID: <5795136.lOV4Wx5bFT@eto.sf-tec.de>
In-Reply-To: <3152336.aeNJFYEL58@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de> <3152336.aeNJFYEL58@eto.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver prints a version number on startup, use the same one here.

Fixes: 050bbb196392 ("[NET] sunhme: Convert to new SBUS driver framework.")
Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
v2: correct "Fixes" line syntax

 drivers/net/ethernet/sun/sunhme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 22abfe58f728..43834339bb43 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2470,8 +2470,8 @@ static void hme_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct happy_meal *hp = netdev_priv(dev);
 
-	strlcpy(info->driver, "sunhme", sizeof(info->driver));
-	strlcpy(info->version, "2.02", sizeof(info->version));
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	if (hp->happy_flags & HFLAG_PCI) {
 		struct pci_dev *pdev = hp->happy_dev;
 		strlcpy(info->bus_info, pci_name(pdev), sizeof(info->bus_info));
-- 
2.34.1




