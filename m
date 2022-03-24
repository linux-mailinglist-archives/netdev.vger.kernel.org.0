Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083044E5C73
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 01:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346870AbiCXAxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 20:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiCXAxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 20:53:50 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F4D90FDF;
        Wed, 23 Mar 2022 17:52:14 -0700 (PDT)
X-UUID: 9be1904981d042b891cc123de4c0a5b3-20220324
X-UUID: 9be1904981d042b891cc123de4c0a5b3-20220324
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1488320240; Thu, 24 Mar 2022 08:52:10 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 24 Mar 2022 08:52:09 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Mar 2022 08:52:08 +0800
Message-ID: <6a2f52d2a173a9127ea517c81c3c1c5fe7b2b009.camel@mediatek.com>
Subject: Re: [PATCH net-next v13 5/7] net: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>, <dkirjanov@suse.de>
Date:   Thu, 24 Mar 2022 08:52:08 +0800
In-Reply-To: <CAL_Jsq+6XKvS5RcE6j9vRd3JL-Wbi-O6BrcoGQ5xV0Q2ZG8EMw@mail.gmail.com>
References: <20220314075713.29140-1-biao.huang@mediatek.com>
         <20220314075713.29140-6-biao.huang@mediatek.com>
         <CAL_Jsq+6XKvS5RcE6j9vRd3JL-Wbi-O6BrcoGQ5xV0Q2ZG8EMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Rob,

	Sorry for the failings.

	"snps,txpbl"/"snps,rxpbl" are limited to enum [2,4,8] in
snps,dwmac.yaml, but the hardware allows 1,2,4,8,16 or 32 according to
datasheet.

	I'll submit another patch to modify enum in snps,dwmac.yaml.

Regards!
Biao

On Wed, 2022-03-23 at 09:00 -0500, Rob Herring wrote:
> On Mon, Mar 14, 2022 at 2:57 AM Biao Huang <biao.huang@mediatek.com>
> wrote:
> > 
> > Convert mediatek-dwmac to DT schema, and delete old mediatek-
> > dwmac.txt.
> > And there are some changes in .yaml than .txt, others almost keep
> > the same:
> >   1. compatible "const: snps,dwmac-4.20".
> >   2. delete "snps,reset-active-low;" in example, since driver
> > remove this
> >      property long ago.
> >   3. add "snps,reset-delay-us = <0 10000 10000>" in example.
> >   4. the example is for rgmii interface, keep related properties
> > only.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../bindings/net/mediatek-dwmac.txt           |  91 ----------
> >  .../bindings/net/mediatek-dwmac.yaml          | 155
> > ++++++++++++++++++
> >  2 files changed, 155 insertions(+), 91 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-
> > dwmac.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/mediatek-
> > dwmac.yaml
> 
> Now failing in linux-next:
> 
> /builds/robherring/linux-
> dt/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb:
> ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
>  From schema: /builds/robherring/linux-
> dt/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> /builds/robherring/linux-
> dt/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb:
> ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
>  From schema: /builds/robherring/linux-
> dt/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 
> 
> Rob

