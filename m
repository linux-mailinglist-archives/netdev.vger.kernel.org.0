Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC7D3D6902
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhGZVMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhGZVMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 17:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E529F60F9C;
        Mon, 26 Jul 2021 21:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627336348;
        bh=BEzZP8gGjBIu+6KD+Bs3r2uEa+gu7HyTWWSvGZ54z1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KM/askmKDdiB1K7oMV6g6m0+6nuy3gJL1oPNHhEFOrZZndBIAWniouYKk5NeSFMIt
         GEVWWLqoJU695mo+eY2F5kXQ0htjPt+dNhvz/1u6wIieg1VNx1zMou4GU0dvcFfzOV
         CqI/cFevOfEijK1LdJhlwTQJDBRcVRud4JgO9904bVz95NMCSEOKu49a1YGMO5dLTZ
         yBZhsFsIzwopUkkoRqI3qsW+WLubFpwWPtuQgVQrK8U8VKx2Gyq7tzrb3h1FQ+P7Ul
         a+81twauGeEYAr/ExWrTAW4KFD0ATRjPmwBIgdrWXO6dt00JSq3Exd8ie73fWrz3Zh
         K/JgFPEWZZceQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF65960972;
        Mon, 26 Jul 2021 21:52:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: ipa: kill IPA_VALIDATION
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162733634890.1437.18333636505547989263.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 21:52:28 +0000
References: <20210726174010.396765-1-elder@linaro.org>
In-Reply-To: <20210726174010.396765-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 12:40:06 -0500 you wrote:
> A few months ago I proposed cleaning up some code that validates
> certain things conditionally, arguing that doing so once is enough,
> thus doing so always should not be necessary.
>   https://lore.kernel.org/netdev/20210320141729.1956732-1-elder@linaro.org/
> Leon Romanovsky felt strongly that this was a mistake, and in the
> end I agreed to change my plans.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: ipa: fix ipa_cmd_table_valid()
    https://git.kernel.org/netdev/net-next/c/f2c1dac0abcf
  - [net-next,2/4] net: ipa: always validate filter and route tables
    https://git.kernel.org/netdev/net-next/c/546948bf3625
  - [net-next,3/4] net: ipa: kill the remaining conditional validation code
    https://git.kernel.org/netdev/net-next/c/442d68ebf092
  - [net-next,4/4] net: ipa: use WARN_ON() rather than assertions
    https://git.kernel.org/netdev/net-next/c/5bc5588466a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


