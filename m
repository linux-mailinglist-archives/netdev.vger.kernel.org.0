Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51391D04B5
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 02:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfJIASy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 20:18:54 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46701 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbfJIASy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 20:18:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CC6921AD0;
        Tue,  8 Oct 2019 20:18:53 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Tue, 08 Oct 2019 20:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm3; bh=XnTGS6EOP6i6blqf35sCohVJUtOChfq
        97RDyhHyjVP8=; b=k334bLsmf3nZcFTvoGADphWQLRg4YnOvWJcbv5/ViJdoR5k
        c1vZk4WDtE3au4qSQ0bOQ7e2Oty3Gf12e9bFL798kweYwz3j00GawU37okQus2A4
        FX0Fd5/ma+LEOYhFUkqkepZJdo3U8l2Fmn3pEyzFuJ34CpuI9s1kiQAqgqdoLGa7
        Y3dU3RCBzuD7xmpE6Llh4E5BWDdQ3MhdOBuFnm0HdNY1q5RyXWqdNeGS3eu75mOR
        XZZcLH723N3nYyapxZrUSLmlWXuPNLibwbJts7dstq84UKq8G4bm73TrMgFmbNKV
        FRmaOA4YWSehIrE3liubKN7BLbJeswolf1747vA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XnTGS6
        EOP6i6blqf35sCohVJUtOChfq97RDyhHyjVP8=; b=fe9QewgoY1CdSMOVn9Iy9b
        LxP6J5zHQVSHDbreULfK3aPNsgZukHLiryHHzePS46MvJm5F7HguOYgUXsqoVtgx
        pQiIn0FUjv2zdpGOSjtZHDsXbDReH5Ju4RYWZh4WynM2E71SVo1+FheCULQHmF0h
        /83qARjQIWSojk4KS/eilFouppv6PcOky+PFbvFeggp10Y9ZEzm145v6cs50f2SF
        r3w4XIujwU4WziApbkNsyGnTSvE6xJ1BDLMR2pPCu33XolvEGDX9QT8/I/OrBVha
        uLFVX+1Bg9GEOHNDB8LOlGgpuCztDq2lQQ840AYt2neh/Qs2jT86a1WINZon2YUg
        ==
X-ME-Sender: <xms:bCedXdsdrnUsQjR1kKY8PimpNyMZ-l0OZRlXHuS8hKOBk7_9GkgfNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucfrrghrrg
    hmpehmrghilhhfrhhomheprghnughrvgifsegrjhdrihgurdgruhenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:bCedXZy8sk7W2oCcCyBGnJ3neOvOzOEhSK1JjyFMbK42f1-qL_HStQ>
    <xmx:bCedXclk8DW4tIKPTG08rp41zNiKoWePrZVjxhUUBC_lwxT0Kx7WTw>
    <xmx:bCedXXYpazfgIPIC5F0VUy_2SQEanfFaMkOMb5PsYR2ukBQwzhrzxA>
    <xmx:bSedXVLjDUOgh3UnCeQ3W-e1L40xAuN2IAN7SWk4ATyOiR3E-szLKQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3EF58E00A5; Tue,  8 Oct 2019 20:18:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-360-g7dda896-fmstable-20191004v2
Mime-Version: 1.0
Message-Id: <01c7cafe-8b41-4099-af29-3593e27a1d20@www.fastmail.com>
In-Reply-To: <CACPK8XcWLCGupAF1EX1LB6A=mQY0s9kjgagr3EKEKJhnbt+j0g@mail.gmail.com>
References: <20191008115143.14149-1-andrew@aj.id.au>
 <20191008115143.14149-3-andrew@aj.id.au>
 <CACPK8XcWLCGupAF1EX1LB6A=mQY0s9kjgagr3EKEKJhnbt+j0g@mail.gmail.com>
Date:   Wed, 09 Oct 2019 10:49:45 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Joel Stanley" <joel@jms.id.au>
Cc:     netdev <netdev@vger.kernel.org>,
        "David Miller" <davem@davemloft.net>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: =?UTF-8?Q?Re:_[PATCH_2/3]_dt-bindings:_net:_ftgmac100:_Describe_clock_pr?=
 =?UTF-8?Q?operties?=
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 8 Oct 2019, at 23:12, Joel Stanley wrote:
> On Tue, 8 Oct 2019 at 11:50, Andrew Jeffery <andrew@aj.id.au> wrote:
> >
> > Critically, the AST2600 requires ungating the RMII RCLK if e.g. NCSI is
> > in use.
> >
> > Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
> > ---
> >  Documentation/devicetree/bindings/net/ftgmac100.txt | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
> > index 04cc0191b7dd..c443b0b84be5 100644
> > --- a/Documentation/devicetree/bindings/net/ftgmac100.txt
> > +++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
> > @@ -24,6 +24,12 @@ Optional properties:
> >  - no-hw-checksum: Used to disable HW checksum support. Here for backward
> >    compatibility as the driver now should have correct defaults based on
> >    the SoC.
> > +- clocks: In accordance with the generic clock bindings. Must describe the MAC
> > +  IP clock, and optionally an RMII RCLK gate for the AST2600.
> 
>  or AST2500.
> 
> With that fixed you can add my ack.

I'll do a v2 and fix the comments in the driver patch as well.

Cheers,

Andrew
