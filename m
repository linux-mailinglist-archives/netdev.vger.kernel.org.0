Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7486B31B39E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 01:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhBOAja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 19:39:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhBOAj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 19:39:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lBRuQ-006M9V-Uo; Mon, 15 Feb 2021 01:38:38 +0100
Date:   Mon, 15 Feb 2021 01:38:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
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
Message-ID: <YCnCjomjF0LDglAg@lunn.ch>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
 <1612950500-9682-13-git-send-email-stefanc@marvell.com>
 <20210210.152924.767175240247395907.davem@davemloft.net>
 <CO6PR18MB3873D8B7BE3AE28A1407C05BB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YCU864+AH6UioNwQ@lunn.ch>
 <CAPv3WKd48fiZmdnP+NN_FRCT1h6xmu9zO4BWAz_pgTXW2fQt9w@mail.gmail.com>
 <YCaINEHqrz2QDGJb@lunn.ch>
 <CO6PR18MB3873E319FA08ADBC3B682828B0899@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO6PR18MB3873E319FA08ADBC3B682828B0899@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Does this even need to be configurable? What is the cost of turning it on?
> > How does having less pools affect the system? Does average latency go up?
> > When would i consider an underrun actually a good thing?
> > 
> > Maybe it should just be hard coded on? Or we should try to detect when
> > underruns are happening a lot, and dynamically turn it on for a while?
> > 
> The cost of this change is that the number of pools reduced from 16 to 8.
> The current driver uses only 4pools, but some future features like QoS can use over 4 pools. 

So you are saying, there is currently no cost for turning it on. So it
seems like you should just turn it on, and forget the module
parameter. When QoS features are added which require more than 8 pools
you can then address the issue of if this should be configurable.

    Andrew
