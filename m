Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0292930BA
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387427AbgJSVpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:45:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgJSVpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:45:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUcyG-002YnK-Go; Mon, 19 Oct 2020 23:45:36 +0200
Date:   Mon, 19 Oct 2020 23:45:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019214536.GX139700@lunn.ch>
References: <20201019204913.467287-1-robert.hancock@calian.com>
 <20201019210852.GW1551@shell.armlinux.org.uk>
 <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have a local patch that just falls back to trying 1000BaseX mode
> if the driver reports SGMII isn't supported and it seems like it
> might be a copper module, but that is a bit of a hack that may need
> to be handled differently.

Do you also modify what the PHY is advertising to remove the modes
your cannot support?

     Andrew
