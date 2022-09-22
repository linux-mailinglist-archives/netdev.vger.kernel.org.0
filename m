Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2895E586D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiIVCPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIVCPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:15:38 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8D24D81F;
        Wed, 21 Sep 2022 19:15:29 -0700 (PDT)
X-UUID: 9b8d627815ab4ea886bbf3e4b68af9d5-20220922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jSyECJmHSA/82hGI9rjL6xr8zQtVBlH0c/3uRbHeI0I=;
        b=p+lf44+Lio1fo5R0xsSI1aO1zk+It3e1WbfJLnCdI6QJBcdjStsbwMdGKuzdWkvAOgWy6YUE3NqpH58xbWFd+r3h6LSehecE9dYYRe/Zv26JQGpu1+6S2aRVXvjh3WXJjNthAT7sbpkquuGHNPhBuye7sVc90Vzg3/HAUENerKQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:0a4cf8f8-7e6b-4b1d-b486-22acb43fa813,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:97a739f7-6e85-48d9-afd8-0504bbfe04cb,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 9b8d627815ab4ea886bbf3e4b68af9d5-20220922
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1125236732; Thu, 22 Sep 2022 10:15:24 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 22 Sep 2022 10:15:23 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 22 Sep 2022 10:15:22 +0800
Message-ID: <d231f64e494f4badf8bbe23130b25594376c9882.camel@mediatek.com>
Subject: Re: [PATCH v3 2/2] dt-bindings: net: snps,dwmac: add clk_csr
 property
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
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
Date:   Thu, 22 Sep 2022 10:15:22 +0800
In-Reply-To: <bd460cfd-7114-b200-ab99-16fa3e2cff50@linaro.org>
References: <20220921070721.19516-1-jianguo.zhang@mediatek.com>
         <20220921070721.19516-3-jianguo.zhang@mediatek.com>
         <bd460cfd-7114-b200-ab99-16fa3e2cff50@linaro.org>
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

Dear Krzysztof,

	Thanks for your comment.

On Wed, 2022-09-21 at 10:24 +0200, Krzysztof Kozlowski wrote:
> On 21/09/2022 09:07, Jianguo Zhang wrote:
> > Add clk_csr property for snps,dwmac
> > 
> > Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> > ---
> >  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > index 491597c02edf..8cff30a8125d 100644
> > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -288,6 +288,11 @@ properties:
> >        is supported. For example, this is used in case of SGMII and
> >        MAC2MAC connection.
> >  
> > +  clk_csr:
> 
> No underscores in node names. Missing vendor prefix.
> 
We will remane the property name 'clk_csr' as 'snps,clk-csr' and
another driver patch is needed to align the name used in driver with
the new name. 
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description:
> > +      Frequency division factor for MDC clock.
> 
> Can't common clock framework do the job? What is the MDC clock?
> 
MDC clock is used for ethernet MAC accessing PHY register by MDIO bus.
There is frequency divider designed in ethernet internal HW to ensure
that ethernet can get correct frequency of MDC colck and the vlaue of
frequency divider can be got from DTS.
> Best regards,
> Krzysztof

BRS
Jianguo

