Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C382930DB
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgJSV7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:59:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387732AbgJSV7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:59:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUdBw-002Yt7-JV; Mon, 19 Oct 2020 23:59:44 +0200
Date:   Mon, 19 Oct 2020 23:59:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019215944.GZ139700@lunn.ch>
References: <20201019204913.467287-1-robert.hancock@calian.com>
 <20201019210023.GU139700@lunn.ch>
 <e9214e305158b9b487862f89b7a88dd292beb824.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9214e305158b9b487862f89b7a88dd292beb824.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I suppose that part would be pretty harmless, as you would likely want
> that behavior whenever that if condition was triggered. So
> m88e1111_finisar_config_init could likely be merged into
> m88e1111_config_init.

I think so as well.

> Mainly what stopped me from making all of these changes generic to all
> 88E1111 is that I'm a bit less confident in the different config_aneg
> behavior, it might be more specific to this SFP copper module case? 

Well, for 1000BaseX, i don't think we currently have an SFP devices
using it, since phylink does not support it. So it is a question are
there any none-SFP m88e1111 out there you might break?

      Andrew
