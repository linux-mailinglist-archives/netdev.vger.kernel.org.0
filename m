Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7549433F979
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhCQTkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233106AbhCQTkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A570D64EED;
        Wed, 17 Mar 2021 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616010009;
        bh=ClnWzG1Jc9qETOXpU2knkn8wGX4p30Q6JYIvrktOzNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a2MkNEjAKtWRVYHPvVJih3z4u5bqY7E/dSSHLbQBr+UuSiVZEBZ5sD1a1VyHaI7J6
         qfAU6g/V3Yu0kEjr8B0CWxBbCcJfVjhdCd2w5Wsgw+y75uaiRcchr2uv9a6rYp4HYg
         KlCuEysY9O+iqOywLJi4ebJVky//Xt9mRZRAoy1p66Po+uH1Zne6b3WmFo1Np1FJXi
         VixUaN2Sqweh+R7RLh5eQBcdO4zlpdeD+BcXfJ/SRBxpyhceWVFqXepjDqUulWYxU1
         cfxa65ro3xooFkdaYOZ2rEnYvzlu6xVZuiNFcqIUSCTFBCZCGs6wxH2ka7ypW2E9jN
         ZeeERtbBU2RHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 943FF60A60;
        Wed, 17 Mar 2021 19:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] DSA/switchdev documentation fixups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601000960.22747.10693710525366505890.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:40:09 +0000
References: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 19:44:53 +0200 you wrote:
> These are some small fixups after the recently merged documentation
> update.
> 
> Vladimir Oltean (5):
>   Documentation: networking: switchdev: separate bulleted items with new
>     line
>   Documentation: networking: switchdev: add missing "and" word
>   Documentation: networking: dsa: add missing new line in devlink
>     section
>   Documentation: networking: dsa: demote subsections to simple
>     emphasized words
>   Documentation: networking: dsa: mention that the master is brought up
>     automatically
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] Documentation: networking: switchdev: separate bulleted items with new line
    https://git.kernel.org/netdev/net-next/c/cfeb961a2b5f
  - [net-next,2/5] Documentation: networking: switchdev: add missing "and" word
    https://git.kernel.org/netdev/net-next/c/6b38c5719836
  - [net-next,3/5] Documentation: networking: dsa: add missing new line in devlink section
    https://git.kernel.org/netdev/net-next/c/8794be45cd45
  - [net-next,4/5] Documentation: networking: dsa: demote subsections to simple emphasized words
    https://git.kernel.org/netdev/net-next/c/e322bacb914d
  - [net-next,5/5] Documentation: networking: dsa: mention that the master is brought up automatically
    https://git.kernel.org/netdev/net-next/c/0929ff71cf92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


