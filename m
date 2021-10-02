Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841C841FA8A
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 11:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhJBJIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 05:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhJBJIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 05:08:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF39261B06;
        Sat,  2 Oct 2021 09:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633165592;
        bh=T8waKCrPkYnEX9h6g7UvY1gmwClk6YShtPvOohfqWi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JKM19fsyS85GrbKCYw1lQg6XE0tO+ljh6K8MfcxxtCqtRPnm4hgtT5Pf4V9c3MM6u
         vOypUn0o5KdCerjdLJOxPNmWXTtb/jzZ0AP9OHSQy0Jo7Ph7sGs4RayOMD5PXHrEv3
         TxKbNu3IAZ+X0KqullA25VVnt0VJSosB6A5rJNAcPIqewAA4NgALxh9TbklIu0+AAS
         u/IkeE7JW8EmIKMYLey0oWMulE3jVCMzK/bWB0Kp+7GQggboJNBsblaC/CJ593vDNb
         kOYFVbOaZv7UFd+Yt4LQ8RlMj9ZvNRm9clL0tPwAqPjmkCYAs5KiBnOgr6VWiEsCFK
         Q9vt74njWwzVw==
Received: by pali.im (Postfix)
        id 86EEE1087; Sat,  2 Oct 2021 11:06:30 +0200 (CEST)
Date:   Sat, 2 Oct 2021 11:06:30 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Scott Wood <oss@buserror.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Message-ID: <20211002090630.h6er5vhln5psw3yd@pali>
References: <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210704134325.24842-1-pali@kernel.org>
 <63a72f648297e96c140a1412c20bd3796398a932.camel@buserror.net>
 <20210827113836.hvqvaln65gexg5ps@pali>
 <20210928213918.v4n3bzecbiltbktd@pali>
 <YVR3PVa9C6w5A1ce@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVR3PVa9C6w5A1ce@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 29 September 2021 16:25:01 Andrew Lunn wrote:
> On Tue, Sep 28, 2021 at 11:39:18PM +0200, Pali Rohár wrote:
> > On Friday 27 August 2021 13:38:36 Pali Rohár wrote:
> > > On Wednesday 14 July 2021 12:11:49 Scott Wood wrote:
> > > > On Sun, 2021-07-04 at 15:43 +0200, Pali Rohár wrote:
> > > > > Property phy-connection-type contains invalid value "sgmii-2500" per scheme
> > > > > defined in file ethernet-controller.yaml.
> > > > > 
> > > > > Correct phy-connection-type value should be "2500base-x".
> > > > > 
> > > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > > Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the
> > > > > board device tree(s)")
> > > > > ---
> > > > >  arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > > b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > > index 5ba6fbfca274..f82f85c65964 100644
> > > > > --- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > > +++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > > > > @@ -154,7 +154,7 @@
> > > > >  
> > > > >                         fm1mac3: ethernet@e4000 {
> > > > >                                 phy-handle = <&sgmii_aqr_phy3>;
> > > > > -                               phy-connection-type = "sgmii-2500";
> > > > > +                               phy-connection-type = "2500base-x";
> > > > >                                 sleep = <&rcpm 0x20000000>;
> > > > >                         };
> > > > >  
> > > > 
> > > > Acked-by: Scott Wood <oss@buserror.net>
> > > > 
> > > > -Scott
> > > 
> > > Hello! If there is not any objection, could you take this patch?
> > 
> > Hello! I would like to remind this patch.
> 
> Hi Pali
> 
> I suggest you resend, and with To: Michael Ellerman <mpe@ellerman.id.au>
> to make it clear who you expect to pick up the
> patch. Michael seems to do the Maintainer work in
> arch/powerpc/boot/dts/
> 
> 	Andrew

Done: https://lore.kernel.org/lkml/20211002090409.3833-1-pali@kernel.org/T/#u
