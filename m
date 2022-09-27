Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17BE5EBDC0
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiI0Itj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiI0Ith (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:49:37 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD67649;
        Tue, 27 Sep 2022 01:49:35 -0700 (PDT)
X-UUID: 54547f90f4c24f05a9716be71998a468-20220927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=PWBKd6s+alHmuqMW7zBzYd2csWJfir6MkKHpoQDs4cg=;
        b=Ry/6IipgkSU2hqtXGAVjuy+5b5xKfu8wglUEzfr25o/dRZNXDRdrpfArD37Q0c7f24lLrXcY8AdAyJF7tvOW6Gkp1z5HrlGZD8Y7nk99nIf+dxBrOBkWeJ5dOmohV/tOzja0ZcyL9//6S7HvkQQNNFwyRI7EzHI+Bd4AowS9IHk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:6147a00e-7c2d-4823-ad3d-bed593ddf9b0,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:45
X-CID-INFO: VERSION:1.1.11,REQID:6147a00e-7c2d-4823-ad3d-bed593ddf9b0,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:45
X-CID-META: VersionHash:39a5ff1,CLOUDID:1eb737a3-dc04-435c-b19b-71e131a5fc35,B
        ulkID:220927164931O60JSLKQ,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 54547f90f4c24f05a9716be71998a468-20220927
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1987659540; Tue, 27 Sep 2022 16:49:30 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 27 Sep 2022 16:49:29 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 27 Sep 2022 16:49:27 +0800
Message-ID: <eb6a70844b067f76e8405b937de9408045d569a0.camel@mediatek.com>
Subject: Re: [PATCH v5 2/4] dt-bindings: net: snps,dwmac: add clk_csr
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
Date:   Tue, 27 Sep 2022 16:49:27 +0800
In-Reply-To: <a215ae81-10de-7880-1a15-b7b08d0d80d7@linaro.org>
References: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
         <20220923052828.16581-3-jianguo.zhang@mediatek.com>
         <a215ae81-10de-7880-1a15-b7b08d0d80d7@linaro.org>
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

On Fri, 2022-09-23 at 20:11 +0200, Krzysztof Kozlowski wrote:
> On 23/09/2022 07:28, Jianguo Zhang wrote:
> > The clk_csr property is parsed in driver for generating MDC clock
> > with correct frequency. A warning('clk_csr' was unexpeted) is
> > reported
> > when runing 'make_dtbs_check' because the clk_csr property
> > has been not documented in the binding file.
> 
> Your subject is not accurate anymore. Maybe mention that instead of
> existing clk_csr, you add a different property.
> 
> With commit msg fixes:
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
We will fix commit message in next version patches.

> Best regards,
> Krzysztof
> 
BRS
Jianguo

