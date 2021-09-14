Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035CA40ACF3
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhINMBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232065AbhINMBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 37F54610FB;
        Tue, 14 Sep 2021 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631620807;
        bh=1+BcQmLR1nzbYYH8TSyeZ/dQzWf7BpOnyZ3dSl1xEds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gBJRDXAV7f51myGgCrsGXAcM6cT5seCCDwAuAALh1dYIjs91hYleU5wVwX+KI+5XM
         T92Htz46+rqdt94npGaagMkkbkmtXMYvHlyn9eqTY1TPDwpxsz/Xe28yMIouFpNTbm
         3R9CvuFxfze3MZwCdJhqkoBdacXw5m8lmR0yGMMkpvxk9aaLCb4tbaF/2X8HAJ+eqS
         puC6L7PFBVT+Dfowkso5uQgpB9mIOloGcgeRpIwoNI4XsCEdJGLr29xPDc8IRqRJc4
         gDX99RF0F6uEAw8PgfA33F1VVz49q3K0sE3eBKtocu3+Rg2f/BfKqT0LWu/zIO8m4f
         w+xL9cqzshE5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2BFA4609E4;
        Tue, 14 Sep 2021 12:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net-caif: avoid user-triggerable WARN_ON(1)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162080717.6005.8911830951764425896.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 12:00:07 +0000
References: <20210913180836.3943779-1-eric.dumazet@gmail.com>
In-Reply-To: <20210913180836.3943779-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 13 Sep 2021 11:08:36 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syszbot triggers this warning, which looks something
> we can easily prevent.
> 
> If we initialize priv->list_field in chnl_net_init(),
> then always use list_del_init(), we can remove robust_list_del()
> completely.
> 
> [...]

Here is the summary with links:
  - [net] net-caif: avoid user-triggerable WARN_ON(1)
    https://git.kernel.org/netdev/net/c/550ac9c1aaaa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


