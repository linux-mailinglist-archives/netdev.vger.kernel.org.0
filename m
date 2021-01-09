Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293C22F0103
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 16:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbhAIPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 10:55:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbhAIPzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 10:55:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyGZK-00H7jv-Vb; Sat, 09 Jan 2021 16:54:22 +0100
Date:   Sat, 9 Jan 2021 16:54:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if
 both LOS normal and inverted is set
Message-ID: <X/nRrgR12bETcMEO@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-3-pali@kernel.org>
 <X/c8xJcwj8Y1t3u4@lunn.ch>
 <20210109154601.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210109154601.GZ1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 03:46:01PM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Jan 07, 2021 at 05:54:28PM +0100, Andrew Lunn wrote:
> > On Wed, Jan 06, 2021 at 04:37:48PM +0100, Pali Rohár wrote:
> > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > 
> > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > 
> > > Such combination of bits is meaningless so assume that LOS signal is not
> > > implemented.
> > > 
> > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> I'd like to send this patch irrespective of discussion on the other
> patches - I already have it committed in my repository with a different
> description, but the patch content is the same.
> 
> Are you happy if I transfer Andrew's r-b tag

Hi Russell

If it is the same contest, no problem. I can always NACK it later...

   Andrew
