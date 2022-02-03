Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193534A8894
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiBCQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352216AbiBCQbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:31:19 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4BBC061401
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:31:18 -0800 (PST)
Received: (qmail 17228 invoked from network); 3 Feb 2022 16:22:53 -0000
Received: from p200300cf070ba5000c0051fffe8bdde4.dip0.t-ipconnect.de ([2003:cf:70b:a500:c00:51ff:fe8b:dde4]:41724 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 17:22:53 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     netdev@vger.kernel.org
Subject: [PATCH 2/3] sunhme: fix the version number in struct ethtool_drvinfo
Date:   Thu, 03 Feb 2022 17:22:23 +0100
Message-ID: <3152336.aeNJFYEL58@eto.sf-tec.de>
In-Reply-To: <4686583.GXAFRqVoOG@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 050bbb196392b9c178f82b1205a23dd2f915ee93
Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
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
2.31.1




