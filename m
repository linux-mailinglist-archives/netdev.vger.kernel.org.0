Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ECF5EBDAB
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiI0IoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiI0IoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:44:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986E675CD7;
        Tue, 27 Sep 2022 01:44:01 -0700 (PDT)
X-UUID: 0858ea5688ba4961adf2483bfe49b09e-20220927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=CSa/p/zpHyX4lGO/pfARnTvy0LVC/OySswcI+oOiq+w=;
        b=o/60iJHrOk9YoguZchqif/wc6aJLOzd7K7XAhtR4J8THKkgxNZkBVo23xWnuPck2ZpNMAfzwtcWWxWhWT+gTOTKuZvL0V9UqF8UxnmQYsKc9WaF87I+RIBi47y0ZqehxSjidPHgPEazf95yzjyUZvesMN5MroXiWJu/nD/xIBtU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:fef051df-6ce3-477c-a4d1-2aae656b7669,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:45
X-CID-INFO: VERSION:1.1.11,REQID:fef051df-6ce3-477c-a4d1-2aae656b7669,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:45
X-CID-META: VersionHash:39a5ff1,CLOUDID:ccd32907-1cee-4c38-b21b-a45f9682fdc0,B
        ulkID:2209271643576FUGZFGP,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 0858ea5688ba4961adf2483bfe49b09e-20220927
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 898136717; Tue, 27 Sep 2022 16:43:55 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 27 Sep 2022 16:43:54 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 27 Sep 2022 16:43:53 +0800
Message-ID: <5d0980dd11afdd948059bcf9afa2484e5ee97bec.camel@mediatek.com>
Subject: Re: [PATCH v5 4/4] net: stmmac: Update the name of property
 'clk_csr'
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "AngeloGioacchino Del Regno" 
        <angelogioacchino.delregno@collabora.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>
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
Date:   Tue, 27 Sep 2022 16:43:53 +0800
In-Reply-To: <4f205f0d-420d-8f51-ad26-0c2475c0decd@linaro.org>
References: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
         <20220923052828.16581-5-jianguo.zhang@mediatek.com>
         <e0fa3ddf-575d-9e25-73d8-e0858782b73f@collabora.com>
         <ac24dc0f-0038-5068-3ce6-bbace55c7027@linaro.org>
         <4f205f0d-420d-8f51-ad26-0c2475c0decd@linaro.org>
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
	Thanks for your comment.

On Fri, 2022-09-23 at 20:15 +0200, Krzysztof Kozlowski wrote:
> On 23/09/2022 20:14, Krzysztof Kozlowski wrote:
> > > This is going to break MT2712e on old devicetrees.
> > > 
> > > The right way of doing that is to check the return value of
> > > of_property_read_u32()
> > > for "snps,clk-csr": if the property is not found, fall back to
> > > the old "clk_csr".
> > 
> > I must admit - I don't care. That's the effect when submitter
> > bypasses
> > DT bindings review (81311c03ab4d ("net: ethernet: stmmac: add
> > management
> > of clk_csr property")).
> > 
> > If anyone wants ABI, please document the properties.
> > 
> > If out-of-tree users complain, please upstream your DTS or do not
> > use
> > undocumented features...
> > 
> 
> OTOH, as Angelo pointed out, handling old and new properties is quite
> easy to achieve, so... :)
> 
So, the conclusion is as following:

1. add new property 'snps,clk-csr' and document it in binding file.
2. parse new property 'snps,clk-csr' firstly, if failed, fall back to
old property 'clk_csr' in driver.

Is my understanding correct?

> Best regards,
> Krzysztof
> 
BRS
Jianguo

