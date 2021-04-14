Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5240B35FE35
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhDNXJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236888AbhDNXJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1CD16105A;
        Wed, 14 Apr 2021 23:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618441759;
        bh=v7IE3YKxc6asPECSFUL4pLevbnfmdXHkjkFnPSaNtK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FF+JemkKXTp3IkZxnNaNxrNME7Hmore5jkYAE6WNDmd1DqdpfQQpb3fJM5cYEpqUS
         fmWn1/yMWNDb2PHsaq1+GOmzIP/yE4RPAFAPycl99I028ycOpaJ2C8otiIiVKP1zpe
         SoBRGRxjYdjVdlh/pD5bUd/zkHL0o/yvCxVb24rB+Vm9BghvHVjsV8iTnISma3yI+V
         gSURK78H8ZNbW023JWM/heC9NtOZPs2qRQ4S6rxRmR9/FUBSGTrKKKACgNFuV87NgL
         T4PprxFOhKuPtTmB2hmeSRKp8zfdIpWD/ERLEAKaiH8RRfmhpbpzuEEujoNoUy2zOM
         wdyuW7qAQahUg==
Date:   Wed, 14 Apr 2021 16:09:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH] net: Make tcp_allowed_congestion_control readonly in
 non-init netns
Message-ID: <20210414160918.70c0d7ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPFHKzdgNiwdChUnAyAt8keNwd12mkFczrLLFx7i-d6OXJ5VXw@mail.gmail.com>
References: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
        <20210413112339.263089fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAPFHKzdgNiwdChUnAyAt8keNwd12mkFczrLLFx7i-d6OXJ5VXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 17:31:55 -0400 Jonathon Reinhart wrote:
> On Tue, Apr 13, 2021 at 2:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 13 Apr 2021 03:08:48 -0400 Jonathon Reinhart wrote:  
> > > Fixes: 9cb8e048e5d9: ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")  
> >
> > nit: no semicolon after the hash  
> 
> Oops. scripts/checkpatch.pl didn't catch this, but it looks like patchwork did.
> 
> You indicated "nit": Shall I resubmit, or can something trivial like
> this be fixed up when committed? I'm fine either way, I just need to
> know what's expected.

I was just pointing it out, I wasn't 100% sure if it's important enough
for DaveM to request a repost.

> Also, this patch shows up in patchwork as "Not Applicable". I didn't
> see any notification about that state change, nor do I really know
> what that means. Was that due to this nit, or something else?
> 
> Thanks for guiding me through this.

I think best way forward is to repost with the nit addressed.
