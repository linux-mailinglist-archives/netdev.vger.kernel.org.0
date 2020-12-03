Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FD02CDCEA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbgLCR7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgLCR7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 12:59:43 -0500
Date:   Thu, 3 Dec 2020 09:59:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607018342;
        bh=FPvTvD3cL4CDHEl6Y+d0PIl/T0Qfyv3J4Z7TnhfQ1k4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=VoogDckLTuRRo/Yi9g02mSBdTF6gth9RN8HaBnxp9Y2PGalXK2eA0AFpctnGNX3/K
         m6sjZO4ojFORwqm0gtN3RUrPvrHVRItwplCP00WbRaKCBlR+BW06hxtBhh0HS81zUn
         i7JeaBRVrObB9+RdIO9PRrqLjHVLOPr6t3fCiEa/FPL9ArKGTOynFt6mAzKHyKQWJy
         AqPISdyhyhck+XxyeJzErvyafxJeZcc39rK657KSQE4TuqF1Q+G66qp6fL7O1ZBuv7
         pW60a6Hv304BvV+rVMuJrfyDH/Cr3xbhzW2KP2utarxda9lU/I+xn7gCdcuuPOeZdm
         Ou6dXRtiQmiXw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: Re: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20201203095900.1ae8b745@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203154857.GQ2324545@lunn.ch>
References: <20201203100436.25630-1-mickeyr@marvell.com>
        <20201203143530.GH2333853@lunn.ch>
        <MWHPR18MB15980930483CA2F0BB657E95BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
        <20201203154857.GQ2324545@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 16:48:57 +0100 Andrew Lunn wrote:
> On Thu, Dec 03, 2020 at 03:44:22PM +0000, Mickey Rachamim wrote:
> > On Thu, Dec 03, 2020 at 04:36:00PM +0200, Andrew Lunn wrote:  
> > >> Add maintainers info for new Marvell Prestera Ethernet switch driver.
> > >> 
> > >> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> > >> ---
> > >>  MAINTAINERS | 9 +++++++++
> > >>  1 file changed, 9 insertions(+)  
> >   
> > > Hi Mickey
> > > 
> > > All the commits came from
> > > 
> > > Vadym Kochan <vadym.kochan@plvision.eu>
> > > 
> > > Has Marvell purchased PL Vision?
> > > 
> > >     Andrew  
> > 
> > Hi Andrew, 
> > 
> > No, Marvell didn't purchase PLVision and I can understand the reason for thinking it.
> > PLVision and Marvell teams are keep working together as partners on supporting this program.
> > Vadym Kochan is and will remain an important contributor on this program.  
> 
> So Vadym Kochan is still at PLVision? Please use PLVision email
> addresses for people at PLVision, and Marvell email addresses for
> people at Marvell. We don't want Marketing in the MAINTAINER file.

100%. 

And Vadym is the only person that should be listed there as far as 
I'm concerned. I'm intending to purge MAINTAINERS from all people 
who haven't reviewed patches in the last 3 or so years, so let's 
save ourselves the back and forth.

I'd suggest you create your own mailing list and add it under 
the L: entry, that way all managers and people within company 
who want to keep an eye on upstream can subscribe.

IMO MAINTAINERS is for listing code reviewers.
