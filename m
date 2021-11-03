Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C87D443B62
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhKCCcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhKCCco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 22:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 783F36044F;
        Wed,  3 Nov 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635906607;
        bh=zA3bBqjnZozS5tljELDP4avI4poDN88s47i+SDcKzGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tAnk/OvceouOzHWqpxnE5B5awCA8Yk1SqaeCwcrjByJRiPIv8rcvVyam+MpsnbMm+
         svkDBmWdbWXy3a0kUkOFGEKExrYetWWqYZtZSPDwRZQVai1/tSBWSFMy3qPzYCW+9y
         rmMu9sKxzX+ojMFBBoz8ssccEHjeJVAhXEsWW5Sn8y4sBHmozzSXiIBCUicxT4NWav
         RV0cVvH+q052WMalBsaAa+J8j0jS5UUIVyvzJ6SPcBj87M7S3Tur+B+BDhhSE0jiSF
         8NktZepGWRuLdu0W886UQfvQuioPdcpgqQiRLgutkM8tNIRv7AW9Ko4VtXVPHjxdfs
         GRm+VgbTpMSEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 66EE8609B9;
        Wed,  3 Nov 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: add and use skb_unclone_keeptruesize() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590660741.25427.13306480885431474114.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 02:30:07 +0000
References: <20211102004555.1359210-1-eric.dumazet@gmail.com>
In-Reply-To: <20211102004555.1359210-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, elver@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  1 Nov 2021 17:45:55 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While commit 097b9146c0e2 ("net: fix up truesize of cloned
> skb in skb_prepare_for_shift()") fixed immediate issues found
> when KFENCE was enabled/tested, there are still similar issues,
> when tcp_trim_head() hits KFENCE while the master skb
> is cloned.
> 
> [...]

Here is the summary with links:
  - [net] net: add and use skb_unclone_keeptruesize() helper
    https://git.kernel.org/netdev/net/c/c4777efa751d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


