Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81140221B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 04:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbhIGBtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 21:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhIGBtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 21:49:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A0E60F25;
        Tue,  7 Sep 2021 01:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630979319;
        bh=eqEJG5/ENLoZW3AJqEFY3G7B5mVdZ51pZaetNxTCIUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xv78zl0LMjJQzxLRF+74wAgCYwtfqC4oRzXriNpU833s55sAEf+Y+v5K/TCoPetb6
         r6F89hNbYdrkeXNuFceFAMJcplA5TQ6V2SrPBkot3hm0RzEpWRTAzbunXOVjWoOBa+
         85qjpasjB2DRyBFZTOOg1veH8bZZioWXju+i0CXucW9JibItGFY6Z2+4ycugn5Ir4n
         TVdhzfAMvr+M1opNA0/f9SB9V1/gOZ5lbZ/+FWI+7JFg+iczb+mrSK0vhPj1gHf04Y
         M4WUalbV9IYARH6N7BYwfDTFKNNX/DnD7NLn5DUfSDs1U3JgrcYFHukEADPx4pbg/H
         m3wd4j8BXY3Ig==
Date:   Mon, 6 Sep 2021 18:48:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, rafal@milecki.pl
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Message-ID: <20210906184838.2ebf3dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YTVlYqzeKckGfqu0@lunn.ch>
References: <20210905172328.26281-1-zajec5@gmail.com>
        <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
        <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
        <YTVlYqzeKckGfqu0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Sep 2021 02:48:34 +0200 Andrew Lunn wrote:
> > not allowing a proper review to happen. So please, I am begging you, wait at
> > least 12h, ideally 24h before applying a patch.  

The fixed wait time before applying would likely require more nuance.
For example something like 0h for build fixed; 12h if reviewed by all
area experts; 24h+ for the rest? Not counting weekends?

> 24 hours is too short. We all have lives outside of the kernel. I
> found the older policy of 3 days worked well. Enough time for those
> who had interest to do a review, but short enough to not really slow
> down development. And 3 days is still probably faster than any other
> subsystem.

It is deeply unsatisfying tho to be waiting for reviews 3 days, ping
people and then have to apply the patch anyway based on one's own
judgment. I personally dislike the uncertainty of silently waiting. 
I have floated the idea before, perhaps it's not taken seriously given
speed of patchwork development, but would it be okay to have a strict
time bound and then require people to mark patches in patchwork as 
"I'm planning to review this"?

Right now we make some attempts to delegate to "Needs ACK" state but
with mixed result (see the two patches hanging in that state now).

Perhaps the "Plan to review" marking in pw is also putting the cart
before the horse (quite likely, knowing my project management prowess.)
Either way if we're expending brain cycles on process changes it would
be cool to think more broadly than just "how long to set a timer for".
