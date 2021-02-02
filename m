Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AECE30CC3A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240094AbhBBTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233339AbhBBTqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 14:46:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E51464E56;
        Tue,  2 Feb 2021 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612295150;
        bh=poFuQwQsU2PME8YffAn0GP6z1ZRy04N6vTW56FmDWAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BeRk3ub+hI1w020CryLS6G2Q3R3dRZhe4CB9UcCOCBq8LdPnE45tf70c54dG2Yq60
         51fv3tKH6juszMErCfKrglbb7Tgq+DsaUEf/ueLbpm7uaEIdui2pnqR6/YsIy/1saV
         PrTnqpr2jFrHerKTT0Mopvxz+9UTIZj0CbguvUIxRHo0HDKi29xN93GSz4Toa5hxKw
         jkEq8RDEV7Pvz0pooEdQ6mgcnQ9h8UmAF3uwX/Gw3Ge2lGFde+nazKvaWSat9r/Loy
         h1a6NCxCU1sGsEgkVMao43aNfULFK1GoTyCcm+539fwvDSj+l2+0BEO1CcVavtQ3Zi
         jVNuYpgXyPd0A==
Date:   Tue, 2 Feb 2021 11:45:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, mikelley@microsoft.com,
        linux-hyperv@vger.kernel.org, skarade@microsoft.com,
        juvazq@microsoft.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] hv_netvsc: Copy packets sent by Hyper-V out
 of the receive buffer
Message-ID: <20210202114549.7488f5bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202081843.GA3923@anparri>
References: <20210126162907.21056-1-parri.andrea@gmail.com>
        <161196780649.27852.15602248378687946476.git-patchwork-notify@kernel.org>
        <20210202081843.GA3923@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 09:18:43 +0100 Andrea Parri wrote:
> Hi net maintainers,
> 
> 
> On Sat, Jan 30, 2021 at 12:50:06AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> > 
> > This patch was applied to netdev/net-next.git (refs/heads/master):
> > 
> > On Tue, 26 Jan 2021 17:29:07 +0100 you wrote:  
> > > Pointers to receive-buffer packets sent by Hyper-V are used within the
> > > guest VM.  Hyper-V can send packets with erroneous values or modify
> > > packet fields after they are processed by the guest.  To defend against
> > > these scenarios, copy (sections of) the incoming packet after validating
> > > their length and offset fields in netvsc_filter_receive().  In this way,
> > > the packet can no longer be modified by the host.
> > > 
> > > [...]  
> > 
> > Here is the summary with links:
> >   - [v2,net-next] hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer
> >     https://git.kernel.org/netdev/net-next/c/0ba35fe91ce3  
> 
> I'd have some fixes on top of this and I'm wondering about the process: would
> you consider fixes/patches on top of this commit now? 

Fixes for bugs present in Linus's tree?

You need to target the net tree, and give us instructions on how to
resolve the conflict which will arise from merging net into net-next.

> would you rather prefer me to squash these fixes into a v3? other?

Networking trees are immutable, and v2 was already applied. We could
do a revert, apply fix, apply v3, but we prefer to just handle the 
merge conflict.
