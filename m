Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23C5E718D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiIWBsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiIWBsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:48:35 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C611166FD;
        Thu, 22 Sep 2022 18:48:34 -0700 (PDT)
X-UUID: 7639ba8871e34b4ba20f8ed1059ca1ea-20220923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=1k5TOoyEcepapXTo6DfuMdGwBHBkldYi/XOn9F6EwJA=;
        b=cJ+ZvhgPTPLkgEOCChkcJUHphHkjgYfz96qfeW7o/jPDakKFTB4u+XkKL7Ki+WC+OsuSY9WZUdSuVsoAspOsCCebkCS6gcXce88rNvRGNfkmKmk9uKtVpLmK5m1xjA/Z6RdrMIPI86VQszdEMMH6EuJ8FRCMeUus1lU+lDrAprA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:6f70596c-f29d-47e5-ac1e-feb7cbb33b87,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:f8d4f0e3-87f9-4bb0-97b6-34957dc0fbbe,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 7639ba8871e34b4ba20f8ed1059ca1ea-20220923
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1205604914; Fri, 23 Sep 2022 09:48:30 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Fri, 23 Sep 2022 09:48:29 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Fri, 23 Sep 2022 09:48:28 +0800
Message-ID: <8007b455dd18837c06ab099a6009505e7dddc124.camel@mediatek.com>
Subject: Re: [resend PATCH v4 2/2] dt-bindings: net: snps,dwmac: add clk_csr
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
        <linux-mediatek@lists.infradead.org>,
        Christophe Roullier <christophe.roullier@st.com>
Date:   Fri, 23 Sep 2022 09:48:28 +0800
In-Reply-To: <04b9e5ef-f3c7-3400-f9df-2f585a084c5d@linaro.org>
References: <20220922092743.22824-1-jianguo.zhang@mediatek.com>
         <20220922092743.22824-3-jianguo.zhang@mediatek.com>
         <04b9e5ef-f3c7-3400-f9df-2f585a084c5d@linaro.org>
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

On Thu, 2022-09-22 at 17:07 +0200, Krzysztof Kozlowski wrote:
> On 22/09/2022 11:27, Jianguo Zhang wrote:
> > The clk_csr property is parsed in driver for generating MDC clock
> > with correct frequency. A warning('clk_csr' was unexpeted) is
> > reported
> > when runing 'make_dtbs_check' because the clk_csr property
> > has been not documented in the binding file.
> > 
> 
> You did not describe the case, but apparently this came with
> 81311c03ab4d ("net: ethernet: stmmac: add management of clk_csr
> property") which never brought the bindings change.
> 
> Therefore the property was never part of bindings documentation and
> bringing them via driver is not the correct process. It bypasses the
> review and such bypass cannot be an argument to bring the property to
> bindings. It's not how new properties can be added.
> 
> Therefore I don't agree. Please make it a property matching bindings,
> so
> vendor prefix, no underscores in node names.
> 
> Driver and DTS need updates.
> 
We will rename the property 'clk_csr' as 'snps,clk-csr' and update DTS
& driver to align with the new name in next versions patches.
> Best regards,
> Krzysztof
> 
BRS
Jianguo

