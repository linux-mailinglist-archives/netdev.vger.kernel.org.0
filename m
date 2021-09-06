Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B593401DC8
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 17:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243032AbhIFPvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 11:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242432AbhIFPvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B8B960F9E;
        Mon,  6 Sep 2021 15:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630943405;
        bh=HqLRktkRBEJxR+5alQ8M/Dk+icix4Yp6GNAzyh2MS+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JJ60xXimupeOLrSIpfH4aNdgrOtsxNs28xBRzBrZLSuUb51bEYh3a5n6WnJ+w/J0X
         voiP168YGN8SIUyQffbKkaRjWYEdfuPmRDYLwH14V2aP0vm8yyuWix64GuJ50dLa8s
         3Dl5wEcSGXmKYLx8ncTQxMjmDsIq9/3oG4EUNucBM5tVdxUZtC4qrKS2y8j9FscENj
         ful60HeyqkM2ltUq1OGuD1D2wI4L+xxprmnAk6HGef8nF1YxBD9u7Sto6o2f71Fmfj
         6/9IwFA2/avCgJ6JNy9Nm4AeE300U9rkj/Y8Y5nkp0tOUDn3Zhgb5ByhnRqTT4tWYL
         jk22ACRl/PQWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3FE5460A37;
        Mon,  6 Sep 2021 15:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qcom/emac: Replace strlcpy with strscpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163094340525.32353.11305691764552334355.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 15:50:05 +0000
References: <20210906135653.109449-1-wangborong@cdjrlc.com>
In-Reply-To: <20210906135653.109449-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     davem@davemloft.net, timur@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 21:56:53 +0800 you wrote:
> The strlcpy should not be used because it doesn't limit the source
> length. As linus says, it's a completely useless function if you
> can't implicitly trust the source string - but that is almost always
> why people think they should use it! All in all the BSD function
> will lead some potential bugs.
> 
> But the strscpy doesn't require reading memory from the src string
> beyond the specified "count" bytes, and since the return value is
> easier to error-check than strlcpy()'s. In addition, the implementation
> is robust to the string changing out from underneath it, unlike the
> current strlcpy() implementation.
> 
> [...]

Here is the summary with links:
  - net: qcom/emac: Replace strlcpy with strscpy
    https://git.kernel.org/netdev/net/c/0a83299935f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


