Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15A8493241
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 02:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350640AbiASBVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 20:21:30 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46930 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1350638AbiASBVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 20:21:23 -0500
X-UUID: bf9e6ac19536479c95c34f0e9dfed317-20220119
X-UUID: bf9e6ac19536479c95c34f0e9dfed317-20220119
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2129486808; Wed, 19 Jan 2022 09:21:18 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 19 Jan 2022 09:21:17 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Jan 2022 09:21:16 +0800
Message-ID: <c6f990fdf047eb90acaeb29f9f9b2941d6b7bf30.camel@mediatek.com>
Subject: Re: [PATCH net-next v12 7/7] net: dt-bindings: dwmac: add support
 for mt8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <angelogioacchino.delregno@collabora.com>,
        <macpaul.lin@mediatek.com>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        Jose Abreu <joabreu@synopsys.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <dkirjanov@suse.de>, Maxime Coquelin <mcoquelin.stm32@gmail.com>
Date:   Wed, 19 Jan 2022 09:21:15 +0800
In-Reply-To: <1642433742.934070.3923086.nullmailer@robh.at.kernel.org>
References: <20220117070706.17853-1-biao.huang@mediatek.com>
         <20220117070706.17853-8-biao.huang@mediatek.com>
         <1642433742.934070.3923086.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Rob,
	Thanks for your comments.

	If patch "[PATCH net-next v12 4/7] arm64: dts: mt2712: update
ethernet device node" is applied with dt-binding patches, "make
dtbs_check" will not report 
such warnings.
	Please review it kindly, thanks.

On Mon, 2022-01-17 at 09:35 -0600, Rob Herring wrote:
> On Mon, 17 Jan 2022 15:07:06 +0800, Biao Huang wrote:
> > Add binding document for the ethernet on mt8195.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >  .../bindings/net/mediatek-dwmac.yaml          | 28
> > ++++++++++++++++---
> >  1 file changed, 24 insertions(+), 4 deletions(-)
> > 
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for
> dtbs_check.
> This will change in the future.
> 
> Full log is available here: 
> https://patchwork.ozlabs.org/patch/1580608
> 
> 
> ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref']
> is too short
> 	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml
> 
> ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]]
> is too short
> 	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml
> 
> ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not
> contain items matching the given schema
> 	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml
> 
> ethernet@1101c000: compatible: 'oneOf' conditional failed, one must
> be fixed:
> 	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml
> 
> ethernet@1101c000: Unevaluated properties are not allowed
> ('compatible', 'reg', 'interrupts', 'interrupt-names', 'mac-address', 
> 'clock-names', 'clocks', 'power-domains', 'snps,axi-config',
> 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,txpbl',
> 'snps,rxpbl', 'clk_csr', 'phy-mode', 'phy-handle', 'snps,reset-gpio', 
> 'mdio' were unexpected)
> 	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml
> 

