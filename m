Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBF441B979
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbhI1VlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232358AbhI1VlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1420D61288;
        Tue, 28 Sep 2021 21:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632865161;
        bh=R7f+KH6pTNCbXYq0x7I45wP33jRLWv//E0u0+Zdp0f4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=glQR3XmvwcUyQZRi5+DF7+AwSmCH4DXfMXEb5cv1Spr/5pw12umNjgkBoE/vpKMz9
         1j2/qUxmMuKxVR61GFEqBulqZjafhhTwIlx2kmelUrGAAn8LZzYWjTyFfFaTxDk/Bp
         p2s/8A0Z+kCbnttCnpU/KFjBq+mVdIbNrYP2ibce/D65zvFfdzWm+yH0r9pCFRttJG
         7S0Jzod7S0NH7B6LGzRNG/jYWU29F70RjJ6NLdKJVosY4WCxTZ3RwVpfUldKOjn7US
         9wc4HtR0JBq2H1QLDsyifRDQlcOEseSyZJNDvroaNYJ5h/5C7/7Lz/oQ/9HlrV94+U
         5Tr5GDVGFB11A==
Received: by pali.im (Postfix)
        id 77B377E1; Tue, 28 Sep 2021 23:39:18 +0200 (CEST)
Date:   Tue, 28 Sep 2021 23:39:18 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Scott Wood <oss@buserror.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Message-ID: <20210928213918.v4n3bzecbiltbktd@pali>
References: <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210704134325.24842-1-pali@kernel.org>
 <63a72f648297e96c140a1412c20bd3796398a932.camel@buserror.net>
 <20210827113836.hvqvaln65gexg5ps@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210827113836.hvqvaln65gexg5ps@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 27 August 2021 13:38:36 Pali Rohár wrote:
> On Wednesday 14 July 2021 12:11:49 Scott Wood wrote:
> > On Sun, 2021-07-04 at 15:43 +0200, Pali Rohár wrote:
> > > Property phy-connection-type contains invalid value "sgmii-2500" per scheme
> > > defined in file ethernet-controller.yaml.
> > > 
> > > Correct phy-connection-type value should be "2500base-x".
> > > 
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the
> > > board device tree(s)")
> > > ---
> > >  arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > index 5ba6fbfca274..f82f85c65964 100644
> > > --- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > +++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > @@ -154,7 +154,7 @@
> > >  
> > >                         fm1mac3: ethernet@e4000 {
> > >                                 phy-handle = <&sgmii_aqr_phy3>;
> > > -                               phy-connection-type = "sgmii-2500";
> > > +                               phy-connection-type = "2500base-x";
> > >                                 sleep = <&rcpm 0x20000000>;
> > >                         };
> > >  
> > 
> > Acked-by: Scott Wood <oss@buserror.net>
> > 
> > -Scott
> 
> Hello! If there is not any objection, could you take this patch?

Hello! I would like to remind this patch.
