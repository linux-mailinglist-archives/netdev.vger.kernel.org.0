Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26032D46B2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgLIQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:25:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46776 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731314AbgLIQZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:25:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn2Gs-00B5QQ-TT; Wed, 09 Dec 2020 17:24:54 +0100
Date:   Wed, 9 Dec 2020 17:24:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20201209162454.GD2602479@lunn.ch>
References: <20201205164300.28581-1-mickeyr@marvell.com>
 <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
 <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201208105713.6c95830b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <BN6PR18MB158771FD8335348CB75D4D92BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR18MB158771FD8335348CB75D4D92BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You can see that only yesterday (Dec 8th) we had the first official
> merge on this repo - this is the reason for the lack of commits.
> Marvell Switching group took strategic decision to open some aspects
> of the Prestera family devices with the Open Source community and
> this is the first step.

> As you realized - it will be used as a queue for all the features
> targeted to be upstreamed.  New features are expected to be sent to
> net-next very soon. (Like ACL/LAG/LLDP etc...)

Hi Mickey

I would actually expect this repo to hold a linux tree, probably based
on net-next, and with a number of patches on top adding Prestera
features, one by one.

Given your current structure, i don't see a direct path for this code
into mainline.

	Andrew

