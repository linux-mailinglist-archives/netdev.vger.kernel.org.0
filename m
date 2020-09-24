Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5131B277104
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgIXMab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 08:30:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgIXMab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 08:30:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLQOI-00G1Wh-Oo; Thu, 24 Sep 2020 14:30:26 +0200
Date:   Thu, 24 Sep 2020 14:30:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [net-next] net: dsa: felix: convert TAS link speed based on
 phylink speed
Message-ID: <20200924123026.GB3802929@lunn.ch>
References: <20200922104302.17662-1-xiaoliang.yang_1@nxp.com>
 <20200922113644.h5vyxmdtg2dickpg@skbuf>
 <DB8PR04MB578529D733A50F048A1EB793F0390@DB8PR04MB5785.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB578529D733A50F048A1EB793F0390@DB8PR04MB5785.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I modify the commit and resend this patch to "net tree", please reject this one.

Hi Xiaoliang Yang

You dropped "PATCH" from the subject. Please also include a version
number, so it is possible to identify which is the last version:

[PATCH net v2] net: dsa: felix: convert TAS link speed based on phylink speed

https://www.kernel.org/doc/html/latest/process/submitting-patches.html
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

It is a good idea to spend a few minutes every day just reading
patches and review comments to get an idea how the process works.

	Andrew

