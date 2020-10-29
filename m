Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E8C29EC52
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJ2Myn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:54:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ2Myn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 08:54:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY7Rv-0049os-FL; Thu, 29 Oct 2020 13:54:39 +0100
Date:   Thu, 29 Oct 2020 13:54:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201029125439.GK933237@lunn.ch>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-2-kabel@kernel.org>
 <20201029124141.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029124141.GR1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It would be good to pass this through checkpatch - I notice some lines
> seem to be over the 80 character limit now.

Hi Russell

The limit got raised to something higher. I personally prefer 80, and
if a file is using 80, new code would be inconsistent with old code if
it did not use 80. So your request is reasonable anyway.

   Andrew
