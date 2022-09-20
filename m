Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE95BDA4D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiITCl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiITClz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:41:55 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3EF57E2E;
        Mon, 19 Sep 2022 19:41:53 -0700 (PDT)
X-UUID: ae26f053675141ed849e0a1e610a89fe-20220920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=sIGqGcIRrPYQKpKAtc4/Ah0ogLUo8Srchgvb8OewzRE=;
        b=aRvQ0VDRfgbGD6rD0Wj566EQJ9zlsbkzJKGh/pNPpEuxrCmVvVbctwupsGNoNCr1IxlPRjst4QgU6qJUtmMBSlQJXiwBtvgmSjec5RgD8tH0Xw5sCt1P7a1ZlA1Af+C2d1B7bKgdDzyYVOj6e6hBOeFpR44rzPYS8Q8M7Ukj68k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:d075e4ed-0c9a-4add-8ddf-a67c62c87db5,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:90
X-CID-INFO: VERSION:1.1.11,REQID:d075e4ed-0c9a-4add-8ddf-a67c62c87db5,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:90
X-CID-META: VersionHash:39a5ff1,CLOUDID:8714365e-5ed4-4e28-8b00-66ed9f042fbd,B
        ulkID:220920002500QDDVP7VP,BulkQuantity:70,Recheck:0,SF:28|17|19|48,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: ae26f053675141ed849e0a1e610a89fe-20220920
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1121040200; Tue, 20 Sep 2022 10:41:49 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 20 Sep 2022 10:41:48 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 20 Sep 2022 10:41:47 +0800
Message-ID: <f78e79520b5edc9b477c38131fd97e5e603c0428.camel@mediatek.com>
Subject: Re: [PATCH 2/2] net: dt-bindings: dwmac: add support for mt8188
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     <netdev@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Biao Huang <biao.huang@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Sep 2022 10:41:47 +0800
In-Reply-To: <20220919162453.4kkphzhc2tu6wzou@krzk-bin>
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
         <20220919080410.11270-3-jianguo.zhang@mediatek.com>
         <20220919162453.4kkphzhc2tu6wzou@krzk-bin>
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

On Mon, 2022-09-19 at 18:24 +0200, Krzysztof Kozlowski wrote:
> 'clk_csr'
'clk_csr' properity is parsed in driver, but it is not documented in
bingings for now. We will push a patch to describe 'clk_csr' in
snps,dwmac.yaml file in next version patches.

BRS
Jianguo

