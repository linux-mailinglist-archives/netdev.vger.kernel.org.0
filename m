Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2649B454903
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhKQOnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238684AbhKQOnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:43:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 29B83613A4;
        Wed, 17 Nov 2021 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637160009;
        bh=j28oowKD8nhaQY7RB0VZECtzz89fGIR629vd9TTVopA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpaeXgLfKQWNlk8V9VVNlGwcJeMMDCVQxQxL7AZ4MqNmrHxSGO7aIUa/tqDnekvzy
         9qfyNKhtl/+L3WPpVJkhfMEQVFxk6r7C6gw0oCeR/ftLDIAHAip6IPHFUrNe7GqEIT
         PNeqYbefndBr/Ysdozlir6UHHOjxcHA7eYHyoFnbxLkeUXkJt2HT/aoaJHv+fRzKtf
         Q3nVjIUT0Le3tMf+5Fmo/Hx0GOljpE8FSjUgJbXFPwiaPfJ1p8CN1KZKD9XCj6K+7B
         10swCLygW6ionzdCLumZ+OZZnY1M8BBynsyX/BkhRZbfVxCr7OospLYz/hKvlLoRgF
         xiZMYwTwJxBFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F24F609D3;
        Wed, 17 Nov 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: Enable PHY timestamping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716000912.6275.7397497381606966697.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 14:40:09 +0000
References: <20211116080325.92830-1-kurt@linutronix.de>
In-Reply-To: <20211116080325.92830-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, toke@redhat.com, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, bjorn@kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 09:03:25 +0100 you wrote:
> If the used PHYs also support hardware timestamping, all configuration requests
> should be forwared to the PHYs instead of being processed by the MAC driver
> itself.
> 
> This enables PHY timestamping in combination with the cpsw driver.
> 
> Tested with an am335x based board with two DP83640 PHYs connected to the cpsw
> switch.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: cpsw: Enable PHY timestamping
    https://git.kernel.org/netdev/net-next/c/65483559dc0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


