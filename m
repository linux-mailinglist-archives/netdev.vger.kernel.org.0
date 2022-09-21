Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92475BF29B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIUBPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIUBPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:15:00 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB351A380;
        Tue, 20 Sep 2022 18:14:52 -0700 (PDT)
X-UUID: 00dbde89468e48c8980368407c5174c2-20220921
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ktfKjkuCSlQ6+XBcD3iNIlUZc9IseljbIXo3FqlLINs=;
        b=ONomnynQNKYp/OtLRjDQSsdjunAulXc1ExepZW83eEyolFjTf/K2V4hU9q+NGLNwuri/TnbdNG4N7UITHO9xQ0jAi5EAWM4rEpM46EguIoWOcOXrFQDT0rfE8KMxckJJc0xDRl3ihTdZCjWQSkdl27exgzBUw3VjdEsdIrJ6j2k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:a6447ef3-ae29-4966-8222-13df92a4bb1b,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:ffe915f7-6e85-48d9-afd8-0504bbfe04cb,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 00dbde89468e48c8980368407c5174c2-20220921
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 423726621; Wed, 21 Sep 2022 09:14:47 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 21 Sep 2022 09:14:46 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Sep 2022 09:14:45 +0800
Message-ID: <63ca556b81bc2874d3f0a5b87ee0e2f7a4fdeb18.camel@mediatek.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: mediatek-dwmac: add support for
 mt8188
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Date:   Wed, 21 Sep 2022 09:14:44 +0800
In-Reply-To: <3ed55b0d-6c14-79a1-b4c1-5764c667d195@collabora.com>
References: <20220920083617.4177-1-jianguo.zhang@mediatek.com>
         <20220920083617.4177-2-jianguo.zhang@mediatek.com>
         <3ed55b0d-6c14-79a1-b4c1-5764c667d195@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY,URIBL_CSS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear AngeloGioacchino

	Thanks for your comment.

On Tue, 2022-09-20 at 15:22 +0200, AngeloGioacchino Del Regno wrote:
> Il 20/09/22 10:36, Jianguo Zhang ha scritto:
> > Add binding document for the ethernet on mt8188
> > 
> > Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> > ---
> >   .../devicetree/bindings/net/mediatek-dwmac.yaml        | 10
> > ++++++++--
> >   1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mediatek-
> > dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-
> > dwmac.yaml
> > index 61b2fb9e141b..eaf7e8d53432 100644
> > --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > @@ -20,6 +20,7 @@ select:
> >           enum:
> >             - mediatek,mt2712-gmac
> 
> Please keep the list ordered by name. MT8188 goes before 8195.
> 
We will adjust the order in next version patches.

> >             - mediatek,mt8195-gmac
> > +          - mediatek,mt8188-gmac
> >     required:
> >       - compatible
> >   
> > @@ -37,6 +38,11 @@ properties:
> >             - enum:
> >                 - mediatek,mt8195-gmac
> >             - const: snps,dwmac-5.10a
> > +      - items:
> > +          - enum:
> > +              - mediatek,mt8188-gmac
> > +          - const: mediatek,mt8195-gmac
> > +          - const: snps,dwmac-5.10a
> >   
> >     clocks:
> >       minItems: 5
> > @@ -74,7 +80,7 @@ properties:
> >         or will round down. Range 0~31*170.
> >         For MT2712 RMII/MII interface, Allowed value need to be a
> > multiple of 550,
> >         or will round down. Range 0~31*550.
> > -      For MT8195 RGMII/RMII/MII interface, Allowed value need to
> > be a multiple of 290,
> > +      For MT8195/MT8188 RGMII/RMII/MII interface, Allowed value
> > need to be a multiple of 290,
> 
> For MT8188/MT8195
> 
We will adjust the order in next version patches.

> >         or will round down. Range 0~31*290.
> >   
> >     mediatek,rx-delay-ps:
> > @@ -84,7 +90,7 @@ properties:
> >         or will round down. Range 0~31*170.
> >         For MT2712 RMII/MII interface, Allowed value need to be a
> > multiple of 550,
> >         or will round down. Range 0~31*550.
> > -      For MT8195 RGMII/RMII/MII interface, Allowed value need to
> > be a multiple
> > +      For MT8195/MT8188 RGMII/RMII/MII interface, Allowed value
> > need to be a multiple
> 
> For MT8188/MT8195
> 
We will adjust the order in next version patches.

> >         of 290, or will round down. Range 0~31*290.
> >   
> >     mediatek,rmii-rxc:
> 
> 
BRS
Jianguo

