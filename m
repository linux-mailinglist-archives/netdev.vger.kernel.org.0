Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481761C0B25
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 02:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgEAAA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 20:00:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgEAAA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 20:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fu2VrGCUfvlkwTD2Wvwn6pD0dqyCACDQkJu5D58VsZc=; b=FkWvLGpytykAvSq4ItTFBn944z
        Yr4jsMXNm/sWvfMWckzuddHNYKGtVEyCyYjIQcXTJ+dopdsf1Ul15G+VGGfohgC/xkSDdTRgfniLo
        odC9E2JaXUQrFihBqEehhWaLvBt3phPdlhrBaCq4fuxzP4omjt1HO/vfs8fx0PAkoi5I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUJ6F-000U5v-Da; Fri, 01 May 2020 02:00:15 +0200
Date:   Fri, 1 May 2020 02:00:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200501000015.GC22077@lunn.ch>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430232052.9016-3-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 02:20:49AM +0300, Vadym Kochan wrote:
> Add PCI interface driver for Prestera Switch ASICs family devices, which
> provides:
> 
>     - Firmware loading mechanism
>     - Requests & events handling to/from the firmware
>     - Access to the firmware on the bus level
> 
> The firmware has to be loaded each time device is reset. The driver is
> loading it from:
> 
>     /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
> 
> The full firmware image version is located within internal header and
> consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> hard-coded minimum supported firmware version which it can work with:
> 
>     MAJOR - reflects the support on ABI level between driver and loaded
>             firmware, this number should be the same for driver and loaded
>             firmware.
> 
>     MINOR - this is the minimum supported version between driver and the
>             firmware.
> 
>     PATCH - indicates only fixes, firmware ABI is not changed.
> 
> Firmware image file name contains only MAJOR and MINOR numbers to make
> driver be compatible with any PATCH version.

Hi Vadym

What are the plans for getting the firmware into linux-firmware git
repo?

	Andrew
