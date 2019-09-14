Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65DB2BD2
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfINPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:21:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46022 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfINPVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 11:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4aK0dFCDlLgl6CRfNKIdHBbX3HGXL2bVv2ovCUSUfeA=; b=SuPrt6GLaqkjjLrW/M74jRcoaW
        w2iMeSEn7cjMphAk6xH/WeA7/KjJXWWQm+rEBiAoxkxnqEUmrXiUQSKn0zU4GCl4DrufgYtexpY6I
        xAtQRHWVtFRC+Ow4gKl+Mwob81TDBv11BKZQ4GQeC1y7rOFjlQ6B5Ku40TGB/LwTfFU8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i99rj-00086b-FD; Sat, 14 Sep 2019 17:21:35 +0200
Date:   Sat, 14 Sep 2019 17:21:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mdio: switch to using gpiod_get_optional()
Message-ID: <20190914152135.GH27922@lunn.ch>
References: <20190913225547.GA106494@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913225547.GA106494@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 03:55:47PM -0700, Dmitry Torokhov wrote:
> The MDIO device reset line is optional and now that gpiod_get_optional()
> returns proper value when GPIO support is compiled out, there is no
> reason to use fwnode_get_named_gpiod() that I plan to hide away.
> 
> Let's switch to using more standard gpiod_get_optional() and
> gpiod_set_consumer_name() to keep the nice "PHY reset" label.
> 
> Also there is no reason to only try to fetch the reset GPIO when we have
> OF node, gpiolib can fetch GPIO data from firmwares as well.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
