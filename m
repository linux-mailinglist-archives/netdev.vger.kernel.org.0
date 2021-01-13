Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385EF2F4084
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404659AbhAMAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392246AbhAMAKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 19:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B868C2312F;
        Wed, 13 Jan 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610496608;
        bh=yMhB0UwKtv9ZQmkZJo/typgrATO7CJP0qRBqtEh2aQs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P0/qYjjt9lrCsIZQfETy4BdZmRaBqv6M2wy1oALZMfBFYEydzHMKabcow5+UybjwD
         snA5p1zgidwNMhq8PItzotFuKJ+5JMn3pCcQOgiJQbjdLJq5y3b+tkFVtMmDbCW3ot
         F9q7RmyiOF3rdgejtBZOmxDrs2yX3NNSz9pMQiWMm5TFgE8vtltcz4SRKhib6QSMOM
         esc/XQGzLQ5sjXFT1UOQdd68m6GeabwLES/G6HG7NVs3OptmbWNBEeIiU+igNjMVyv
         w0U787OXbToJTF4YGSrIYXDxg0j94NHBMmfQgxRob3zbKmcgjrxR9Fqc1sCrG88W3w
         1Via7OWLkxCww==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id A8227604E9;
        Wed, 13 Jan 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dcb: Accept RTM_GETDCB messages carrying set-like
 DCB commands
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161049660868.30735.15355435040639896254.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 00:10:08 +0000
References: <a3edcfda0825f2aa2591801c5232f2bbf2d8a554.1610384801.git.me@pmachata.org>
In-Reply-To: <a3edcfda0825f2aa2591801c5232f2bbf2d8a554.1610384801.git.me@pmachata.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 11 Jan 2021 18:07:07 +0100 you wrote:
> In commit 826f328e2b7e ("net: dcb: Validate netlink message in DCB
> handler"), Linux started rejecting RTM_GETDCB netlink messages if they
> contained a set-like DCB_CMD_ command.
> 
> The reason was that privileges were only verified for RTM_SETDCB messages,
> but the value that determined the action to be taken is the command, not
> the message type. And validation of message type against the DCB command
> was the obvious missing piece.
> 
> [...]

Here is the summary with links:
  - [net] net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands
    https://git.kernel.org/netdev/net/c/df85bc140a4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


