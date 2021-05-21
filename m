Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A710A38CF2B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhEUUlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhEUUle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C32C613F2;
        Fri, 21 May 2021 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621629611;
        bh=07d7zLdUJ6x6z+BbqKJKEfk+SPYNjvWy3oK86BZIGek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WJLe6ds87t7R4aO/OuvODzbg8nDWFTJ7R3+JiEK1oHErluA/ERJWCX0Ehp6q6XcTd
         qrsnFs2NkipA6aIuu1UlANuZwjL+wRLxPDi/S5o6Jy7x2VgBuN4QcDHAV5fOrvcCJe
         mMbKV+xXK3XFcbkQHev66H33sRAO0JpMu1nFmilkDsmGtg9AFn+3/lbBhpKf4VyucL
         F8FEhK2hFOMeba6kJKUBLZKVabR+NyzX4oztrn21Oa4LlXkhktzPaQ36iU4iZFpRGk
         k5JPEQzC6q7s5nnu564OGoDn9rT3JytN9FVsrxdUi3CFtsZ3+yPjX6h55aVRkc5L3D
         7Nkvlglr+409w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52A8360BFB;
        Fri, 21 May 2021 20:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bonding: bond_alb: Fix some typos in bond_alb.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162162961133.15420.11480122371286638792.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 20:40:11 +0000
References: <20210521033135.32014-1-wanghai38@huawei.com>
In-Reply-To: <20210521033135.32014-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 11:31:35 +0800 you wrote:
> s/becase/because/
> s/reqeusts/requests/
> s/funcions/functions/
> s/addreses/addresses/
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bonding: bond_alb: Fix some typos in bond_alb.c
    https://git.kernel.org/netdev/net-next/c/4057c58da21c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


