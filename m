Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B92F328A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbhALODc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:03:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389287AbhALODb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 09:03:31 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzKG1-000ARX-Ui; Tue, 12 Jan 2021 15:02:49 +0100
Date:   Tue, 12 Jan 2021 15:02:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <X/2sCciKK9kVwnog@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'd think that mdio-i2c.c is for generic code. When adding a
> vendor-specific protocol, wouldn't it make sense to use a dedicated
> source file for it?

Hi Heiner

There is no standardised way to access MDIO over i2c. So the existing
code is vendor code, even if it is used by a few different vendors.

     Andrew
