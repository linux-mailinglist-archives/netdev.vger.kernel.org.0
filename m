Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22A02F899D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbhAOXrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbhAOXrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435BF23A5E;
        Fri, 15 Jan 2021 23:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610754383;
        bh=7m1nWwY+wYqnp3OTmsDmOvk9MHLoE5z7hKTXp8avnbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JFeBMMxlLCNncsRukd61I0++AXox9PSGkv2E63Nm9Ul0JaGYyYNlFAztYcaFzW7jv
         rubv0tGNlQeuYkU85RzxdQhhwV6eFmAvuwhK6dZnQWRQScp3T9s+iUP52loWv/haYN
         3H6xnxQLihkzdos3uuZHHNyI7itkcldzebM5eWhk1QA/GUxz2DdQxuKXcassJsdi6G
         /f988M8y7+dSqGbLprPAlomX8D+/nxGNzsUvCu0Dn9CFYO7fKsfY+YEUJaRsJXPi8M
         wN5NMPfuTt9yC4q2CTC+62gp3RpiOWL8XURbSyeS8d8hY9DrcNCqPjY+CdD+r+/z+k
         jWu+CDf7I/QNw==
Date:   Fri, 15 Jan 2021 15:46:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
Message-ID: <20210115154622.1db7557d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115232435.gqeify2w35ddvsyi@skbuf>
References: <20210115125259.22542-1-tobias@waldekranz.com>
        <20210115150246.550ae169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210115232435.gqeify2w35ddvsyi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 01:24:35 +0200 Vladimir Oltean wrote:
> On Fri, Jan 15, 2021 at 03:02:46PM -0800, Jakub Kicinski wrote:
> > On Fri, 15 Jan 2021 13:52:57 +0100 Tobias Waldekranz wrote:  
> > > The kernel test robot kindly pointed out that Global 2 support in
> > > mv88e6xxx is optional.
> > > 
> > > This also made me realize that we should verify that the hardware
> > > actually supports LAG offloading before trying to configure it.
> > > 
> > > v1 -> v2:
> > > - Do not allocate LAG ID mappings on unsupported hardware (Vladimir).
> > > - Simplify _has_lag predicate (Vladimir).  
> > 
> > If I'm reading the discussion on v1 right there will be a v3,
> > LMK if I got it wrong.  
> 
> I don't think a v3 was supposed to be coming, what made you think that?

I thought you concluded that the entire CONFIG_NET_DSA_MV88E6XXX_GLOBAL2
should go, you said:

> So, roughly, you save 10%/13k. That hardly justifies the complexity IMO.
