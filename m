Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C2B5E5E8F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIVJ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiIVJ16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:27:58 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E32D01FA;
        Thu, 22 Sep 2022 02:27:56 -0700 (PDT)
X-UUID: e3798e00d9d84a178dcc01b841be18be-20220922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=AEDHKBZihGIiGE9DwyPBB3jdmuzA2C/OHvM+97eXVTA=;
        b=qi9ikbV8i+v1o1txjoJsQMHLAms9EDR2otZwxa0Jgi8pNVpPqQEFGxiPfo6hOPihNSma1aIqyoZe46JcxRGR/SkHA8AEQQnj8LPwjXHtNfLlse25TWuY0CEXNGxKKRo9z8TrG/5pNW9/sGCtbLCw+vxUHWhLKji2Ym+LUBB+HWY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:6f380ed0-86ca-488e-84ae-bd3f30fe4173,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:39a5ff1,CLOUDID:8d03ac06-1cee-4c38-b21b-a45f9682fdc0,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e3798e00d9d84a178dcc01b841be18be-20220922
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 44916873; Thu, 22 Sep 2022 17:27:52 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 22 Sep 2022 17:27:50 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 22 Sep 2022 17:27:50 +0800
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
        Jianguo Zhang <jianguo.zhang@mediatek.com>
Subject: [PATCH v4 0/2]  Mediatek ethernet patches for mt8188
Date:   Thu, 22 Sep 2022 17:27:41 +0800
Message-ID: <20220922092743.22824-1-jianguo.zhang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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


Changes in v4:

v4:
1) Update the commit message of patch 'dt-bindings: net: snps,dwmac: add clk_csr property'
as Krzysztof Kozlowski'comment.

v3:
1) List the names of SoCs mt8188 and mt8195 in correct order as
AngeloGioacchino Del Regno's comment.
2) Add patch version info as Krzysztof Kozlowski'comment.

v2:
1) Delete patch 'stmmac: dwmac-mediatek: add support for mt8188' as
Krzysztof Kozlowski's comment.
2) Update patch 'dt-bindings: net: mediatek-dwmac: add support for
mt8188' as Krzysztof Kozlowski's comment.
3) Add clk_csr property to fix warning ('clk_csr' was unexpected) when
runnig 'make dtbs_check'.

Jianguo Zhang (2):
  dt-bindings: net: mediatek-dwmac: add support for mt8188
  dt-bindings: net: snps,dwmac: add clk_csr property

 .../devicetree/bindings/net/mediatek-dwmac.yaml        | 10 ++++++++--
 Documentation/devicetree/bindings/net/snps,dwmac.yaml  |  5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

--
2.25.1


