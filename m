Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC42E343FD8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhCVLbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhCVLbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:31:11 -0400
Received: from mxwww.masterlogin.de (mxwww.masterlogin.de [IPv6:2a03:2900:1:1::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1B7C061574;
        Mon, 22 Mar 2021 04:31:10 -0700 (PDT)
Received: from mxout3.routing.net (unknown [192.168.10.111])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id A31FE2C519;
        Mon, 22 Mar 2021 11:21:46 +0000 (UTC)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout3.routing.net (Postfix) with ESMTP id BB1DD604CD;
        Mon, 22 Mar 2021 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1616412100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuB5JOSUV2Mjm5gg71dyaHF7i8Fm6qxQ4YPT46nvR3Q=;
        b=loqjsueuK9GN1cOYY9FEVio5w/ZHhVzTwHZkU6dxdX6V1LcohctljMTCiyBiz5W6g9tRFs
        8iSAu24hIENojEdunvVN/cGBI14I0MT8fu8/CJ30uASCwvRxUkHz+vWuQ/h4M1GohzVWNF
        iwIDnHeCnHwpP9Z2/FfN4dUZnaKlcPo=
Received: from localhost.localdomain (unknown [80.245.73.88])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 00FC236009F;
        Mon, 22 Mar 2021 11:21:39 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: mediatek: add flow offload for mt7623
Date:   Mon, 22 Mar 2021 12:21:16 +0100
Message-Id: <20210322112117.16162-2-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322112117.16162-1-linux@fw-web.de>
References: <20210322112117.16162-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: ef0cd896-2961-4f04-8e14-c2c83bb8fd6e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

mt7623 uses offload version 2 too

tested on Bananapi-R2

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0396f0db855f..810def064f11 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3202,6 +3202,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
+	.offload_version = 2,
 };
 
 static const struct mtk_soc_data mt7629_data = {
-- 
2.25.1

