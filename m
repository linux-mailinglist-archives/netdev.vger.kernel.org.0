Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212C737EEA2
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442148AbhELV4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239860AbhELVlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8C9C61457;
        Wed, 12 May 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620855609;
        bh=kAgkp5gKxMzkyixITaM5yF5JZUkswLxUJwKH0RQYBUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=clhmIbSsoUfLG9wSoPGRtWQ2r2IJIhtlW8UFamwrwuqKUM3yGDUNwZGA/8Rxz7m7z
         SUurp+rMh7cqP9nOGly99ImeHlQXBPHk6nlU1koFhSceB4Da9q6w3ZKBBPiLJ0uTu/
         zSf6haWpOc/LTy9RiG/ocI78dv8+Irk1XsVdDVo3+oc8Yx+1JjtRkvvzaNgwguwc9S
         W7Ce5pxoEAhC0BPRsQrdSRdpNSTSpmvtS5DIM2jY4FBjfTBnEoTTfJfV4dda+zW/cg
         xia355DnXcQXe5WGWVs9OZ0UmBIjzx8Zuw6cT2dBAtHcSkkj9uPW/URyYsddfV8VCy
         NL+8aHgsitgVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B33CF609AE;
        Wed, 12 May 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tls splice: remove inappropriate flags checking for MSG_PEEK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085560972.18109.1224710545722047850.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:40:09 +0000
References: <7faf1af984494296416646af7b44851dfb450866.1620808650.git.majinjing3@gmail.com>
In-Reply-To: <7faf1af984494296416646af7b44851dfb450866.1620808650.git.majinjing3@gmail.com>
To:     Jim Ma <majinjing3@gmail.com>
Cc:     kuba@kernel.org, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 12 May 2021 17:00:11 +0800 you wrote:
> In function tls_sw_splice_read, before call tls_sw_advance_skb
> it checks likely(!(flags & MSG_PEEK)), while MSG_PEEK is used
> for recvmsg, splice supports SPLICE_F_NONBLOCK, SPLICE_F_MOVE,
> SPLICE_F_MORE, should remove this checking.
> 
> Signed-off-by: Jim Ma <majinjing3@gmail.com>
> 
> [...]

Here is the summary with links:
  - tls splice: remove inappropriate flags checking for MSG_PEEK
    https://git.kernel.org/netdev/net-next/c/d8654f4f9300

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


