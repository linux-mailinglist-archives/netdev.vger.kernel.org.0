Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2D3D7ADC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhG0QX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:23:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhG0QX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 12:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aZPQZCjNHnkjq1tXm/Dt2IzN3OSkfbUlv2pdm/yi/6g=; b=DT3o9N2zBO5eRyMnSh9xuoh9mt
        Jc3muAqxcqRlftsG05rJ7JrdRnhRSflHK6gyplkkX7dYvfFXBycYIOiNCJnxD2kKkSK+lOhEwFXJG
        74YiwkQUrgDde3fVIIiuby/ymWmQ/cltYqCjAVAx2duBJl2SAvb4sL2XLSTccp+n33MA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8Prt-00F2Ra-4v; Tue, 27 Jul 2021 18:23:45 +0200
Date:   Tue, 27 Jul 2021 18:23:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YQAzEXDGDC2EYxiq@lunn.ch>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8edcc387025a6212d58fe01865725734@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But I was actually referring to your "you see the leds in /sys/ of all
> the network adapters". That problem still persists, right?

It is not really a problem. You see all the PHYs in /sys. You see all
the PCI devices in /sys. Because these all have globally unique names,
it is not a problem.

What is not globally unique is interface names. Those are only unique
to a network name space. And /sys/class/net is network name space
aware. It only contains the interfaces in the current network name
space.

	Andrew
