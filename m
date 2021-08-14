Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7CE3EC456
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbhHNSFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:05:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238785AbhHNSFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 14:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VE21kR+EuEDNxIJsfgnVJoyX8+amKCpRdo0kK4BLWmQ=; b=E/n34eVaiz/c6PN4sSDKcRZ+WF
        k6G7fP0wWvVetyteNcjd4RTCACETw6XRYHHMsIi9e4hMg2RSxxyj1OlD4B6Hhxojt6wHqel+W2yHJ
        y2pvzxTYESLHzuUzo5wRB3OiMX2w3P84f4cKzinStHiRteFJYzQ0KboJnrdb5HdsI6/E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEy1f-0005it-Qr; Sat, 14 Aug 2021 20:04:55 +0200
Date:   Sat, 14 Aug 2021 20:04:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <YRgFxzIB3v8wS4tF@lunn.ch>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814172656.GA22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> How does this work if the driver has no interrupt support? What is
> the hardware setup this has been tested with?

Hi Russell

We already know from previous patches that the Intel hardware is
broken, and does not actually deliver the interrupt which caused the
wake up. So i assume this just continues on with the same broken
hardware, but they have a different PHY connected.

> What if we later want to add interrupt support to this driver to
> support detecting changes in link state - isn't using this bit
> in the interrupt enable register going to confict with that?

Agreed. If the interrupt register is being used, i think we need this
patchset to add proper interrupt support. Can you recommend a board
they can buy off the shelf with the interrupt wired up? Or maybe Intel
can find a hardware engineer to add a patch wire to link the interrupt
output to a SoC pin that can do interrupts.

	  Andrew
