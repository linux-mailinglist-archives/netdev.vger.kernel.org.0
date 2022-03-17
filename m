Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E4A4DCE7E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiCQTMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiCQTM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:12:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2BFE994B;
        Thu, 17 Mar 2022 12:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647544270; x=1679080270;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fmhExObKJfb9BUNo4OAayqN1xl6unRSZn3MfjAV8Bug=;
  b=dIcw9GlpVUZYE2C8r9jV/KJOPAgKt4E7RGx6xS+BWgvs1KVnO7TbkjqP
   IMTX/htfpMwzdKX9sC0Tb4z1MFTw7lKpo5bnXfAbhxvsgBLqGcTPY/qpU
   KIYM0RV0oUCHt4LHVy+9N951U942h91qdylf5CKlgcDlnTJqcUYlcX4X+
   NXzCvZkp/kfVnue7CWfZ/GzHkkv1+nm5lSEmCMWTRnxJgUtNARFnUyIcy
   98tbC7Y1GwvODEznP5cHDwWkFSJJie/B8u0uLLBXpS30m3lbuXT6D0S9y
   oqVQzz/XwnA17GFQ/koIBCvWxEECOwTf8rDgpwteHGhSSYReRk9Q5wCdt
   g==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="89307365"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 12:11:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 12:11:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 17 Mar 2022 12:11:08 -0700
Date:   Thu, 17 Mar 2022 20:14:06 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: mscc-miim: add lan966x
 compatible
Message-ID: <20220317191406.5ivtfkdlwzngmobi@soft-dev3-1.localhost>
References: <20220313002536.13068-1-michael@walle.cc>
 <20220313002536.13068-2-michael@walle.cc>
 <08b89b3f-d0d3-e96f-d1c3-80e8dfd0798f@kernel.org>
 <d18291ff8d81f03a58900935d92115f2@walle.cc>
 <2d35127c-d4ef-6644-289a-5c10bcbbbf84@kernel.org>
 <145fc079ce8c266b8c2265aacfd3b077@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <145fc079ce8c266b8c2265aacfd3b077@walle.cc>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/13/2022 17:30, Michael Walle wrote:

Hi Michael,

> 
> [adding Horatiu and Kavyasree from Microchip]
> 
> Am 2022-03-13 17:10, schrieb Krzysztof Kozlowski:
> > On 13/03/2022 11:47, Michael Walle wrote:
> > > Am 2022-03-13 10:47, schrieb Krzysztof Kozlowski:
> > > > On 13/03/2022 01:25, Michael Walle wrote:
> > > > > The MDIO controller has support to release the internal PHYs from
> > > > > reset
> > > > > by specifying a second memory resource. This is different between
> > > > > the
> > > > > currently supported SparX-5 and the LAN966x. Add a new compatible to
> > > > > distiguish between these two.
> > 
> > Typo here, BTW.
> > 
> > > > > 
> > > > > Signed-off-by: Michael Walle <michael@walle.cc>
> > > > > ---
> > > > >  Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt
> > > > > b/Documentation/devicetree/bindings/net/mscc-miim.txt
> > > > > index 7104679cf59d..a9efff252ca6 100644
> > > > > --- a/Documentation/devicetree/bindings/net/mscc-miim.txt
> > > > > +++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
> > > > > @@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
> > > > >  =================================================
> > > > > 
> > > > >  Properties:
> > > > > -- compatible: must be "mscc,ocelot-miim"
> > > > > +- compatible: must be "mscc,ocelot-miim" or "mscc,lan966x-miim"
> > > > 
> > > > No wildcards, use one, specific compatible.
> > > 
> > > I'm in a kind of dilemma here, have a look yourself:
> > > grep -r "lan966[28x]-" Documentation
> > > 
> > > Should I deviate from the common "name" now? To make things
> > > worse, there was a similar request by Arnd [1]. But the
> > > solution feels like cheating ("lan966x" -> "lan966") ;)
> > 
> > The previous 966x cases were added by one person from Microchip, so he
> > actually might know something. But do you know whether lan966x will
> > cover all current and future designs from Microchip? E.g. lan9669 (if
> > ever made) will be the same? Avoiding wildcard is the easiest, just
> > choose one implementation, e.g. "lan9662".
> 
> So if Microchip would review/ack this it would be ok? I don't really
> have a strong opinion, I just want to avoid any inconsistencies. If no
> one from Microchip will answer, I'll use microchip,lan9668-miim.

I think it is OK to use microchip,lan966x.
I am not aware of any plans to create future lan966x designed(lan9664 or
lan9669). But we can also be on the safe side and use microchip,lan9668.
I don't have any strong opinion on this.

Acked-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> > Different topic is that all current lan966[28] are from Microchip and
> > you still add Microsemi, even though it was acquired by Microchip.
> > That's an inconsistency which should be rather fixed.
> 
> Agreed, that was an oversight by me.
> 
> > > On a side note, I understand that there should be no wildcards,
> > > because the compatible should target one specific implementation,
> > > right? But then the codename "ocelot" represents a whole series of
> > > chips. Therefore, names for whole families shouldn't be used neither,
> > > right?
> > 
> > You're not adding "ocelot" now, so it is separate topic. However a
> > compatible like "mscc,ocelot" feels wrong, unless it is used as a
> > fallback (see: git grep 'apple,').
> 
> Sure, it was just a question for my understanding, not to make a
> point for a discussion.
> 
> -michael

-- 
/Horatiu
