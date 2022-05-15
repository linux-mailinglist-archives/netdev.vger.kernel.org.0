Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB5E5277B0
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiEONIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 09:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiEONIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 09:08:12 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472BB13F49;
        Sun, 15 May 2022 06:08:07 -0700 (PDT)
X-UUID: 7a5406948e69413292efc437d23df727-20220515
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:21012914-c164-469e-95ba-7f2c76832842,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:51,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:51
X-CID-INFO: VERSION:1.1.5,REQID:21012914-c164-469e-95ba-7f2c76832842,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:51,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:51
X-CID-META: VersionHash:2a19b09,CLOUDID:34cf5ba7-eab7-4b74-a74d-5359964535a9,C
        OID:ea623f10d9f5,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:0,BEC:nil
X-UUID: 7a5406948e69413292efc437d23df727-20220515
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 18405378; Sun, 15 May 2022 21:08:01 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Sun, 15 May 2022 21:08:00 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Sun, 15 May 2022 21:08:00 +0800
Message-ID: <8366aa6336e268490eba5cf4aa7a8d5049185956.camel@mediatek.com>
Subject: Re: [PATCH net-next 01/14] arm64: dts: mediatek: mt7986: introduce
 ethernet nodes
From:   Landen Chao <landen.chao@mediatek.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "john@phrozen.org" <john@phrozen.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Mark-MC Lee =?UTF-8?Q?=28=E6=9D=8E=E6=98=8E=E6=98=8C=29?= 
        <Mark-MC.Lee@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Sam Shih =?UTF-8?Q?=28=E5=8F=B2=E7=A2=A9=E4=B8=89=29?= 
        <Sam.Shih@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh@kernel.org" <robh@kernel.org>
Date:   Sun, 15 May 2022 21:08:00 +0800
In-Reply-To: <Yn97GqujwYlljkdH@lore-desk>
References: <cover.1651839494.git.lorenzo@kernel.org>
         <1d555fbbac820e9b580da3e8c0db30e7d003c4b6.1651839494.git.lorenzo@kernel.org>
         <YnZ8o46pPdKMCbUF@lunn.ch> <YnlC3jvYarpV6BP1@lore-desk>
         <YnlFBr1wgb/hlduy@lunn.ch> <Yn97GqujwYlljkdH@lore-desk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-05-14 at 17:49 +0800, Lorenzo Bianconi wrote:
> > On Mon, May 09, 2022 at 06:35:42PM +0200, Lorenzo Bianconi wrote:
> > > > > +&eth {
> > > > > +	status = "okay";
> > > > > +
> > > > > +	gmac0: mac@0 {
> > > > > +		compatible = "mediatek,eth-mac";
> > > > > +		reg = <0>;
> > > > > +		phy-mode = "2500base-x";
> > > > > +
> > > > > +		fixed-link {
> > > > > +			speed = <2500>;
> > > > > +			full-duplex;
> > > > > +			pause;
> > > > > +		};
> > > > > +	};
> > > > > +
> > > > > +	gmac1: mac@1 {
> > > > > +		compatible = "mediatek,eth-mac";
> > > > > +		reg = <1>;
> > > > > +		phy-mode = "2500base-x";
> > > > > +
> > > > > +		fixed-link {
> > > > > +			speed = <2500>;
> > > > > +			full-duplex;
> > > > > +			pause;
> > > > > +		};
> > > > > +	};
> > > > 
> > > > Are both connected to the switch? It just seems unusual two
> > > > have two
> > > > fixed-link ports.
> > > 
> > > afaik mac design supports autoneg only in 10M/100M/1G mode and
> > > mt7986 gmac1
> > > is connected to a 2.5Gbps phy on mt7986-ref board.
> > 
> > The MAC does not normally perform autoneg, the PHY
> > does. phylib/phylink then tells the MAC the result of the
> > negotiation. If there is a SERDES/PCS involved, and it is
> > performing
> > the autoneg, phylink should get told about the result of the
> > autoneg
> > and it will tell the MAC the result.
> > 
> > So the gmac1 should just have phy-handle pointing to the PHY, not a
> > fixed link.
> > 
> >       Andrew
> 
> adding Landen to the discussion to provide more hw details.
> @Landen: any inputs on it?

The 2.5Gbps phy on mt7986-ref board enables the HW "rate adaption"
function which phy fixes 2.5Gbps to MAC as well. If the link rate of
Ethernet phy side is less than 2.5G, the 2.5Gbps phy HW will send pause
frame to MAC to adapt the real Tx rate. By the way, the 2.5Gbps phy
advertise all rates to link partner in HW default setting.

Regards,
Landen
> 
> Regards,
> Lorenzo

