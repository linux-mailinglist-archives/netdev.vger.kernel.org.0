Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86A66A1C43
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjBXMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBXMgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:36:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8222767996
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D28DDJH9u+51fbuNH6FlD2OnOZeG3P4gcCfgY7q18CY=; b=BNE/u4RIuLfquJUUW/5GHhr5xb
        6IMOtvCE8YP+oPn2pV0vtPN76WPlcEfgEvdu/UoULGVQctoQVafOl7MoMj1uto8Ys9KULGeNVAvA4
        30WEk/kA+xyILfnuGLP3Yk122pvgMTZbpvrgfArx2c/H+2RKP2ce/pZ3jeAEi585GO7jtjxWc1ysC
        3cwFMcgb0PbGnf7EN6jFY/4ghQyq2+rtw5fgy7ewpkWe0et5+5xLXI2SB76yPTMqy9CzuSopgWYQ9
        WnSQipgMl5iWRi4q/majMecLnck4tOJlXQRgHwiVeaSuuV6uVvGytYqzL92RKhBksO9UER0OlFyiG
        qeJp4FDQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47980 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pVXJL-0000dz-KN; Fri, 24 Feb 2023 12:36:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pVXJK-00CTAl-V7; Fri, 24 Feb 2023 12:36:27 +0000
In-Reply-To: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes not
 set in supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Feb 2023 12:36:26 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f78810717f66..280490942fa4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -530,9 +530,11 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		case PHY_INTERFACE_MODE_GMII:
 			ge_mode = 1;
 			break;
+		/* FIXME: RMII is not set in the phylink capabilities */
 		case PHY_INTERFACE_MODE_REVMII:
 			ge_mode = 2;
 			break;
+		/* FIXME: RMII is not set in the phylink capabilities */
 		case PHY_INTERFACE_MODE_RMII:
 			if (mac->id)
 				goto err_phy;
-- 
2.30.2

