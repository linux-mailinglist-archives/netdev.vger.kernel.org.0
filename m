Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891A048AE7C
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbiAKNem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:34:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239562AbiAKNel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 08:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mYE06D53hAPKwiitC0FFWhp9uSadto0ku0+zLX7Kh0I=; b=YHHyVPLprJjBuUTr1VyVMvsY5g
        jpKogW1ywDs1aN+ephiG7yZ5kaxR3To5PWW8vI2CtA4OB9QegyBHueYZDleuVTDzDCrxYpw71AKqA
        jQ00KoTT5e7/5UUGpKXH1TyAP/T3yBPpbOiAujqy9Jt1cAarIQ97mx/A8BbxaZyRyV78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7HI3-0015oP-39; Tue, 11 Jan 2022 14:34:19 +0100
Date:   Tue, 11 Jan 2022 14:34:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <Yd2HW2U2GDgqAkM9@lunn.ch>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Martin,
> > 
> > I've got some boards with the GPY111 phy on them and I'm finding that
> > modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
> > do a soft reset (BCMR_RESET) first. I don't see anything in the
> > datasheet which specifies this to be the case so I'm interested it
> > what you have found. Are you sure adjusting the skews like this
> > without a soft (or hard pin based) reset actually works?
> > 
> > Best regards,
> > 
> > Tim
> 
> Hello Tim,
> 
> yes, you are right. It is not applied immediately. The link needs to be
> toggled to get this settings active. But my experience shows that this
> would be done in the further boot process anyway e.g. by restarting the
> autonegotiation etc.

Hi Martin

Have you verified this? Maybe try NFS root, so the kernel is the one
up'ing the interface, before user space exists.

       Andrew
