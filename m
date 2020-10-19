Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6122930D1
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbgJSVzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:55:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387691AbgJSVzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:55:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUd7S-002YrA-5y; Mon, 19 Oct 2020 23:55:06 +0200
Date:   Mon, 19 Oct 2020 23:55:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201019215506.GY139700@lunn.ch>
References: <20201008162347.5290-1-dmurphy@ti.com>
 <20201008162347.5290-3-dmurphy@ti.com>
 <20201016220240.GM139700@lunn.ch>
 <31cbfec4-3f1c-d760-3035-2ff9ec43e4b7@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31cbfec4-3f1c-d760-3035-2ff9ec43e4b7@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 04:33:18PM -0500, Dan Murphy wrote:
> Andrew
> 
> On 10/16/20 5:02 PM, Andrew Lunn wrote:
> > On Thu, Oct 08, 2020 at 11:23:47AM -0500, Dan Murphy wrote:
> > > The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> > > that supports 10M single pair cable.
> > Hi Dan
> > 
> > I think you are going to have to add
> > ETHTOOL_LINK_MODE_10baseT1_Full_BIT? We already have 100T1 and 1000T1,
> > but not 10T1 :-(
> 
> The data sheet says 10baseT1L.  Which is not there either and seems to be
> the latest 802.3cg spec and has a greater max distance and used for IoT and
> Automotive.

Hi Dan

Do you know anything about interropibility? Can a T1 and a T1L talk to
each other, if suitably close? I'm wondering if this device should say
it is both T1 and T1L? Or just T1L?

   Andrew
