Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A303D83B7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhG0XKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhG0XKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E310860F90;
        Tue, 27 Jul 2021 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627427405;
        bh=91NlHb2pLhHcjpQvKQw0CLmiWwYWplDzaYo3UF9YO2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lIB5UiYWzgztce4GOXwqBGSHRFM1prWEbpqix2DJeHc9/X+S1g3d8w/bmQYqcZdUY
         ynWDLwBu3GyUdDFPeIJlYyjfo9+JwzrCriIfUCUrtBapDtLhss7C5ZFCfryS+cw6no
         ZvnJTjW3WJ8TlBFFRKkQRVfuMAuGjWrlluBT+Kjgk6OnWeyTAQzhu+A1MLMbyb5QbH
         G5vIq+Xmw41Wg5kEyQVEjTFKyXeFWRu39oxs+y2jTLJzFDKRqtkmjqfI4XCJRFMXfb
         pTGEEqit60rV4Yn+s/oJhGBQHdrKWhhB2oUq/5jS+tugsoNMPivTspgklQq1FpLMS5
         aKXXk6iryvh5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D667B60A56;
        Tue, 27 Jul 2021 23:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: ipa: add clock references
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162742740587.8559.12295112318591386270.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 23:10:05 +0000
References: <20210727211933.926593-1-elder@linaro.org>
In-Reply-To: <20210727211933.926593-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 16:19:28 -0500 you wrote:
> This series continues preparation for implementing runtime power
> management for IPA.  We need to ensure that the IPA core clock and
> interconnects are operational whenever IPA hardware is accessed.
> And in particular this means that any external entry point that can
> lead to accessing IPA hardware must guarantee the hardware is "up"
> when it is accessed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: ipa: get clock in ipa_probe()
    https://git.kernel.org/netdev/net-next/c/923a6b698447
  - [net-next,2/5] net: ipa: get another clock for ipa_setup()
    https://git.kernel.org/netdev/net-next/c/cf8dfe6ab8e7
  - [net-next,3/5] net: ipa: add clock reference for remoteproc SSR
    https://git.kernel.org/netdev/net-next/c/34c6034b4764
  - [net-next,4/5] net: ipa: add a clock reference for netdev operations
    https://git.kernel.org/netdev/net-next/c/f2b0355363f3
  - [net-next,5/5] net: ipa: don't suspend endpoints if setup not complete
    https://git.kernel.org/netdev/net-next/c/2c257248ce8e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


