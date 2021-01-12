Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3D2F3248
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbhALNzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:55:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbhALNza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:55:30 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzK8B-000AKu-1G; Tue, 12 Jan 2021 14:54:43 +0100
Date:   Tue, 12 Jan 2021 14:54:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: Re: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <X/2qI78PnWrpbWwP@lunn.ch>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
 <OSAPR01MB3844F3CE410F7BB24BAA54B6DFAA0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB3844F3CE410F7BB24BAA54B6DFAA0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 05:14:21AM +0000, ashiduka@fujitsu.com wrote:
> > For T1, it seems like Master is pretty important. Do you have
> > information to be able to return the current Master/slave
> > configuration, or allow it to be configured? See the nxp-tja11xx.c
> > for an example.
> 
> I think it's possible to return a Master/Slave configuration.

Great. It would be good to add it.

> By the way, do you need the cable test function as implemented in
> nxp-tja11xx.c?

We don't need it. But if you want to implement it, that would be
great.

	Andrew
