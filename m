Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8753DF6DA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhHCV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhHCV3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D13760F46;
        Tue,  3 Aug 2021 21:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026136;
        bh=vZEfyVYm6rkvVaAPo92cikkXoDuA6GQiE8rkbdEcXp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cGwO6L8lS8CXcX1f/SQJSXKAd8KpyMI2TX90igW8FGNkaNumdNIUJQkiFJ2/h1Dt2
         RNvSGTST+ZTN8cwlEeXDd6LVv3LxBYFglNptkmQEmyTk4l7fNyGi9UZbQN8StIV+tI
         gq+Y9jmHOW8Wq4skDGG81y2akW1vAODpEdrMHc6Y6AqOENEC1noLrtF7aHxXUqQwx7
         EmLQvRqJd6QN3kG+JIki51ck4rFZFWvxPU2IkQNQVZfPxfUPBYDbyCB1Uy/PoDskBs
         obymqhUpcpQGbTOy9Thbkxzgy0pKkTfkaXsZ+eLyHYOaZEZojim5fgztrXG9fSb2sn
         Xx9amk8QmGPnQ==
Date:   Tue, 3 Aug 2021 14:28:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net] mptcp: drop unused rcu member in
 mptcp_pm_addr_entry
Message-ID: <20210803142855.54590346@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7ef8acba-2ecc-37ec-165d-ba32b3f3fde@linux.intel.com>
References: <20210802231914.54709-1-mathew.j.martineau@linux.intel.com>
        <20210803082152.259d9c2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7ef8acba-2ecc-37ec-165d-ba32b3f3fde@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Aug 2021 11:11:16 -0700 (PDT) Mat Martineau wrote:
> On Tue, 3 Aug 2021, Jakub Kicinski wrote:
> > On Mon,  2 Aug 2021 16:19:14 -0700 Mat Martineau wrote:  
> >> From: Geliang Tang <geliangtang@gmail.com>
> >>
> >> kfree_rcu() had been removed from pm_netlink.c, so this rcu field in
> >> struct mptcp_pm_addr_entry became useless. Let's drop it.
> >>
> >> Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
> >> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> >> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>  
> >
> > This just removes a superfluous member, right? So could as well be
> > applied to net-next?
> 
> Hi Jakub -
> 
> Yes, it's just a superfluous member.
> 
> It seemed like a -net candidate, as it was addressing a mistake in a 
> previous commit (rather than a feature or refactor) and does affect memory 
> usage - and I was trying to be mindful of the stable tree process. But the 
> patch will apply cleanly to either net or net-next, so you could apply to 
> net-next if the fix is not significant enough.
> 
> I'll tune my net-vs-net-next threshold based on the tree I see it applied 
> to :)

Alright, applied but without the Fixes tag. Thanks!
