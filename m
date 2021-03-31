Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94434F559
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhCaAKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232770AbhCaAKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6648E619D9;
        Wed, 31 Mar 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617149409;
        bh=/0LRbsaltMti8B7mmjtHchCXMqUeMYXvNEe4Sx1pXSY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DU2MCFNzjiwjwhMwOJJq2cdXvF9jL0Zi1mFgioSG/Zz05WimGIN83zSAuq72QbFbr
         tnAhS3D8Pyg2MHsj5nFozEO73Mq3ak7CHx6HUIo6/Ei//7tk6NJYv8MwlPW4mK7jr5
         xztyoQ9JETrfpmZgXPN91I0tFb8hatP1L8X3gjtu41VG1oQ4VZy1VwcUThxSpohWLr
         aO3NeawtGmNqZI4tdtRWVngolbpbqD2214C4Rsw4G9cF5lJXsBaDEQ7s08UxNKM08v
         tSxrgy7vasQS4yf+DewCOTgXEzxwogGlG+Ikm9Robbfc/VR7crNNh2sdGfyPk4MJb7
         duuUPy8CZ+C6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55FED60A5B;
        Wed, 31 Mar 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ppp: deflate: Remove useless call "zlib_inflateEnd"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161714940934.32754.10257093294349777080.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:10:09 +0000
References: <1617097890-27020-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1617097890-27020-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 17:51:30 +0800 you wrote:
> Fix the following whitescan warning:
> 
> Calling "zlib_inflateEnd(&state->strm)" is only useful for its return
> value, which is ignored.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - ppp: deflate: Remove useless call "zlib_inflateEnd"
    https://git.kernel.org/netdev/net-next/c/dc5fa2073f63

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


