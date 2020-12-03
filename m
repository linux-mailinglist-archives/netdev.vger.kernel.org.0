Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17F2CDEAE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgLCTUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgLCTUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 14:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607023206;
        bh=wM/6Rlb5IZrLk2lOCVFuA+qC+LXVHUFfZ6o+BrFVRnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uE98KJWadqBDpp9ry+So5iR/LtS1fUMc23++o9sptfegmC4xw2pSTzawdqxMCFE28
         6BLzxOx35dffESG+yVvMN0JInX8xk5Jx1vkoSY0+8nvN/kVlUo7l3DsiMhrqbc5BPG
         OfDdPMPkV2Fz2JHLhP8NV+lKBup4FYCVVINWKMP6RZG04f1VmRIGj1KNnAXQWhsZbX
         dVncoqg5FlyByqVdoqy5epF3zVoFH8K9gJZs4TsnVy6FIkukvFVT48xd2rDDQXwoWc
         kjfnZ20WGNoVUT7ygwu844EqlKJI1MLjPMC+xy9JECivE85/c/6cJjv5MJExQ1Wl+j
         SFQiLctNCaPzQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: skbuff: ensure LSE is pullable before decrementing
 the MPLS ttl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160702320654.13599.3735974356539050340.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 19:20:06 +0000
References: <53659f28be8bc336c113b5254dc637cc76bbae91.1606987074.git.dcaratti@redhat.com>
In-Reply-To: <53659f28be8bc336c113b5254dc637cc76bbae91.1606987074.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, gnault@redhat.com,
        marcelo.leitner@gmail.com, simon.horman@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Dec 2020 10:58:21 +0100 you wrote:
> skb_mpls_dec_ttl() reads the LSE without ensuring that it is contained in
> the skb "linear" area. Fix this calling pskb_may_pull() before reading the
> current ttl.
> 
> Found by code inspection.
> 
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] net: skbuff: ensure LSE is pullable before decrementing the MPLS ttl
    https://git.kernel.org/netdev/net/c/13de4ed9e3a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


