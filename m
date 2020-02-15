Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64116008D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgBOVLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:11:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33065 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgBOVLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:11:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so15146318wrt.0
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 13:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5vwUbzXVDUO1+2pLmQhMssk12GGJIySv54o3WT3OUV0=;
        b=DKLJ1EEj6kpIjx9NYdm4VxpzzWPfh/5bsd+R8NGcUsWWp5yNfyj1TXkq2yew9ilGN/
         +f9WzpPmQXRyhpwqlin7lhKIj6yNRPMxCCLU1Mp2m9rXo8qho99UP6VXM3mBiHt2GOt7
         cN2e3U1VFacJoD68rxbrk8U8FhkgT6DtVjROhL6sIBy/3pdQxDgAqs1G+X/teNGaTtDV
         NUABWj3ZYXTqWnEcubErSr+cZn8KGQNIt+pThv+E1El3RxIp3bHa/CnSgUfxMYONR/QJ
         kugJz1y1bY5rbzVKWTnPnjVIwl9Bho6TiHBvTk9IP78q0yC7/xgzuCtk2FGzWCw0kGDa
         T/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5vwUbzXVDUO1+2pLmQhMssk12GGJIySv54o3WT3OUV0=;
        b=HTgq5uXC/eewj+CMVnXLCoJ3LamzCF051QAHEmYxNJr3CaWOTKza98c87vnRhzJmQr
         nuInNQj8KetfINxz6xPdMOZnBS6gNdZTBqm1NCAENX8ymBr3zniQadlRQ52r4lYgJ25g
         5a5YlF7X9n1weVCZEDyyfeFKysACN/5NDEUyhJ05/zQeYU2HNhjR47527LwXDHM1P219
         5oZvJK2fCoAbfH8BiutpWAu/XHM2MOdEicaI6fTC3958H2DL+j8/O+LQTXMIVIjGPyoT
         RCEmaa+klHEmQ31LQOhAKW5XyHOT7ezMZOXaPL6fpCo8qLUEIrUICMaPFW77sZlDFiOO
         DQEQ==
X-Gm-Message-State: APjAAAXi042MKSzTEaoIL+UG5m3tnW3Ruwqvu8+VQ3n/jprwff7/+gIk
        IhKN1D0cd1EZCi2SMdb25kO3C4dp
X-Google-Smtp-Source: APXvYqzmSqaoWLJguz+IQZWRDsXvgf710HEQEU8pRANG5Kcl2inLu0g/9oX/UDldL0lKsdLfFdzDRw==
X-Received: by 2002:adf:f64b:: with SMTP id x11mr11366213wrp.355.1581801080041;
        Sat, 15 Feb 2020 13:11:20 -0800 (PST)
Received: from [10.230.28.123] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g128sm12984728wme.47.2020.02.15.13.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 13:11:19 -0800 (PST)
Subject: Re: [PATCH net-next 00/10] Pause updates for phylib and phylink
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <db876d85-94d3-9295-a21f-d338c1be3b36@gmail.com>
Date:   Sat, 15 Feb 2020 13:11:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/2020 7:48 AM, Russell King - ARM Linux admin wrote:
> Currently, phylib resolves the speed and duplex settings, which MAC
> drivers use directly. phylib also extracts the "Pause" and "AsymPause"
> bits from the link partner's advertisement, and stores them in struct
> phy_device's pause and asym_pause members with no further processing.
> It is left up to each MAC driver to implement decoding for this
> information.
> 
> phylink converted drivers are able to take advantage of code therein
> which resolves the pause advertisements for the MAC driver, but this
> does nothing for unconverted drivers. It also does not allow us to
> make use of hardware-resolved pause states offered by several PHYs.
> 
> This series aims to address this by:
> 
> 1. Providing a generic implementation, linkmode_resolve_pause(), that
>    takes the ethtool linkmode arrays for the link partner and local
>    advertisements, decoding the result to whether pause frames should
>    be allowed to be transmitted or received and acted upon.  I call
>    this the pause enablement state.
> 
> 2. Providing a phylib implementation, phy_get_pause(), which allows
>    MAC drivers to request the pause enablement state from phylib.
> 
> 3. Providing a generic linkmode_set_pause() for setting the pause
>    advertisement according to the ethtool tx/rx flags - note that this
>    design has some shortcomings, see the comments in the kerneldoc for
>    this function.
> 
> 4. Remove the ability in phylink to set the pause states for fixed
>    links, which brings them into line with how we deal with the speed
>    and duplex parameters; we can reintroduce this later if anyone
>    requires it.  This could be a userspace-visible change.
> 
> 5. Split application of manual pause enablement state from phylink's
>    resolution of the same to allow use of phylib's new phy_get_pause()
>    interface by phylink, and make that switch.
> 
> 6. Resolve the fixed-link pause enablement state using the generic
>    linkmode_resolve_pause() helper introduced earlier. This, in
>    connection with the previous commits, allows us to kill the
>    MLO_PAUSE_SYM and MLO_PAUSE_ASYM flags.
> 
> 7. make phylink's ethtool pause setting implementation update the
>    pause advertisement in the same way that phylib does, with the
>    same caveats that are present there (as mentioned above w.r.t
>    linkmode_set_pause()).
> 
> 8. create a more accurate initial configuration for MACs, used when
>    phy_start() is called or a SFP is detected. In particular, this
>    ensures that the pause bits seen by MAC drivers in state->pause
>    are accurate for SGMII.
> 
> 9. finally, update the kerneldoc descriptions for mac_config() for
>    the above changes.
> 
> This series has been build-tested against net-next; the boot tested
> patches are in my "phy" branch against v5.5 plus the queued phylink
> changes that were merged for 5.6.
> 
> The next series will introduce the ability for phylib drivers to
> provide hardware resolved pause enablement state.  These patches can
> be found in my "phy" branch.

I do not think that patch #1 made it to the mailing-list though, so if
nothing else you may want to resend it:

http://patchwork.ozlabs.org/project/netdev/list/?series=158739

> 
>  drivers/net/phy/Makefile     |   3 +-
>  drivers/net/phy/linkmode.c   |  95 +++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c |  43 +++++++-----
>  drivers/net/phy/phylink.c    | 162 +++++++++++++++++++++++++++----------------
>  include/linux/linkmode.h     |   8 ++-
>  include/linux/phy.h          |   3 +
>  include/linux/phylink.h      |  34 +++++----
>  7 files changed, 258 insertions(+), 90 deletions(-)
>  create mode 100644 drivers/net/phy/linkmode.c
> 

-- 
Florian
