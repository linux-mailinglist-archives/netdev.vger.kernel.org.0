Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4E766CA56
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjAPRCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjAPRBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:01:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C1F39B95;
        Mon, 16 Jan 2023 08:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gFuyelicB2QFX6LrQoE6wpQRJWFtNcb69z+Tk9PIWPc=; b=RDZdnm0nIbvuFgz3GKJ/cdtdS0
        he7c3RzhKJPfipw1gAHWAMTZfzt8GXsgPd3o9jpcr2eLLorRcO9btRUbLlYy4mjQ7sduzF6TEo1Hx
        tn39KTtJ2LNc5HpYym0zTdAkxu3I8kNLyzLM++kFs+B2pjCx3ENhLM6QNcBSTLcBwoZqHXZyRJwwP
        Xdr0cqR6uOQakXpVnJoJDVkrYJ0xa+TJCxBcIFVUEQllmDSyPdn6V3AsL1fVZQp15Bt9l6Q3bIA+b
        sg0cX7CdCRDG/Uyg/Asw3oSQmD+N11GQavK8H4G18E3dNGWT3V54JyJLgHskHQTStSckFAX+vajYv
        om6G1E0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36134)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHSZx-0005RP-Gn; Mon, 16 Jan 2023 16:43:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHSZq-0006AQ-29; Mon, 16 Jan 2023 16:43:18 +0000
Date:   Mon, 16 Jan 2023 16:43:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y8V+pvWlV6pSuDX/@shell.armlinux.org.uk>
References: <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
 <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
 <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
 <87o7qy39v5.fsf@miraculix.mork.no>
 <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
 <87h6wq35dn.fsf@miraculix.mork.no>
 <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
 <87bkmy33ph.fsf@miraculix.mork.no>
 <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
 <875yd630cu.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875yd630cu.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 05:33:53PM +0100, Bjørn Mork wrote:
> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> 
> > On Mon, Jan 16, 2023 at 04:21:30PM +0100, Bjørn Mork wrote:
> >> [   54.539438] mtk_soc_eth 15100000.ethernet wan: Link is Down
> >> [   56.619937] mtk_sgmii_select_pcs: id=1
> >> [   56.623690] mtk_pcs_config: interface=4
> >> [   56.627511] offset:0 0x140
> >> [   56.627513] offset:4 0x4d544950
> >> [   56.630215] offset:8 0x20
> >> [   56.633340] forcing AN
> >> [   56.638292] mtk_pcs_config: rgc3=0x0, advertise=0x1 (changed), link_timer=1600000,  sgm_mode=0x103, bmcr=0x1000, use_an=1
> >> [   56.649226] mtk_pcs_link_up: interface=4
> >> [   56.653135] offset:0 0x81140
> >> [   56.653137] offset:4 0x4d544950
> >> [   56.656001] offset:8 0x1
> >> [   56.659137] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full - flow control rx/tx
> >
> > Thanks - there seems to be something weird with the bmcr value printed
> > above in the mtk_pcs_config line.
> >
> > You have bmcr=0x1000, but the code sets two bits - SGMII_AN_RESTART and
> > SGMII_AN_ENABLE which are bits 9 and 12, so bmcr should be 0x1200, not
> > 0x1000. Any ideas why?
> 
> No, not really
> 
> > Can you also hint at what the bits in the PHY register you quote mean
> > please?
> 
> This could very well be a red herring.  It's the only difference I've
> been able to spot, but I have no idea what it means.
> 
> This is an attempt at reformatting the pdf tables for email.  Hope it's
> readable: 

I found the document for the PHY at:

https://assets.maxlinear.com/web/documents/617792_gpy212b1vc_gpy212c0vc_ds_rev1.3.pdf

It seems as I suspected, the PHY has not completed SGMII AN. Please
can you read register 8 when operating at 1G speeds as well
(VSPEC1_SGMII_CTRL)? Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
