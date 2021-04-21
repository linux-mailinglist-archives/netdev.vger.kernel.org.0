Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22019366301
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhDUAUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhDUAUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74A0261420;
        Wed, 21 Apr 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964409;
        bh=ltJsIEWhkwW880bynCD2zap7bXl2RxrQkI8fwhngIGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H5TezeQI/Lzv+DEc/550S7rIBUGIoeOF9jL2mkB2UZV34uJA8o0z1A/gssLDClKJy
         cwZhDQs8ycQZctbI6ofIU47UPITosqIJOLPGY0/N/S/+WnxNg+MmhvUoISb6xI+LTU
         Toag0rGd2E8tYw4xeEEdHuobairZ+74e2sM3awqybi++EjrCU21f2M23rKW9y9MQEO
         i+zVXwkEki2uTxLL31r73s77mEwDEMCRFR7ITHRB1pY7vczb90aM5KyQLu+y8jjAeD
         HJPLOH9WBU98kNYXj6LrgecdGftJfkBYxwdiwNYVl4neBifE1z7Bg47Vzr93AN8yoT
         LsmlJ7c/0ZynQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FD4760A39;
        Wed, 21 Apr 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: mhi_wwan_ctrl: Fix RX buffer starvation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896440945.12176.11376096603694657657.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:20:09 +0000
References: <1618911382-14256-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1618911382-14256-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 11:36:22 +0200 you wrote:
> The mhi_wwan_rx_budget_dec function is supposed to return true if
> RX buffer budget has been successfully decremented, allowing to queue
> a new RX buffer for transfer. However the current implementation is
> broken when RX budget is '1', in which case budget is decremented but
> false is returned, preventing to requeue one buffer, and leading to
> RX buffer starvation.
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: mhi_wwan_ctrl: Fix RX buffer starvation
    https://git.kernel.org/netdev/net-next/c/a926c025d56b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


