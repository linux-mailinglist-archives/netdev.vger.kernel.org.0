Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4C0401243
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 02:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbhIFAtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 20:49:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhIFAtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 20:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qLrmmfc0xQ1mgQ8BvgSUjkMQRO4Mfs9sULadbcSMW94=; b=MS+ckRUW/v+0WMaui3mYeYeHp/
        zTSQ0Up7ESYIRPGmRMku/rzfQ1jHvENpm8ifzWNO2Cdt1u1+nnTfwmWaH+E8y0grsCB4y1ii7LrTM
        bitC+PiYZLFHogs2nuAOgxdAu8hguPRd9rsNtzXiT3U97ndX6sgzlNr04wW/3MBwNmpw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mN2oM-005RZZ-Mi; Mon, 06 Sep 2021 02:48:34 +0200
Date:   Mon, 6 Sep 2021 02:48:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, rafal@milecki.pl
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Message-ID: <YTVlYqzeKckGfqu0@lunn.ch>
References: <20210905172328.26281-1-zajec5@gmail.com>
 <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
 <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> not allowing a proper review to happen. So please, I am begging you, wait at
> least 12h, ideally 24h before applying a patch.

24 hours is too short. We all have lives outside of the kernel. I
found the older policy of 3 days worked well. Enough time for those
who had interest to do a review, but short enough to not really slow
down development. And 3 days is still probably faster than any other
subsystem.

     Andrew
