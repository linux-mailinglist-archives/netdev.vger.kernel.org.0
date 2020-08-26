Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0D252F21
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgHZM7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:59:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbgHZM7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 08:59:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAv11-00BwUQ-35; Wed, 26 Aug 2020 14:58:59 +0200
Date:   Wed, 26 Aug 2020 14:58:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Daniel Gorsulowski <daniel.gorsulowski@esd.eu>,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: dp83869: Fix RGMII internal delay configuration
Message-ID: <20200826125859.GQ2403519@lunn.ch>
References: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
 <20200825133750.GQ2588906@lunn.ch>
 <b2c665e7-9566-6767-6ee3-39219a1bd4a3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2c665e7-9566-6767-6ee3-39219a1bd4a3@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 02:57:35PM -0500, Dan Murphy wrote:
> Andrew
> 
> On 8/25/20 8:37 AM, Andrew Lunn wrote:
> > On Tue, Aug 25, 2020 at 02:07:21PM +0200, Daniel Gorsulowski wrote:
> > > The RGMII control register at 0x32 indicates the states for the bits
> > > RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:
> > > 
> > >    RGMII Transmit/Receive Clock Delay
> > >      0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
> > >      0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.
> > > 
> > > This commit fixes the inversed behavior of these bits
> > > 
> > > Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
> > I Daniel
> > 
> > I would like to see some sort of response from Dan Murphy about this.
> 
> Daniel had sent this privately to me and I encouraged him to send it in for
> review.
> 
> Unfortunately he did not cc me on the patch he sent to the list.

You should be able to reply to this email with a Reviewed-by: and
patchwork will do the right thing.

	  Andrew
