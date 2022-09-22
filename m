Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336FD5E5C8A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIVHhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiIVHhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:37:09 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457E7CDCE7;
        Thu, 22 Sep 2022 00:37:05 -0700 (PDT)
X-UUID: 76aa0398248148a1934e81a715d2cef8-20220922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=/6bsX4RBcjvTUrrlX0LGHcO1IxWp0f22mVXpMN7I5ks=;
        b=ar6zWAYYBLJkZehh1Rk+l9JxNQIrLSyVL2GQNAbvS3Wk2n3eoU8VOOMLDhy95+P8CTZs8U+SX9xX2t7GqghmgsdwQqE+GWxqjGzCoMQrym2Ni6jhgvVhluDc3sFgJBo5mrDrnKDxI4Xa2h6ilprOxwznIxr3rjJGyXMNvEkp4nA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:81abf139-2e85-4b13-8fe3-165e62a61f9f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:45
X-CID-INFO: VERSION:1.1.11,REQID:81abf139-2e85-4b13-8fe3-165e62a61f9f,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:45
X-CID-META: VersionHash:39a5ff1,CLOUDID:a244dce3-87f9-4bb0-97b6-34957dc0fbbe,B
        ulkID:220921162412WQNVHANJ,BulkQuantity:205,Recheck:0,SF:28|17|19|48|823|8
        24,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,CO
        L:0
X-UUID: 76aa0398248148a1934e81a715d2cef8-20220922
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 175818648; Thu, 22 Sep 2022 15:36:59 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 22 Sep 2022 15:36:57 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Sep 2022 15:36:56 +0800
Message-ID: <9c28de4cef86d706baf92813f5d32cfd1630852e.camel@mediatek.com>
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
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date:   Thu, 22 Sep 2022 15:36:56 +0800
In-Reply-To: <821b3c30-6f1f-17c1-061c-8d3b3add0238@linaro.org>
References: <20220921070721.19516-1-jianguo.zhang@mediatek.com>
         <20220921070721.19516-3-jianguo.zhang@mediatek.com>
         <bd460cfd-7114-b200-ab99-16fa3e2cff50@linaro.org>
         <d231f64e494f4badf8bbe23130b25594376c9882.camel@mediatek.com>
         <821b3c30-6f1f-17c1-061c-8d3b3add0238@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Krzysztof,

On Thu, 2022-09-22 at 08:38 +0200, Krzysztof Kozlowski wrote:
> On 22/09/2022 04:15, Jianguo Zhang wrote:
> > Dear Krzysztof,
> > 
> > 	Thanks for your comment.
> > 
> > On Wed, 2022-09-21 at 10:24 +0200, Krzysztof Kozlowski wrote:
> > > On 21/09/2022 09:07, Jianguo Zhang wrote:
> > > > Add clk_csr property for snps,dwmac
> > > > 
> > > > Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> > > > ---
> > > >  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5
> > > > +++++
> > > >  1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git
> > > > a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > > b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > > index 491597c02edf..8cff30a8125d 100644
> > > > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > > @@ -288,6 +288,11 @@ properties:
> > > >        is supported. For example, this is used in case of SGMII
> > > > and
> > > >        MAC2MAC connection.
> > > >  
> > > > +  clk_csr:
> > > 
> > > No underscores in node names. Missing vendor prefix.
> > > 
> > 
> > We will remane the property name 'clk_csr' as 'snps,clk-csr' and
> > another driver patch is needed to align the name used in driver
> > with
> > the new name. 
> 
> You did not say anything that you document existing property. Commit
> msg
> *must* explain why you are doing stuff in commit body.
> 
> We should not be asking for this and for reason of clk_csr.

We will explain the background that why we document 'clk_csr' property
in binding file in commit message in next version patches.
> 
> Best regards,
> Krzysztof
> 
BRS
Jianguo

