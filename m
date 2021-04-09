Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA8D35A74A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhDITod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:44:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234142AbhDIToc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:44:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUx3B-00Fr40-GU; Fri, 09 Apr 2021 21:44:17 +0200
Date:   Fri, 9 Apr 2021 21:44:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mark Brown <broonie@kernel.org>
Cc:     Sander Vanheule <sander@svanheule.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com
Subject: Re: [RFC PATCH 1/2] regmap: add miim bus support
Message-ID: <YHCukeU8idIciNq9@lunn.ch>
References: <8af840c5565343334954979948cadf7576b23916.camel@svanheule.net>
 <20210409181642.GG4436@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409181642.GG4436@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 07:16:42PM +0100, Mark Brown wrote:
> On Fri, Apr 09, 2021 at 08:14:22PM +0200, Sander Vanheule wrote:
> 
> > The kernel has the mii_bus struct to describe the bus master, but like
> > you noted the bus is generaly refered to as an MDIO interface. I'm fine
> > with naming it MDIO to make it easier to spot.
> 
> Either mii_bus or mdio seem like an improvement - something matching
> existing kernel terminology, I guess mdio is consistent with the API it
> works with so...

I would also suggest mdio. The mii_bus code is an old framework which
does not see any work done to it.

     Andrew

