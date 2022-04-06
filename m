Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402944F66B2
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbiDFROd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238533AbiDFROX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:14:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7FB2661E9
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DUAo+mqYnAUG+mILjNagVGzTyTx2txWqKx2hHt8JQgQ=; b=DcrJHcfWXhL/+trcV52rNWOE0C
        /NWlUwoJQUt/2aeM3SmW2Da1KIlyDKHOdwmtupE9Hxioj+aVJFiS1/R+mH2NSTmA0nmyNfbm55yrO
        ZC8hhYUccRia7O0Xx0wVuo76lJbCwqa96zot/DYdaNB3A1HJGKaTSRelmdvciftbbj/ky7lPVR7fP
        JjL/kMn5dwKh/bekfVUg3zX6C4f+LfEj/yRiyOuHlEAUDMpk4WO3ED0SYLyzBojRMjKIG+0LO8RsA
        9rKmCNXOPTJ4gZQpbN0brtqh3TQN9x0UHB9kY7crAkQ5w4OtswbhvYoFU9oOpY7Uhiyi7r/oGiGyN
        /MMXtPHA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60662 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc6kO-0002tt-Fs; Wed, 06 Apr 2022 15:35:00 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc6kN-004ijV-JN; Wed, 06 Apr 2022 15:34:59 +0100
In-Reply-To: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
References: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 01/12] net: mtk_eth_soc: remove unused mac->mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc6kN-004ijV-JN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 15:34:59 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mac->mode is only ever written to in one location, and is thus
superflous. Remove it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f02d07ec5ccb..e491d43f049a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2968,7 +2968,6 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	/* mac config is not set */
 	mac->interface = PHY_INTERFACE_MODE_NA;
-	mac->mode = MLO_AN_PHY;
 	mac->speed = SPEED_UNKNOWN;
 
 	mac->phylink_config.dev = &eth->netdev[id]->dev;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index c9d42be314b5..2b690f8a5391 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -989,7 +989,6 @@ struct mtk_eth {
 struct mtk_mac {
 	int				id;
 	phy_interface_t			interface;
-	unsigned int			mode;
 	int				speed;
 	struct device_node		*of_node;
 	struct phylink			*phylink;
-- 
2.30.2

