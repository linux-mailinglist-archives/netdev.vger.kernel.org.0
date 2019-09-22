Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07A8BA2F0
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbfIVPDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 11:03:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53876 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbfIVPDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 11:03:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so7095882wmd.3
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 08:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3t76lrl4vuSZVNf9HAuejgZ4matOW8rVpIbhx53udu0=;
        b=CpwjW+k03RWJjiB3GZ2k07dsX3/Znw2wiUbRkA+9HJkJcF0I7if1HXwdyZC/PgD4SA
         sCVz3Yl1NX1tB7EJ25xg+eycf42qCGFx0EJH2CLIVY3qc29L/Bc8aP5MAp/gY79grZ4+
         4DoHLzkEt5ghBJLEjUBrioGMgnf3xvB0CkR0olo/KQ9Hc1V3rEzrDeJUNquTk9cPFuhF
         lzFiSHrtsPydTrOhsPmb+Be0zavkv7vjUAHS4UUfzGjK1rgsYZZS3MtGzkfLnwxeaZmL
         7X/M+FO8xVOycxbZU01f5db2BR2niRJMhcX0gWNZ5+PjOdnPNPL88Koom9b0EJUa/OWI
         nNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3t76lrl4vuSZVNf9HAuejgZ4matOW8rVpIbhx53udu0=;
        b=DTwwIQdLGpZQiQKnwKB6Ka+ru5qO0YDY+uRksU4fMNWUVcUK0+tCEvek0gaVyGG4Ea
         iSzUje9iw31UsVLcr3srZlnMEVecoBRaVfkufERtFOY16DU/P7nhRuV5P3GNx1FuLObq
         jgp3GDMFaxuMYgYbyYcj9GJoQhW1VMs1/5hiK3ppLWwwED/52aVvlmkIadVc8JhN2nJZ
         acQhisrw3NwB5SUDLk+voDTnHJPoVhd+CVIfGQtoj/GtA638Co38d+JM50Y0kFvx3+hC
         ciZihh6wxA/XEjrKXg4F8W+EiGIsmIBWftXTBidU7kWtfJAoEZ+NOWqKjZgSkCNm1EaE
         hdIg==
X-Gm-Message-State: APjAAAX2+vQMvDJLb7wveW7kttF7piaffMkDllcP2lfvrQkI7dKc0p4Q
        e7jcKv6X75z8EFhbuD7pBT0=
X-Google-Smtp-Source: APXvYqxkQFCHXDQLwTOokVHMx1gsWoT25YldeT1UpwQINVvhmQrqCgL5cw1M8kcVKLOaUgJWzplUQg==
X-Received: by 2002:a1c:c189:: with SMTP id r131mr10916048wmf.153.1569164588592;
        Sun, 22 Sep 2019 08:03:08 -0700 (PDT)
Received: from arch-dsk-01 ([77.126.41.65])
        by smtp.gmail.com with ESMTPSA id o9sm15243366wrh.46.2019.09.22.08.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 08:03:07 -0700 (PDT)
Date:   Sun, 22 Sep 2019 18:03:03 +0300
From:   tinywrkb <tinywrkb@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to fix regression with AR8035 speed downgrade
Message-ID: <20190922150303.GA593284@arch-dsk-01>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 11:59:32AM +0100, Russell King - ARM Linux admin wrote:
> Hi,
> 
> tinywrkb, please can you test this series to ensure that it fixes
> your problem - the previous version has turned out to be a non-starter
> as it introduces more problems, thanks!

Yes, this solves my issue.
Tested against v5.3.
Thanks Russell and everyone else who helped.
> 
> The following series attempts to address an issue spotted by tinywrkb
> with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
> the negotiated link.
> 
> Before commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in
> genphy_read_status"), we would read not only the link partner's
> advertisement, but also our own advertisement from the PHY registers,
> and use both to derive the PHYs current link mode.  This works when the
> AR8035 downgrades the speed, because it appears that the AR8035 clears
> link mode bits in the advertisement registers as part of the downgrade.
> 
> Commentary: what is not yet known is whether the AR8035 restores the
>             advertisement register when the link goes down to the
> 	    previous state.
> 
> However, since the above referenced commit, we no longer use the PHYs
> advertisement registers, instead converting the link partner's
> advertisement to the ethtool link mode array, and combine that with
> phylib's cached version of our advertisement - which is not updated on
> speed downgrade.
> 
> This results in phylib disagreeing with the actual operating mode of
> the PHY.
> 
> Commentary: I wonder how many more PHY drivers are broken by this
> 	    commit, but have yet to be discovered.
> 
> The obvious way to address this would be to disable the downgrade
> feature, and indeed this does fix the problem in tinywrkb's case - his
> link partner instead downgrades the speed by reducing its
> advertisement, resulting in phylib correctly evaluating a slower speed.
> 
> However, it has a serious drawback - the gigabit control register (MII
> register 9) appears to become read only.  It seems the only way to
> update the register is to re-enable the downgrade feature, reset the
> PHY, changing register 9, disable the downgrade feature, and reset the
> PHY again.
> 
> This series attempts to address the problem using a different approach,
> similar to the approach taken with Marvell PHYs.  The AR8031, AR8033
> and AR8035 have a PHY-Specific Status register which reports the
> actual operating mode of the PHY - both speed and duplex.  This
> register correctly reports the operating mode irrespective of whether
> autoneg is enabled or not.  We use this register to fill in phylib's
> speed and duplex parameters.
> 
> In detail:
> 
> Patch 1 fixes a bug where writing to register 9 does not update
> phylib's advertisement mask in the same way that writing register 4
> does; this looks like an omission from when gigabit PHY support came
> into being.
> 
> Patch 2 seperates the generic phylib code which reads the link partners
> advertisement from the PHY, so that we can re-use this in the Atheros
> PHY driver.
> 
> Patch 3 seperates the generic phylib pause mode; phylib provides no
> help for MAC drivers to ascertain the negotiated pause mode, it merely
> copies the link partner's pause mode bits into its own variables.
> 
> Commentary: Both the aforementioned Atheros PHYs and Marvell PHYs
>             provide the resolved pause modes in terms of whether 
> 	    we should transmit pause frames, or whether we should
> 	    allow reception of pause frames.  Surely the resolution
> 	    of this should be in phylib?
> 
> Patch 4 provides the Atheros PHY driver with a private "read_status"
> implementation that fills in phylib's speed and duplex settings
> depending on the PHY-Specific status register.  This ensures that
> phylib and the MAC driver match the operating mode that the PHY has
> decided to use.  Since the register also gives us MDIX status, we
> can trivially fill that status in as well.
> 
> Note that, although the bits mentioned in this patch for this register
> match those in th Marvell PHY driver, and it is located at the same
> address, the meaning of other register bits varies between the PHYs.
> Therefore, I do not feel that it would be appropriate to make this some
> kind of generic function.
> 
>  drivers/net/phy/at803x.c     | 69 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy-core.c   | 20 ++++++++-----
>  drivers/net/phy/phy.c        |  5 ++++
>  drivers/net/phy/phy_device.c | 65 +++++++++++++++++++++++++----------------
>  include/linux/mii.h          |  9 ++++++
>  include/linux/phy.h          |  2 ++
>  6 files changed, 138 insertions(+), 32 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
