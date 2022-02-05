Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C164AA9B4
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380178AbiBEPkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:40:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50904 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380231AbiBEPkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11CA1B8068D
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB6F3C340F5;
        Sat,  5 Feb 2022 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644075610;
        bh=tUgyOFLTT/1Hl26KrSt87NEG74AtqRYF4lgE7Vbqlw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mt0vx/uEzdBe/trjypRfUDIygE3vP4nFH00NSGN+hgjfu/YOKYvBlPmzhNl0v85h/
         PtQbWvkEl1+7AKt+usRGdkwzWPip+hlYbMEDeBgtbV9n++gV4oxR/GuvEwtfU/AjIP
         fuji/pYbG9RY5nbLq6W0zfb14TQ8RzNl4lGknvp1PKjlO0nhVoafXQhv53f5+wspEr
         HW5rirwRg6yARZdUjGzeQdH5lCIizJE69tPJh3fQl6TV4aJhoWPdcxY9HkBFXpiZYj
         EpPNv/+ShzoKFPq73roYohuj3kmc8upe4N93ubUrRzhZDGjiFT14J9H5g4AEOQCq8V
         fd/IWwnh8S2XA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 909ACE6D446;
        Sat,  5 Feb 2022 15:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ipv6: mc_forwarding changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407561058.28243.17653761007952202077.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:40:10 +0000
References: <20220204201546.2703267-1-eric.dumazet@gmail.com>
In-Reply-To: <20220204201546.2703267-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Feb 2022 12:15:44 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First patch removes minor data-races, as mc_forwarding can
> be locklessly read in fast path.
> 
> Second patch adds a short cut in ip6mr_sk_done()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ipv6: make mc_forwarding atomic
    https://git.kernel.org/netdev/net-next/c/145c7a793838
  - [net-next,2/2] ip6mr: ip6mr_sk_done() can exit early in common cases
    https://git.kernel.org/netdev/net-next/c/f2f2325ec799

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


