Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E4B2E8164
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 18:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgLaRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 12:14:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgLaRO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 12:14:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kv1W6-00FHGF-Uw; Thu, 31 Dec 2020 18:13:38 +0100
Date:   Thu, 31 Dec 2020 18:13:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X+4GwpFnJ0Asq/Yj@lunn.ch>
References: <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
 <X+3ume1+wz8HXHEf@lunn.ch>
 <20201231170039.zkoa6mij3q3gt7c6@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231170039.zkoa6mij3q3gt7c6@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Looking at sfp_module_info(), adding a check for i2c_block_size < 2
> > when determining what length to return. ethtool should do the right
> > thing, know that the second page has not been returned to user space.
> 
> But if we limit length of eeprom then userspace would not be able to
> access those TX_DISABLE, LOS and other bits from byte 110 at address A2.

Have you tested these bits to see if they actually work? If they don't
work...

	 Andrew
