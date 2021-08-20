Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E193F2D9A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbhHTOAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231854AbhHTOAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 10:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 862EE6113D;
        Fri, 20 Aug 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629468007;
        bh=9qZ9DYqvOYMciEn6jtvuanN7It9WqNEUpD2Mg+Jpt4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IUPXzetjTy2e8PJURE7jEwokr3Bo2hiW1qDIJzMjqfaeU8hqv00xw9MBaO7yATfLm
         ghC1UrCRwVc7R6MLAlq1bhuycZa8t58UwihYHZpN1LRcWp98EiVHYLYaCxLFZ7qt5C
         CaoDaVSkUOBztW8jLeJUS6gHnUv51pPoeeDs/jbFfV3nCECy3ro22b88l9D9+wjLb+
         dfcXkOIbnL8xnLK/xVBbtqllhO2Qbtda1CWITAkn3ZMGb3nSaT9mFmBbUeVUl2X9ZQ
         bRvhaY+xz4spTsWUkLqMYD0thoJ136MvyI2w/BzMXNUH6b9tBy7qHczpep079c4Wj9
         X6z8xGHpq22RA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F9D560A50;
        Fri, 20 Aug 2021 14:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: ipa: kill off ipa_clock_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946800751.1573.5612130458523056017.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 14:00:07 +0000
References: <20210819221927.3286267-1-elder@linaro.org>
In-Reply-To: <20210819221927.3286267-1-elder@linaro.org>
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

On Thu, 19 Aug 2021 17:19:22 -0500 you wrote:
> This series replaces the remaining uses of ipa_clock_get() with
> calls to pm_runtime_get_sync() instead.  It replaces all calls to
> ipa_clock_put() with calls to pm_runtime_put().
> 
> This completes the preparation for enabling automated suspend under
> the control of the power management core code.  The next patch (in
> an upcoming series) enables that.  Then the "ipa_clock" files and
> symbols will switch to using an "ipa_power" naming convention instead.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: ipa: don't use ipa_clock_get() in "ipa_main.c"
    https://git.kernel.org/netdev/net-next/c/4c6a4da84431
  - [net-next,2/5] net: ipa: don't use ipa_clock_get() in "ipa_smp2p.c"
    https://git.kernel.org/netdev/net-next/c/c43adc75dc2d
  - [net-next,3/5] net: ipa: don't use ipa_clock_get() in "ipa_uc.c"
    https://git.kernel.org/netdev/net-next/c/799c5c24b7ac
  - [net-next,4/5] net: ipa: don't use ipa_clock_get() in "ipa_modem.c"
    https://git.kernel.org/netdev/net-next/c/724c2d743688
  - [net-next,5/5] net: ipa: kill ipa_clock_get()
    https://git.kernel.org/netdev/net-next/c/c3f115aa5e1b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


