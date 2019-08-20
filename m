Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB595BFD
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfHTKHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:07:07 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54111 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfHTKHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:07:07 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id DFC8C240008;
        Tue, 20 Aug 2019 10:07:04 +0000 (UTC)
Date:   Tue, 20 Aug 2019 12:07:04 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190820100704.GC3292@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190816132500.GA8697@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190816132500.GA8697@bistromath.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sabrina,

On Fri, Aug 16, 2019 at 03:25:00PM +0200, Sabrina Dubroca wrote:
> 2019-08-13, 10:58:17 +0200, Antoine Tenart wrote:
> > 
> > As for the need for xmit / handle_frame ops (for a MAC w/ MACsec
> > offloading), I'd say the xmit / handle_frame ops of the real net device
> > driver could be used as the one of the MACsec virtual interface do not
> > do much (regardless of the implementation choice discussed above).
> 
> There's no "handle_frame" op on a real device. macsec_handle_frame is
> an rx_handler specificity that grabs packets from a real device and
> sends them into a virtual device stacked on top of it. A real device
> just hands packets over to the stack via NAPI.

Right, so if there is a need for a custom implementation of xmit /
hamdle_frame we could let the offloading driver provide it. I'll
probably let the first MAC implementation add it, as we agreed not to
add an API with no user (and mine is done in the PHY).

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
