Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC346BD47
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbhLGONV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:13:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232979AbhLGONU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 09:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XJLMIZF/rhpchhkDaHehbpxMlR0BGIKndD60C61Fc54=; b=2U0sVlMC746/CgWFPj+Rp9Upc0
        I0PFNPEPnBnOvdydbJSWnQS09KteKOIMPGn3rVyYmlVlKCaK22ziFX5nLjBV5ymZx2JEwrX8OYWqw
        7egTLeD0GOzMVWovm78xy0gTLxKiWv9luH0mO5LV2juogDvJfqjxCmxfkIZlT7sGuOVo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mubAA-00FmMX-7K; Tue, 07 Dec 2021 15:09:46 +0100
Date:   Tue, 7 Dec 2021 15:09:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya9rKuAZTCzru9xz@lunn.ch>
References: <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5qSoNhJRiSif/U@lunn.ch>
 <20211206200111.3n4mtfz25fglhw4y@skbuf>
 <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
 <20211206202902.u4h6gn7epjysd7re@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206202902.u4h6gn7epjysd7re@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I can understand between MLO_AN_INBAND and MLO_AN_PHY, but isn't it
> reasonable that a "fixed" link is "fixed" and doesn't change?

Actually, it can. You can register a callback with
fixed_phy_set_link_update() and it gets called on each mdio read. It
is mainly there to change the link up/down status, but you can also
change the speed.

       Andrew
