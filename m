Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF231A022
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 14:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhBLNxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 08:53:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhBLNxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 08:53:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAYsO-005py6-6x; Fri, 12 Feb 2021 14:52:52 +0100
Date:   Fri, 12 Feb 2021 14:52:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v12 net-next 12/15] net: mvpp2: add BM
 protection underrun feature support
Message-ID: <YCaINEHqrz2QDGJb@lunn.ch>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
 <1612950500-9682-13-git-send-email-stefanc@marvell.com>
 <20210210.152924.767175240247395907.davem@davemloft.net>
 <CO6PR18MB3873D8B7BE3AE28A1407C05BB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YCU864+AH6UioNwQ@lunn.ch>
 <CAPv3WKd48fiZmdnP+NN_FRCT1h6xmu9zO4BWAz_pgTXW2fQt9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKd48fiZmdnP+NN_FRCT1h6xmu9zO4BWAz_pgTXW2fQt9w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Or we have also found out, that pushing back on parameters like this,
> > the developers goes back and looks at the code, and sometimes figures
> > out a way to automatically do the right thing, removing the
> > configuration knob, and just making it all simpler for the user to
> > use.
> 
> I think of 2 alternatives:
> * `ethtool --set-priv-flags` - in such case there is a question if
> switching this particular feature in runtime is a good idea.
> * New DT/ACPI property - it is a hardware feature after all, so maybe
> let the user decide whether to enable it on the platform description
> level.

Does this even need to be configurable? What is the cost of turning it
on? How does having less pools affect the system? Does average latency
go up?  When would i consider an underrun actually a good thing?

Maybe it should just be hard coded on? Or we should try to detect when
underruns are happening a lot, and dynamically turn it on for a while?

	  Andrew
