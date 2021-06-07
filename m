Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389AC39DC0C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhFGMRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:17:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhFGMRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 08:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PvUCPI59T8MNKYSVJ0l6BLjhUdZg7ZN5P9rHrdvpfWo=; b=4Mo5fcTGlq6pKWlfHg3WUoLPNB
        VEyOjDZPz2OP5BJb8H0HkVj1zW3yDVKn7IfQS6Dd5OMVbyoiAE01t80R+qIOKBiZl9BitUuR4S+ZZ
        5cb6zsA680ZbS35ZOu0sT0qQm3PS4wHsCZFtgu+qBY0V0faWMqiu5VaQbLKLG1oqtguA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqEAX-008AjM-GG; Mon, 07 Jun 2021 14:15:49 +0200
Date:   Mon, 7 Jun 2021 14:15:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YL4N9XMFKOrRdH4l@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <YLoZWho/5a60wqPu@lunn.ch>
 <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
 <YLqPnpNXbd6o019o@lunn.ch>
 <f965ae22-c5a8-ec52-322f-33ae04b76404@maxlinear.com>
 <YLuMDyg2IIpalOIo@lunn.ch>
 <f329dca8-9962-0b43-eaa7-cbed838d5dc0@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f329dca8-9962-0b43-eaa7-cbed838d5dc0@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, they all have same product number.
> 
> They are one IP.

O.K, this is the sort of information which is useful to have in the
commit message. Basically anything which is odd about your PHY it is
good to mention, because reviewers are probably going to notice and
ask.

> The difference is feature set it's enabled by fusing in silicon.
> 
> For example, GPY115 has 10/100/1000Mbps support, so in the ability 
> register 2.5G capable is 0.
> 
> GPY211 has 10/100/1000/2500Mbps support, so in the capability register 
> 2.5G capable is 1.
 
I assume it is more than just the capability register? Linux could
easily ignore that and make use of 2.5G if it still actually works.

       Andrew
