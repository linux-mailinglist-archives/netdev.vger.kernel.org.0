Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848CF39C141
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhFDUZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:25:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46084 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhFDUZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 16:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wFUuLPMMJj3qNSbkVVNapon0piflkSDe9pjhgJE42fE=; b=QE/wQttqD3F4kskWM6ozTEoSp7
        t6Yocy3D2jRhHmR09j+z25fiSrKyVtE+E2tHN8FnaNllJgWISEMmHCvaofDhzK6PgklKAQ4iuQc8S
        A6mlqzwvTQIGpeeoMI1nIQe4l9TvXFoXw0AfLqHei/CMjPUu2SCTlS6TT68AyFMMCI68=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpGM0-007qnJ-Vl; Fri, 04 Jun 2021 22:23:40 +0200
Date:   Fri, 4 Jun 2021 22:23:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <YLqLzOltcb6jan+B@lunn.ch>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The "sgmii-2500" compatible in that device tree describes an SGMII HW
> block, overclocked at 2.5G. Without that overclocking, it's a plain
> Cisco (like) SGMII HW block. That's the reason you need to disable it's
> AN setting when overclocked. With the proper Reset Configuration Word,
> you could remove the overclocking and transform that into a plain "sgmii".
> Thus, the dts compatible describes the HW, as it is.

It sounds like the hardware is capable of swapping between SGMII and
2500BaseX.

What we have in DT in this case is not describing the hardware, but
how we configure the hardware. It is one of the few places we abuse DT
for configuration.

    Andrew
