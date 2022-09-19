Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD25BC46A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiISIh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiISIh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:37:58 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B812AE0BD;
        Mon, 19 Sep 2022 01:37:49 -0700 (PDT)
X-UUID: 895f2384ca4e4ffca7c6a48e06f35fb1-20220919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=mdUEu1fQsGtzQ+XxXa8k3lP/oiajX1dl1+hD3ovqtYY=;
        b=qCnGERSEKmeg4T1Af69maJALmas9iobV7cOdrigtqLAcJ0CrFRrw82B/nvWTgmg/vhYRGXlIB/TcVVh59uVl1yg9mro/Vqtwr+vqiFORfZPFeOZk3KhaDZlMx8Mz1KmqJs49WTLqK5jkOIoYeLcoyeQIKbnei4zKdgGmdjgUWag=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:4d7977c8-8d73-4d87-bec6-b59ebcdab40e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:8ce3e0f6-6e85-48d9-afd8-0504bbfe04cb,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 895f2384ca4e4ffca7c6a48e06f35fb1-20220919
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 573007974; Mon, 19 Sep 2022 16:37:46 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 19 Sep 2022 16:37:45 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 19 Sep 2022 16:37:44 +0800
Message-ID: <4c537b63f609ae974dfb468ebc31225d45f785e8.camel@mediatek.com>
Subject: Re: [PATCH 1/2] stmmac: dwmac-mediatek: add support for mt8188
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 19 Sep 2022 16:37:44 +0800
In-Reply-To: <d28ce676-ed6e-98da-9761-ed46f2fa4a95@linaro.org>
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
         <20220919080410.11270-2-jianguo.zhang@mediatek.com>
         <d28ce676-ed6e-98da-9761-ed46f2fa4a95@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Krzysztof,

	Thanks for your comments.


On Mon, 2022-09-19 at 10:19 +0200, Krzysztof Kozlowski wrote:
> On 19/09/2022 10:04, Jianguo Zhang wrote:
> > Add ethernet support for MediaTek SoCs from mt8188 family.
> > As mt8188 and mt8195 have same ethernet design, so private data
> > "mt8195_gmac_variant" can be reused for mt8188.
> > 
> > Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > index d42e1afb6521..f45be440b6d0 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > @@ -720,6 +720,8 @@ static const struct of_device_id
> > mediatek_dwmac_match[] = {
> >  	  .data = &mt2712_gmac_variant },
> >  	{ .compatible = "mediatek,mt8195-gmac",
> >  	  .data = &mt8195_gmac_variant },
> > +	{ .compatible = "mediatek,mt8188-gmac",
> > +	  .data = &mt8195_gmac_variant },
> 
> It's the same. No need for new entry.
> 
mt8188 and mt8195 are different SoCs and we need to distinguish mt8188
from mt8195, so I think a new entry is needed for mt8188 with the
specific "compatiable".
On the other hand, mt8188 and mt8195 have same ethernet design, so the
private data "mt8195_gmac_variant" can be resued to reduce redundant
info in driver.

> 
> Best regards,
> Krzysztof

