Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3354E3F9881
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245029AbhH0Lj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235295AbhH0Lj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 07:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E7260FC4;
        Fri, 27 Aug 2021 11:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630064319;
        bh=ve29pPm/8F7On55yD7S+uc8qqP4GUkW7r7zweAeVCYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmC6lwxwMu9u5MXbRtjwnmrcNHDejWMZXLntKFAveiAZ3klLnXuoN6/WRsr8dskmL
         TCQ4+r7rA+WJ4jKiDOFuLTP5T7vVj9PrBcWITQiHh7OIzxZiki5mh837jH2/y4PIHH
         X/o3ua2AqZE5z3rBHk2EDHoXKCL9XrNRGRQIqkRvpbgSTtvlSQwHwSHmb8lu7yO0nt
         TMKsk4TlUce1qzH8rorHZtFt6ePReYWKDJ/0eP2u0w6TG3RBjj31Cp136NT4PF8P/f
         RDlrgZHJ3Tr8dGvJ8XlwOz2ktQY/kZtGX2BOIHMqnbKwIIWikGopD3V2faOtMiEXAy
         1OPZEKvKZayNQ==
Received: by pali.im (Postfix)
        id A24A0617; Fri, 27 Aug 2021 13:38:36 +0200 (CEST)
Date:   Fri, 27 Aug 2021 13:38:36 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Scott Wood <oss@buserror.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Message-ID: <20210827113836.hvqvaln65gexg5ps@pali>
References: <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210704134325.24842-1-pali@kernel.org>
 <63a72f648297e96c140a1412c20bd3796398a932.camel@buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63a72f648297e96c140a1412c20bd3796398a932.camel@buserror.net>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 14 July 2021 12:11:49 Scott Wood wrote:
> On Sun, 2021-07-04 at 15:43 +0200, Pali Rohár wrote:
> > Property phy-connection-type contains invalid value "sgmii-2500" per scheme
> > defined in file ethernet-controller.yaml.
> > 
> > Correct phy-connection-type value should be "2500base-x".
> > 
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the
> > board device tree(s)")
> > ---
> >  arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > index 5ba6fbfca274..f82f85c65964 100644
> > --- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > +++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > @@ -154,7 +154,7 @@
> >  
> >                         fm1mac3: ethernet@e4000 {
> >                                 phy-handle = <&sgmii_aqr_phy3>;
> > -                               phy-connection-type = "sgmii-2500";
> > +                               phy-connection-type = "2500base-x";
> >                                 sleep = <&rcpm 0x20000000>;
> >                         };
> >  
> 
> Acked-by: Scott Wood <oss@buserror.net>
> 
> -Scott

Hello! If there is not any objection, could you take this patch?
