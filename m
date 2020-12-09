Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8137B2D4DFA
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388917AbgLIWez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:34:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388877AbgLIWev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:34:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn825-00B84D-J8; Wed, 09 Dec 2020 23:34:01 +0100
Date:   Wed, 9 Dec 2020 23:34:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20201209223401.GB2649111@lunn.ch>
References: <20201205164300.28581-1-mickeyr@marvell.com>
 <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
 <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201208105713.6c95830b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <BN6PR18MB158771FD8335348CB75D4D92BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
 <20201209162454.GD2602479@lunn.ch>
 <BN6PR18MB15873CD07E1B6BB1B6C21DE8BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR18MB15873CD07E1B6BB1B6C21DE8BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 09:38:52PM +0000, Mickey Rachamim wrote:
> Hi Andrew, 
> 
> > > You can see that only yesterday (Dec 8th) we had the first official 
> > > merge on this repo - this is the reason for the lack of commits.
> > > Marvell Switching group took strategic decision to open some aspects 
> > > of the Prestera family devices with the Open Source community and this 
> > > is the first step.
> > 
> > > As you realized - it will be used as a queue for all the features 
> > > targeted to be upstreamed.  New features are expected to be sent to 
> > > net-next very soon. (Like ACL/LAG/LLDP etc...)
> > 
> > Hi Mickey
> > 
> > I would actually expect this repo to hold a linux tree, probably based on net-next, and with a number of patches on top adding Prestera features, one by one.

Hi Mickey

Please get your mailer fixed. It seems to be re-wrapping other peoples
text, which is bad.

> A Buildroot based repo that includes specific platform patches will became public in the upcoming days. (As part of Marvell-Switching GitHub)

And please wrap your own text at around 65 characters. Standard
Netique RFC 1855 stuff.

> > 
> > Given your current structure, i don't see a direct path for this code into mainline.
> > 
> 
> Assuming the discussion is still on the 'W:' line;

Nope. I'm still talking about this repo of driver code. It is one
commit. Meaning you cannot do

git-format patch
git send-email --to=jakub --to=davem --cc=netdev *.patch

So you are basically going to have to re-write the code into a set of
patches. Which makes this repo pointless, in terms of kernel
development work. And that is what MAINTAINERS is all about.

	 Andrew
