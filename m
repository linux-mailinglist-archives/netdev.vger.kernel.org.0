Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A653EACD9
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhHLWAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236426AbhHLWAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 18:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA9926109F;
        Thu, 12 Aug 2021 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628805605;
        bh=9K3u6hAfAv0oDffXPmUGxlhSK/8K1w2uCEAXmjxlunU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZUt9PSIOirZxe3FuE3tEmYA05BrOyuGK2b+6NHzfKLiWOW5zRSoq1A3fjwtVSXKiz
         msbWefWS7NkW0Y8sJ6/MxKMexLnbgTBBxhI9yzk5yc/niY8ucgPWl8YeCUr7xJ02l3
         AQ/j5oUJqFe6S1lo1fHorPcMBLNPj52qYIiqycl/UeP2WA0lSfcpl2lh+z+FMcnXdf
         iNgDB4gLe3+UEhOMY3p9u3cENJPbzm2tebcnw77i7rkPyVqdk16nc5SzcCJIOL4AAB
         DqOLAIoBPvcaYDh5DOpUHQsm2yZPpvY9IIC4fvFwwImqBXmyvZwFuDN3ofHUKDC69U
         jNYUo4J7bBRhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A99EA60A86;
        Thu, 12 Aug 2021 22:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ipa: always inline
 ipa_aggr_granularity_val()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162880560569.30992.3010650955358132466.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 22:00:05 +0000
References: <20210811135948.2634264-1-elder@linaro.org>
In-Reply-To: <20210811135948.2634264-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, lkp@intel.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 08:59:48 -0500 you wrote:
> It isn't required, but all callers of ipa_aggr_granularity_val()
> pass a constant value (IPA_AGGR_GRANULARITY) as the usec argument.
> Two of those callers are in ipa_validate_build(), with the result
> being passed to BUILD_BUG_ON().
> 
> Evidently the "sparc64-linux-gcc" compiler (at least) doesn't always
> inline ipa_aggr_granularity_val(), so the result of the function is
> not constant at compile time, and that leads to build errors.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ipa: always inline ipa_aggr_granularity_val()
    https://git.kernel.org/netdev/net-next/c/676eec8efd8e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


