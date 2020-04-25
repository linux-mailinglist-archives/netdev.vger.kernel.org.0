Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE711B85A5
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 12:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgDYK1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 06:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726059AbgDYK1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 06:27:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6ECC09B04A;
        Sat, 25 Apr 2020 03:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CX7og9o/DP0eXhwe1eH7yLZwMHTSD5OqeJYL9Ai/6Lg=; b=nVcWYfLOm1LQYL9PkwARcplFw
        +DT2LuuiMjDIfjW15VFylk4+lUzKgXJh0rSvlsPfkimUw0bzCaIl1tfymkCZJv77xk4EMF7h+3ubO
        q/TnD/nZUO5Ixm7HNsO8UdF+qoDPoDEBA2UBKsDYk/AdqSoatT+Uhzdw/DQ9aEajv53BjE9FvcFxg
        TPutzsG2/AfZ6nrTHm+W8AhINUN6+OzYJoM9xFBPfdFJRYtAj/zCK+DZfrtiTssm0+g+yqzOUz3vP
        KblXVLZXd6871GXD45XckNROixXd9JmvVmhcY1dg6yKPfExAXmD4zMAqozHx00BgxIiKIodeWjwW6
        gXQ7ejjkw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43512)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jSI1g-00022u-7B; Sat, 25 Apr 2020 11:27:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jSI1f-0004Ws-85; Sat, 25 Apr 2020 11:27:11 +0100
Date:   Sat, 25 Apr 2020 11:27:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/9] dt-bindings: net: add backplane dt
 bindings
Message-ID: <20200425102711.GW25745@shell.armlinux.org.uk>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-3-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-3-git-send-email-florinel.iordache@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:46:24PM +0300, Florinel Iordache wrote:
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index ac471b6..541cee5 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -93,8 +93,9 @@ properties:
>        - rxaui
>        - xaui
>  
> -      # 10GBASE-KR, XFI, SFI
> +      # 10GBASE-KR, 40GBASE-KR4, XFI, SFI
>        - 10gbase-kr
> +      - 40gbase-kr4
>        - usxgmii

This makes a nonsense of the comment (and is actually something I failed
to update with the 10GBASE-R change).

The comment "10GBASE-KR, XFI, SFI" was there to describe _only_ the
following option, so your addition should look like:

	# 10GBASE-KR, XFI, SFI
	- 10gbase-kr
	# 40GBASE-KR4
	- 40gbase-kr4

Whereas there should also be a fix for the lack of 10GBASE-R, so it
should finally look like this:

	# 10GBASE-R, XFI, SFI
	- 10gbase-r
	# 10GBASE-KR (10GBASE-R with backplane negotiation)
	- 10gbase-kr
	# 40GBASE-KR4 (...)
	- 40gbase-kr4

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
