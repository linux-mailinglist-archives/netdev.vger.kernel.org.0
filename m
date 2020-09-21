Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E0C27325B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgIUTDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:03:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUTDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 15:03:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKR5z-00FdS8-VW; Mon, 21 Sep 2020 21:03:27 +0200
Date:   Mon, 21 Sep 2020 21:03:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Message-ID: <20200921190327.GG3717417@lunn.ch>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
 <20200921171232.GF3717417@lunn.ch>
 <20200921181218.7jui54ca3lywj4c2@skbuf>
 <df33c443-6a4c-537d-5c06-8e984ab3e0c7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df33c443-6a4c-537d-5c06-8e984ab3e0c7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 11:44:41AM -0700, Florian Fainelli wrote:
> On 9/21/20 11:12 AM, Vladimir Oltean wrote:
> > On Mon, Sep 21, 2020 at 07:12:32PM +0200, Andrew Lunn wrote:
> >> On Mon, Sep 21, 2020 at 07:27:39PM +0300, Vladimir Oltean wrote:
> >>> This series exposes the SJA1105 static config as a devlink region. This
> >>> can be used for debugging, for example with the sja1105_dump user space
> >>> program that I have derived from Andrew Lunn's mv88e6xxx_dump:
> >>>
> >>> https://github.com/vladimiroltean/mv88e6xxx_dump/tree/sja1105
> >>
> >> Maybe i should rename the project dsa_dump?
> > 
> > I was unsure if you want to maintain that as a larger project.
> > 
> 
> Cannot this be part of ethtool or iproute2 at some point and we just
> have each driver author submit pretty printers for the registers?

It would be iproute2, since that is where devlink lives and where most
of the code comes from. I did take some code from ethtool which Vivien
wrote for the port registers.

The code needs refactoring anyway, i was not thinking about others
using it, and there is code in mv88e6xxx_dump which should be shared.

Vladimir, could you implement the devlink DEVLINK_CMD_INFO_GET request
so we know what sort of device is exporting the regions, and hence
which pretty printers are relevant.

   Andrew
