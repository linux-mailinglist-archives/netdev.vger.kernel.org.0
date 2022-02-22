Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3412D4BF42E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiBVI5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiBVI5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:57:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D5812AFD;
        Tue, 22 Feb 2022 00:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xGEsn6HNXntcb29Co/VYHo96/tg4kb3qe6IpkM6Z7HM=; b=w11BX5lfQ/3A1VzJHr6YOMrlWR
        MR+I+IZyPal61hFgiIOJ6TSX6b+PvJnD6fpe44UASNoErT6ZkNJpGoKoATzC5AinGDz75+6E7wQB3
        qaBpeX3kHEj2A4o+vo3wgeBCy5Yw99Un+O3/2TJ+KHAg1lfLWuNQIC2rH0QA2JmuYApU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMQyl-007ZHB-9C; Tue, 22 Feb 2022 09:57:03 +0100
Date:   Tue, 22 Feb 2022 09:57:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhSlX01mEpFiRZQR@lunn.ch>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <YhQHqDJvahgriDZK@lunn.ch>
 <CAHp75VeHiTo6B=Ppz9Yc6OiC7nb5DViDt_bGifj6Jr=g89zf8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeHiTo6B=Ppz9Yc6OiC7nb5DViDt_bGifj6Jr=g89zf8Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In the DT world, we avoid snow flakes. Once you define a binding, it
> > is expected every following board will use it. So what i believe you
> > are doing here is defining how i2c muxes are described in APCI.
> 
> Linux kernel has already established description of I2C muxes in ACPI:
> https://www.kernel.org/doc/html/latest/firmware-guide/acpi/i2c-muxes.html
> 
> I'm not sure we want another one.

Agreed. This implementation needs to make use of that. Thanks for
pointing it out. I don't know the ACPI world, are there any other
overlaps with existing ACPI bindings?

	Andrew
