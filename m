Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7398DB4D9F
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 14:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfIQMQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 08:16:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbfIQMQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 08:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ADXk7BUTTbRa9A15VJSZOrJdf/FO/6k6e4fXv/Zd394=; b=3LIyXQdt7vEOFjx7ucERC09019
        EO8Kr/0BxsdtL08agtf5QrudntQQPUENr788r/8oHDc2PLMUZWbhY71iV7yOc+e1nXBfoO1el8ZQ2
        s0/TsOtUs/LF1E4Iiq77sN6vr51T6ZZVY3DdSLOvkekmol8fnyr7UEM1VLE+7nSbyaFk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iACOy-0000dm-9O; Tue, 17 Sep 2019 14:16:12 +0200
Date:   Tue, 17 Sep 2019 14:16:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: mdio: switch to using gpiod_get_optional()
Message-ID: <20190917121612.GC20778@lunn.ch>
References: <20190917000933.GA254663@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917000933.GA254663@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 05:09:33PM -0700, Dmitry Torokhov wrote:
> The MDIO device reset line is optional and now that gpiod_get_optional()
> returns proper value when GPIO support is compiled out, there is no
> reason to use fwnode_get_named_gpiod() that I plan to hide away.
> 
> Let's switch to using more standard gpiod_get_optional() and
> gpiod_set_consumer_name() to keep the nice "PHY reset" label.
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Hi Dmitry

What path into mainline do you expect this to take? Via DaveM?
net-next is closed now, so i guess you will need to repost in two
weeks time.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
