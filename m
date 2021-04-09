Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676EE35A724
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhDIT3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234783AbhDIT3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D2256100B;
        Fri,  9 Apr 2021 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617996570;
        bh=00hZbP3J+izsAiSi4sMaAXm6sau+FuPNSfPCQ/OjoCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QV6oGEDfP6VuRfBhsmtJKVgb+Av3rTLMjmWg8K3vVSZsfL0VsWzv+JlqFT+cEa7ti
         2ovBcr8pBZE7ekt4NnI5f+E1c5kSnG027X/KAbwQjEwOeepqQInmMDpAMDlX/jTPlD
         44SCm7q/kKyJGzUdL4Yry7jetveIL8hgehAc6n/cOIZhY3EeBBv69BeXdXnmiaKZK5
         DUJ8q+9BHGVjxbGWkfP90SJYfEr5cyY9B1wDX/3OSh+0QFA2vAYb7j2LrEF+Xi/GEA
         7XO5p02Ugz0fC46L9/CUNBgar2bkDpj/14kALqTYh/2jZ6BJodD4El9YOLKf1J+fJA
         6b2qu6R/oRSzg==
Date:   Fri, 9 Apr 2021 12:29:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <20210409122929.5c2793df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHCknwlzJHPFXm2j@apalos.home>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
        <20210402181733.32250-4-mcroce@linux.microsoft.com>
        <20210409115648.169523fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YHCknwlzJHPFXm2j@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 22:01:51 +0300 Ilias Apalodimas wrote:
> On Fri, Apr 09, 2021 at 11:56:48AM -0700, Jakub Kicinski wrote:
> > On Fri,  2 Apr 2021 20:17:31 +0200 Matteo Croce wrote:  
> > > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Co-developed-by: Matteo Croce <mcroce@microsoft.com>
> > > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>  
> > 
> > Checkpatch says we need sign-offs from all authors.
> > Especially you since you're posting.  
> 
> Yes it does, we forgot that.  Let me take a chance on this one. 
> The patch is changing the default skb return path and while we've done enough
> testing, I would really prefer this going in on a future -rc1 (assuming we even
> consider merging it), allowing enough time to have wider tests.

Up to you guys. FWIW if you decide to try for 5.13 the missing signoffs
can be posted in replies, no need to repost.
