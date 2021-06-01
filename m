Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B6397B99
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhFAVOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:14:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234707AbhFAVOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 17:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=NAhVX2ck7e8JB+uQ9aQ64FUD/MtD6xRH2zvpBl31heM=; b=rn
        I7GnVUG4YN0d9uHz+g+yop24V8tGoHApQ1Mj+pFeOGw8c4Dd7z8wjGJJfqIYDr3WQYtaXTUTkw6rZ
        kU2Xs2Wb+YqoZD47lKm5YpClaP77ngtzs7kDruyyFXNgShhUaohj1M1KaVbgStmrbONUFFOrlmX/5
        QENB/psaXKC8BTw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loBh3-007La2-1v; Tue, 01 Jun 2021 23:12:57 +0200
Date:   Tue, 1 Jun 2021 23:12:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v2 06/10] leds: core: inform trigger that it's
 deactivation is due to LED removal
Message-ID: <YLai2aHKKKqwRysm@lunn.ch>
References: <20210601005155.27997-1-kabel@kernel.org>
 <20210601005155.27997-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210601005155.27997-7-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 02:51:51AM +0200, Marek Behún wrote:
> Move setting of the LED_UNREGISTERING before deactivating the trigger in
> led_classdev_unregister().
> 
> It can be useful for a LED trigger to know whether it is being
> deactivated due to the LED being unregistered. This makes it possible
> for LED drivers which implement trigger offloading to leave the LED in
> HW triggering mode when the LED is unregistered, instead of disabling
> it.

Humm, i'm not sure that is a good idea. I don't expect my Ethernet
switch to keep forwarding frames when i unload the driver.

       Andrew
