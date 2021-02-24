Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E183247B2
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhBXX7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:59:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234118AbhBXX7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:59:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF43e-008JwM-DG; Thu, 25 Feb 2021 00:59:06 +0100
Date:   Thu, 25 Feb 2021 00:59:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 05/12] Documentation: networking: dsa:
 remove TODO about porting more vendor drivers
Message-ID: <YDboSmxASEw3ol2c@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-6-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 11:33:48PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> On one hand, the link is dead and therefore useless.
> 
> On the other hand, there are always more drivers to port, but at this
> stage, DSA does not need to affirm itself as the driver model to use for
> Ethernet-connected switches (since we already have 15 tagging protocols
> supported and probably more switch families from various vendors), so
> there is nothing actionable to do.

Yes, we have already taken over the universe :-)

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
