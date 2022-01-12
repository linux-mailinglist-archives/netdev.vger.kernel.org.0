Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABDF48C675
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354298AbiALOuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354295AbiALOuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE2BC061748;
        Wed, 12 Jan 2022 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59721B81F48;
        Wed, 12 Jan 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24964C36AE5;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641999010;
        bh=URopaG1yiPrxgtPoWWzhcJozfFtx2f8h9L3UD6HzMuQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aJswuNVkDY3ZgMsGAZomZeZkbjWHQOukkXLmngDJMv2/M0B4gdBKXv5IwrkbcZGNZ
         YH0LmSGb2TjAtxKwsPLeUM0RzeqXnnnZi6V5DCsMfE56AryqjnXRQ9GrkwHlRKDoqM
         aJEvBSzotkPHDKSdNHrnEsd8cltgyo3SsyUz1rv3tlcKvhlBe9jt/LILQYRZ1QHB/O
         Te64fxcqILx49ICmKrt7QEs2dH6gO8pbPm6Qnw9uirC1OgEoZe4rEJYiJP608DcF1W
         14lVf0sbo3WyxviVMqUu/4DDU4LknXftUvBihoBqvkRU0TTMqNeJNGwEpXpb2jYfkb
         Wd868tk4DGWEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08D3CF6078C;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] net: ipa: fix two replenish bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199901001.15011.131958675903975901.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:50:10 +0000
References: <20220112133012.778148-1-elder@linaro.org>
In-Reply-To: <20220112133012.778148-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, jponduru@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, mka@chromium.org, evgreen@chromium.org,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 07:30:09 -0600 you wrote:
> This series contains two fixes for bugs in the IPA receive buffer
> replenishing code.  The (new) second patch defines a bitmap to
> represent endpoint the replenish enabled flag.  Its purpose is to
> prepare for the third patch, which adds an additional flag.
> 
> Version 2 of this series uses bitmap operations in the second bug
> fix rather than an atomic variable, as suggested by Jakub.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: ipa: fix atomic update in ipa_endpoint_replenish()
    https://git.kernel.org/netdev/net/c/6c0e3b5ce949
  - [net,v2,2/3] net: ipa: use a bitmap for endpoint replenish_enabled
    https://git.kernel.org/netdev/net/c/c1aaa01dbf4c
  - [net,v2,3/3] net: ipa: prevent concurrent replenish
    https://git.kernel.org/netdev/net/c/998c0bd2b371

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


