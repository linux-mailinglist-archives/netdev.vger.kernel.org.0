Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722753B0B55
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhFVRW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhFVRWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A763361055;
        Tue, 22 Jun 2021 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624382406;
        bh=kaIOMJMfpBlno7xuIPblma4VBSHdfTRBs+Y+WW4jsTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B1vE80XUHVPZfSCMor1Fpe9XqbS6EAxCAa9U6wOLz/K7szCnjBO6HHeoLcOjH6uN/
         pWJUNM4lxCUdlC1c161qe/IB+0Idy2lHuuebgHeh/mMOMhXKTvFiYgug5X260hjCBQ
         fKQy2Xf8ubLOGdLLXWe1F3eOmJJ4X5FZ7WN/DMdkYb6Tq1O76kM4Z7p7g37E7qgTLX
         4N0jfz3kukOo32ih8vGOpLxE8AtE1qrB2JfPYWlQnEbhW9/bjJf94HodRjo8boPbSk
         d3dFe9MPbLH0bPV195uMqLhh6RJOg+8IYLtIKOIwEkWGSrrCGcWKjHPNiq6RnqR0vh
         MT9aq8ww4yPrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9967F60A6C;
        Tue, 22 Jun 2021 17:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Avoid field-overflowing memcpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438240662.16834.16023435112374895219.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:20:06 +0000
References: <20210621215419.1407886-1-keescook@chromium.org>
In-Reply-To: <20210621215419.1407886-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 14:54:19 -0700 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> To avoid having memcpy() think a u64 "prof" is being written beyond,
> adjust the prof member type by adding struct nix_bandprof_s to the union
> to match the other structs. This silences the following future warning:
> 
> [...]

Here is the summary with links:
  - octeontx2-af: Avoid field-overflowing memcpy()
    https://git.kernel.org/netdev/net-next/c/ee8e7622e09a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


