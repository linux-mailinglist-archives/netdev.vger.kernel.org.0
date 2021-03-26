Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D5234A629
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 12:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCZLMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 07:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhCZLLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 07:11:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B8461A14;
        Fri, 26 Mar 2021 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616757107;
        bh=NAYb9wzcshAp093Q1uNmnTYBIeMwXVO4YXoXJ2IDPJg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jrczvv+QOc9Qm3VzC+WsI6t8zD3vRXbrgL+tMD9ViwXRH/srEICFjo5/icMqcQP47
         RDMKDjlSslTBhzZ0b+K2XMunYcxwj/+eDrcYzWnxd5zX9dI7quzMzg7zhNPyCdV/aj
         0n9yqQMERINAKmTc2k2T8qmW0Q485/3sI2hZyMJ/9XNsX2ua9hWtv57JE0svzYsXbw
         b5QXemcXgt0KCJjpA80bp8Ea1S5M6BR/9AAwZHbh7252uCWosbd5799sv4swJDwWdf
         aFxSWa5gOvM3KDoYN1+z04ilWYm3qr5YtTpk9fMkWushF051uvf+Di7hWguOKwXfJn
         L9VUlibYro70A==
Date:   Fri, 26 Mar 2021 12:11:41 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact
 model
Message-ID: <20210326121141.548cd153@thinkpad>
In-Reply-To: <20210326090734.GP1463@shell.armlinux.org.uk>
References: <20210325131250.15901-1-kabel@kernel.org>
        <20210325131250.15901-12-kabel@kernel.org>
        <20210325155452.GO1463@shell.armlinux.org.uk>
        <20210325212905.3d8f8b39@thinkpad>
        <418e86fb-dd7b-acbb-e648-1641f06b254b@gmail.com>
        <20210325215414.23fffe6c@thinkpad>
        <20210326090734.GP1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Mar 2021 09:07:34 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> > Nice, didn't know about that. But I fear whether this would always work
> > for the 88X3310 vs 88X3310P, it is possible that this feature is only
> > recognizable if the firmware in the PHY is already running.  
> 
> The ID registers aren't programmable and contain the proper IDs even if
> there isn't firmware loaded (I've had such a PHY here.)
> 

Yes, but the macsec feature bit is in register
MDIO_MMD_PMAPMD.MV_PMA_XGSTAT.12 (1.c001.12)

But it says "This bit is valid upon completion of reset (1.0.15 = 0)",
so it seems we can use this. :)

Marek
