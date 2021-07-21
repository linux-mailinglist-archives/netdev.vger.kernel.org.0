Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963BC3D174E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhGUTJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:09:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231872AbhGUTJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 15:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RBz23aFqo1ODUik8Itgcy3DHXYO9jsXTpzjV7A0RdnE=; b=YO/XIy9qLOxeALj0P7DY9c8dYf
        ciaM43Lopp1Wyie1Q0uN2NA2EvsANxjFggY/Z/PkDLopBNG76/mdk+G7OnqItmwvGlIEJzwDL40As
        MpLMgc8GT2Uwm5bnC3uqqlqwuEmsnnleVGopk09t59PHjlvhTOTV/pLhdb5RTx8v1y3Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6IEJ-00EFKl-UB; Wed, 21 Jul 2021 21:50:07 +0200
Date:   Wed, 21 Jul 2021 21:50:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPh6b+dTZqQNX+Zk@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721204543.08e79fac@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Heiner,
> 
> in sysfs, all devices registered under LED class will have symlinks in
> /sys/class/leds. This is how device classes work in Linux.
> 
> There is a standardized format for LED device names, please look at
> Documentation/leds/leds-class.rst.
> 
> Basically the LED name is of the format
>   devicename:color:function

The interesting part here is, what does devicename mean, in this
context?

We cannot use the interface name, because it is not unique, and user
space can change it whenever it wants. So we probably need to build
something around the bus ID, e.g. pci_id. Which is not very friendly
:-(

	Andrew
