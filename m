Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F6F623736
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiKIXCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiKIXCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:02:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9786D11C36;
        Wed,  9 Nov 2022 15:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nWu9npcTwPxeit8kU4IBt2JR98yh/MyteHNryZAJhYo=; b=rE6M68O8OTU7+ozIF8d5aq9hWA
        K/KRgRk9QOWHN/M5HWRuCB3yUb4nRHex8v44vsShFPQ84E7W58zOLjwaFw7PABe99LCxZCeLhDukQ
        dtAb46AkRc/F1RK/oo3F0Z/b48TSK92Cbk22+/4BYCYjMmvSdkFx092dB+4VLdOiEsEc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osu3Z-001xaM-DX; Thu, 10 Nov 2022 00:00:29 +0100
Date:   Thu, 10 Nov 2022 00:00:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jan Petrous <jan.petrous@nxp.com>
Cc:     Chester Lin <clin@suse.com>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-S32 <S32@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [EXT] Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC
 dwmac glue driver
Message-ID: <Y2wxDc8i4cspaFnx@lunn.ch>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
 <Y2Q7KtYkvpRz76tn@lunn.ch>
 <Y2T5/w8CvZH5ZlE2@linux-8mug>
 <AM9PR04MB85066636DE2D99C8F2A9F4CDE23E9@AM9PR04MB8506.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB85066636DE2D99C8F2A9F4CDE23E9@AM9PR04MB8506.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Here I just focus on GMAC since there are other LAN interfaces that S32
> > family
> > uses [e.g. PFE]. According to the public GMACSUBSYS ref manual rev2[1]
> > provided
> > on NXP website, theoretically GMAC can run SGMII in 1000Mbps and
> > 2500Mbps so I
> > assume that supporting 1000BASE-X could be achievable. I'm not sure if any
> > S32
> > board variant might have SFP ports but RJ-45 [1000BASE-T] should be the
> > major
> > type used on S32G-EVB and S32G-RDB2.
> > 
> > @NXP, please feel free to correct me if anything wrong.
> > 
> 
> NXP eval boards (EVB or RDB) have also 2.5G PHYs, so together with SerDes
> driver we support 100M/1G/2.5G on such copper PHYs. 

Hi Jan

Does the SERDES clock need to change when going between 1000BaseX and
2500BaseX?

If so, it sounds like Linux not having control of that clock is going
to limit what can be supported.

   Andrew
