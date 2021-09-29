Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDF441C695
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344199AbhI2O1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:27:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344142AbhI2O1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=wWgC/vb5YXjwhIt78LP76qUd1D9uEqQMomeZ/ZahLfI=; b=z3
        2N5e2h9d+oLtxvNTlpRGTUqVEVA3mvBQwslVgQBq224GDnhyuTVQLl0Atcl9TdwobqCefXFuTMFgS
        zZv4dqGlFpXqjIuuio1X5jpchuB9nLn65HmL6xZw8/TMVuFz/vwSjLhpX96q92hRxJtRteSiTqM3f
        XAacB/cW7Yp3tvM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVaW5-008mdg-Lp; Wed, 29 Sep 2021 16:25:01 +0200
Date:   Wed, 29 Sep 2021 16:25:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Scott Wood <oss@buserror.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Message-ID: <YVR3PVa9C6w5A1ce@lunn.ch>
References: <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210704134325.24842-1-pali@kernel.org>
 <63a72f648297e96c140a1412c20bd3796398a932.camel@buserror.net>
 <20210827113836.hvqvaln65gexg5ps@pali>
 <20210928213918.v4n3bzecbiltbktd@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210928213918.v4n3bzecbiltbktd@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 11:39:18PM +0200, Pali Rohár wrote:
> On Friday 27 August 2021 13:38:36 Pali Rohár wrote:
> > On Wednesday 14 July 2021 12:11:49 Scott Wood wrote:
> > > On Sun, 2021-07-04 at 15:43 +0200, Pali Rohár wrote:
> > > > Property phy-connection-type contains invalid value "sgmii-2500" per scheme
> > > > defined in file ethernet-controller.yaml.
> > > > 
> > > > Correct phy-connection-type value should be "2500base-x".
> > > > 
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the
> > > > board device tree(s)")
> > > > ---
> > > >  arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > index 5ba6fbfca274..f82f85c65964 100644
> > > > --- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > +++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > @@ -154,7 +154,7 @@
> > > >  
> > > >                         fm1mac3: ethernet@e4000 {
> > > >                                 phy-handle = <&sgmii_aqr_phy3>;
> > > > -                               phy-connection-type = "sgmii-2500";
> > > > +                               phy-connection-type = "2500base-x";
> > > >                                 sleep = <&rcpm 0x20000000>;
> > > >                         };
> > > >  
> > > 
> > > Acked-by: Scott Wood <oss@buserror.net>
> > > 
> > > -Scott
> > 
> > Hello! If there is not any objection, could you take this patch?
> 
> Hello! I would like to remind this patch.

Hi Pali

I suggest you resend, and with To: Michael Ellerman <mpe@ellerman.id.au>
to make it clear who you expect to pick up the
patch. Michael seems to do the Maintainer work in
arch/powerpc/boot/dts/

	Andrew
