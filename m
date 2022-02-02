Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78F14A6AE2
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244248AbiBBEaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60084 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiBBEaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1569E616DC
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71132C340E4;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643776211;
        bh=EelSAIH8ZCJP51RLaanVciCAhPIAbwcVZ+cUP0ePneM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pSYDBXxwfImdchRMhglCeU/52gkHdMtyxekD/yS4rZ2cJHCbuquTi4vk3C3szz8E2
         jbAHmmDqS62+Asj2hcT64Ml/4r04JX6cyU88nH+r1CJ9NhJGxe5v/HhOaito1UG6P6
         qyYFIHnSZQk2DzXOOgfcF/5YLkxENbavZhEJYGK8wwUGzHC7upHteTd1N2KUO+L1V5
         rmTfn7lYaFT8Bfr5/kFBCGkyqxXDbY840xmM8xs5laI6OnWn3D78LRE7Hv3nTj9OXZ
         71W1/711wjqvnaqTpvKJyV9YJdv8vVgKWbXoK1MJzcjDVyWzMU/nx34b44QquAZQoy
         +WP+SHh/QAgPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56F8BE5D07E;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix mem under-charging with zerocopy sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377621134.13473.13371794882461288054.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:30:11 +0000
References: <20220201065254.680532-1-eric.dumazet@gmail.com>
In-Reply-To: <20220201065254.680532-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, talalahmad@google.com, arjunroy@google.com,
        soheil@google.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 22:52:54 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We got reports of following warning in inet_sock_destruct()
> 
> 	WARN_ON(sk_forward_alloc_get(sk));
> 
> Whenever we add a non zero-copy fragment to a pure zerocopy skb,
> we have to anticipate that whole skb->truesize will be uncharged
> when skb is finally freed.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix mem under-charging with zerocopy sendmsg()
    https://git.kernel.org/netdev/net/c/479f5547239d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


