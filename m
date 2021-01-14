Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4152F6A50
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbhANTAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbhANTAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 14:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B60823B44;
        Thu, 14 Jan 2021 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610650811;
        bh=8oOHKhwSPz0K/vpgkqbjAagdWhcsxpCGu91uJjBJ67g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ApmYOMYsPGJDLXxTxDi4Rxyfyhjgf3hhIMhm8SA+j4gsynb3IxbFscd8Bu1mYaiGr
         JMk+6nPuPEAVLjfCtp2xoaMxnJCMAKatrt1PEnCNfpF3hGRfeTWVbWxJeZSoB6YfCR
         +Ybfxgq7EnC44XMT0ViwqEyefXi76b91+HU9FRA3ymTDHYsEMMDKuzLHoUAyc8OFFw
         jnNyT/JdBZ02rIngVj2tDMu32ksTdWk/cgrNQIpU+ll90IChB58wKt+hRmE7ar7roq
         P8eIWpAqeEEo/oFGmpJS4gvpglcGE3B8WP6mOjy6urAJpO9wk77YtPIkXNvYEqpYX7
         Tz3F9gGb1Do2Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1DEC660156;
        Thu, 14 Jan 2021 19:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/7] MAINTAINERS: remove inactive folks from networking 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161065081111.20848.7577461351346623187.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 19:00:11 +0000
References: <20210114014912.2519931-1-kuba@kernel.org>
In-Reply-To: <20210114014912.2519931-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 13 Jan 2021 17:49:05 -0800 you wrote:
> Hi!
> 
> This series intends to remove some most evidently inactive maintainers.
> 
> To make maintainers' lives easier we're trying to nudge people
> towards CCing all the relevant folks on patches, in an attempt
> to improve review rate. We have a check in patchwork which validates
> the CC list against get_maintainers.pl. It's a little awkward, however,
> to force people to CC maintainers who we haven't seen on the mailing
> list for years. This series removes from maintainers folks who didn't
> provide any tag (incl. authoring a patch) in the last 5 years.
> To ensure reasonable signal to noise ratio we only considered
> MAINTAINERS entries which had more than 100 patches fall under
> them in that time period.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/7] MAINTAINERS: altx: move Jay Cliburn to CREDITS
    https://git.kernel.org/netdev/net/c/93089de91e85
  - [net,v2,2/7] MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
    https://git.kernel.org/netdev/net/c/09cd3f4683a9
  - [net,v2,3/7] MAINTAINERS: vrf: move Shrijeet to CREDITS
    https://git.kernel.org/netdev/net/c/5e62d124f75a
  - [net,v2,4/7] MAINTAINERS: ena: remove Zorik Machulsky from reviewers
    https://git.kernel.org/netdev/net/c/c41efbf2ad56
  - [net,v2,5/7] MAINTAINERS: tls: move Aviad to CREDITS
    https://git.kernel.org/netdev/net/c/0e4ed0b62b5a
  - [net,v2,6/7] MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
    https://git.kernel.org/netdev/net/c/4f3786e01194
  - [net,v2,7/7] MAINTAINERS: dccp: move Gerrit Renker to CREDITS
    https://git.kernel.org/netdev/net/c/054c4610bd05

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


