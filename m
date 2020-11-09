Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6AD2AC5EC
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgKIU0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:26:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgKIU0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 15:26:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcDjj-00699l-ND; Mon, 09 Nov 2020 21:25:59 +0100
Date:   Mon, 9 Nov 2020 21:25:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
Message-ID: <20201109202559.GF1456319@lunn.ch>
References: <20201109193117.2017-1-TheSven73@gmail.com>
 <20201109194934.GE1456319@lunn.ch>
 <CAGngYiVV1_65tZRgnzSxDV5mQGAkur8HwTOer9eDMXhBLvBCXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiVV1_65tZRgnzSxDV5mQGAkur8HwTOer9eDMXhBLvBCXw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 02:56:38PM -0500, Sven Van Asbroeck wrote:
> On Mon, Nov 9, 2020 at 2:49 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Did you check to see if there is a help to set just the mode without
> > changing any of the other bits?
> 
> Absolutely, but it doesn't exist, AFAIK.

> It would be great if client spi drivers would use a helper function like
> that.

Then you should consider adding it, and cross post the SPI list.

     Andrew
