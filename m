Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98ADA5BB5F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfGAMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:20:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42683 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfGAMUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:20:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so13586051wrl.9;
        Mon, 01 Jul 2019 05:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wDK+VGNLOh5xPyZh6wAjqtdgmRlRlNiDvHJYuCNXtQI=;
        b=DGmE2t0LmdkCDNwjx/jVMYLqQGB9FcnDRaBOVKqAZX077VZuX92c5e0iTPy4Cr3aTo
         pwvh9lcYW3jrw0dt0eKg/BGzryj9CRirOXTPyAeqZ+TQOSCmBThRSAMKcV6VTgyn7Qnm
         uFF7SzS6zmvNJO5larxrkPcaco+TjJuykfzz7clS5iJPYQ/pXGoTD6khn2OgTtKsNJ7x
         IIUBxIW/AQ8vczIQJTZuSIG5DqY4SUIfGFBHxgQ4tZKym4HGnBJr9gc4TKQwmM3O0Llv
         2pMJUDam/OLPrXrG5fRt9c4w4+qEktF4LUyVNLXeyfCeZ01ZVyjyM/oUOdR6g4KTSXxG
         qh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wDK+VGNLOh5xPyZh6wAjqtdgmRlRlNiDvHJYuCNXtQI=;
        b=rwMSWYtIvtxcWk7BqAo0Obz3zEMGtoY3ptavyTWlEWRVLX+p26/wTv9/yC7fBQ+J13
         SQZ/8V6gG5EwpQuKWHwKAk34kfeNsd7CvWDrPKI8mvqTLQF3KI+flcD9t41u9Sddbv7x
         Dvbktxh6dbxpOCcBydF/unh2oGv1f5kNIQqp6u3zLzSe168g2uoTVcydCu27NANSKFGY
         s/GLKlwxWpS3z8ngwK+oh35+00hoaOaqKaApkt7SJ1JO/24ab60mbPdUfBNosuq3HX/I
         9jHEMltSk8rtlGXhfd2BKxbODckJeFLKntvFDv3pngAPsQKQ0+NLmMaEoUgU+zKit17w
         qtQQ==
X-Gm-Message-State: APjAAAXvuzJGuhqxSSucNqt00Q1TxOlv57+2+iXP69dcxBCnyGRh3Lx4
        tXS7KMAjK8lMW7ybNxfmVrcZQWm3
X-Google-Smtp-Source: APXvYqyQ7atvdEI+wUbwck5kAALCn2WuV1fSHPqK0zpVspqgBezpseLvGFdydiRzCtyK24pLPQ7xBA==
X-Received: by 2002:adf:ab0f:: with SMTP id q15mr3238025wrc.325.1561983652973;
        Mon, 01 Jul 2019 05:20:52 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h19sm19567752wrb.81.2019.07.01.05.20.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 05:20:52 -0700 (PDT)
Date:   Mon, 1 Jul 2019 14:20:50 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     jacmet@sunsite.dk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net: dm9600: false link status
Message-ID: <20190701122050.GA11021@Red>
References: <20190627132137.GB29016@Red>
 <20190627144339.GG31189@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627144339.GG31189@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 04:43:39PM +0200, Andrew Lunn wrote:
> On Thu, Jun 27, 2019 at 03:21:37PM +0200, Corentin Labbe wrote:
> > Hello
> > 
> > I own an USB dongle which is a "Davicom DM96xx USB 10/100 Ethernet".
> > According to the CHIP_ID, it is a DM9620.
> > 
> > Since I needed for bringing network to uboot for a board, I have started to create its uboot's driver.
> > My uboot driver is based on the dm9600 Linux driver.
> > 
> > The dongle was working but very very slowy (24Kib/s).
> > After some debug i found that the main problem was that it always link to 10Mbit/s Half-duplex. (according to the MAC registers)
> > 
> > For checking the status of the dongle I have plugged it on a Linux box which give me:
> > dm9601 6-2:1.0 enp0s29f0u2: link up, 100Mbps, full-duplex, lpa 0xFFFF
> > 
> > But in fact the Linux driver is tricked.
> > 
> > I have added debug of MDIO write/read and got:
> > [157550.926974] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x00, val=0x8000
> 
> Writing the reset bit. Ideally you should read back the register and
> wait for this bit to clear. Try adding this, and see if this helps, or
> you get 0xffff.
> 

I get 0xFFFF

> > [157550.931962] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x04, val=0x05e1
> 
> Advertisement control register.  
> 
> > [157550.951967] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_read() phy_id=0x00, loc=0x00, returns=0xffff
> 
> And now things are bad. In theory, the power down bit is set, and some
> PHYs don't respond properly when powered down. However, it is unclear
> how it got into this state. Did the reset kill it, or setting the
> advertisement? Or is the PHY simply not responding at all. The MDIO
> data lines have a pull up, so if the device does not respond, reads
> give 0xffff.
> 
> Maybe also check register 0, bit 7, EXT_PHY. Is it 0, indicating the
> internal PHY should be used?
> 
> You could also try reading PHY registers 2 and 3 and see if you can
> get a valid looking PHY ID. Maybe try that before hitting the reset
> bit?
> 

Always get 0xFFFF before and after

Note that the eeprom dump via ethtool -e suffer the same problem.

> > So it exsists two problem:
> > - Linux saying 100Mbps, full-duplex even if it is false.
> 
> The driver is using the old mii code, not a phy driver. So i cannot
> help too much with linux. But if you can get the MDIO bus working
> reliably, it should be possible to move this over to phylib. The
> internal PHY appears to have all the standard registers, so the
> generic PHY driver has a good chance of working.
> 

I have investigated more and in fact I dont have a dm9620.
I own another diferent dongle in my stock that i never used and fun fact, it has the same VID/PID and the same bug.
I opened both dongle and all chips have no marking and got only 4x8 pins.
Since dm9620 have 64 pins, my dongles are clearly not such hw.

I googled the inscription written on the second case and found a dm9620 clone/counterfeiting named qf9700/sr9700.
But thoses chips should have marking (according to some photos on the web), so I probably own a counterfeiting of a clone/counterfeiting.

Note that the sr9700 driver is mainline but fail to work with my dongle.

At least, now i know that have a chip not designed to work with an external PHY, so all EXTPHY registers could be ignored.
My last ressort is to brute force all values until something happen.

My simple tries, write 0xsomeval everywhere, lead to something, phy/eeprom return now 0x000y.
Probably, this chip doesnt have any PHY...

Regards
