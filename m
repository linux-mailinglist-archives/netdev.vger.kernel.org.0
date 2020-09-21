Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD75227330A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgIUTmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:42:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIUTmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 15:42:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKRhS-00FdlR-9I; Mon, 21 Sep 2020 21:42:10 +0200
Date:   Mon, 21 Sep 2020 21:42:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Message-ID: <20200921194210.GH3717417@lunn.ch>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
 <20200921171232.GF3717417@lunn.ch>
 <20200921181218.7jui54ca3lywj4c2@skbuf>
 <df33c443-6a4c-537d-5c06-8e984ab3e0c7@gmail.com>
 <20200921190327.GG3717417@lunn.ch>
 <20200921191008.urnhrb4iuk5hmzer@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921191008.urnhrb4iuk5hmzer@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:10:09PM +0000, Vladimir Oltean wrote:
> On Mon, Sep 21, 2020 at 09:03:27PM +0200, Andrew Lunn wrote:
> > Vladimir, could you implement the devlink DEVLINK_CMD_INFO_GET request
> > so we know what sort of device is exporting the regions, and hence
> > which pretty printers are relevant.
> 
> Should I do that in this series or separately?

Up to you. I added it as part of the regions patchset. I need to know
which particular device it is in order to decode the registers
correctly.

	Andrew
