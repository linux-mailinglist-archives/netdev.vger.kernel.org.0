Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F452CDA5E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgLCPtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:49:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgLCPtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:49:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkqqn-00A3lT-GQ; Thu, 03 Dec 2020 16:48:57 +0100
Date:   Thu, 3 Dec 2020 16:48:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: Re: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20201203154857.GQ2324545@lunn.ch>
References: <20201203100436.25630-1-mickeyr@marvell.com>
 <20201203143530.GH2333853@lunn.ch>
 <MWHPR18MB15980930483CA2F0BB657E95BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR18MB15980930483CA2F0BB657E95BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 03:44:22PM +0000, Mickey Rachamim wrote:
> On Thu, Dec 03, 2020 at 04:36:00PM +0200, Andrew Lunn wrote:
> >> Add maintainers info for new Marvell Prestera Ethernet switch driver.
> >> 
> >> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> >> ---
> >>  MAINTAINERS | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> 
> > Hi Mickey
> > 
> > All the commits came from
> > 
> > Vadym Kochan <vadym.kochan@plvision.eu>
> > 
> > Has Marvell purchased PL Vision?
> > 
> >     Andrew
> 
> Hi Andrew, 
> 
> No, Marvell didn't purchase PLVision and I can understand the reason for thinking it.
> PLVision and Marvell teams are keep working together as partners on supporting this program.
> Vadym Kochan is and will remain an important contributor on this program.

So Vadym Kochan is still at PLVision? Please use PLVision email
addresses for people at PLVision, and Marvell email addresses for
people at Marvell. We don't want Marketing in the MAINTAINER file.

      Andrew
