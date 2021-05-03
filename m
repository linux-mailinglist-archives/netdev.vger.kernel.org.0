Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6DC37151B
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 14:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhECMPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 08:15:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50796 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhECMPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 08:15:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ldXSt-002Hrd-A5; Mon, 03 May 2021 14:14:19 +0200
Date:   Mon, 3 May 2021 14:14:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Rob Herring <robh@kernel.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <YI/pG3GSIpse+OEo@lunn.ch>
References: <20210430182941.915101-1-clabbe@baylibre.com>
 <20210430215325.GA3957879@robh.at.kernel.org>
 <YI+WPRAAbtmP9LC0@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YI+WPRAAbtmP9LC0@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > What's the order with 3 lines? In any case, define the order with 
> > schema:
> > 
> > minItems:
> > items:
> >   - description: MDC signal
> >   - description: MDIO or ?? signal
> >   - description: ?? signal
> > 
> 
> I dont know what to write in the third line, I added the "maxItems: 3" by request of Andrew Lunn.
> But I have no example at hand.
> 
> Andrew could you give me an example of:	"You often find with x86 machines you don't have GPIOs, just GPI
> and GPO, and you need to combine two to form the MDIO line of the MDIO bus."
> Or could I drop the "maxItems: 3" until a board need it.

The code gets the GPIOs via index. The index are defined in
include/linux/gpio-mdio.h as:

#define MDIO_GPIO_MDC	0
#define MDIO_GPIO_MDIO	1
#define MDIO_GPIO_MDO	2

So you can describe them MDC, MDIO, MDO.

   Andrew
