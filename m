Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834AF37B29D
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhEKXeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhEKXeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CADA6192E;
        Tue, 11 May 2021 23:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775990;
        bh=+7ryWm+vuXPPkuPYHpaD/MFyhZSybl905B1KBIzymE8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LUH9TTjcWaVmZ59DxJ9dwLMTl1o6hbPuh7PljJrEI1bp7WGPkvnFuoOwt8GlKFsDU
         KDeuvsbWES5vIBGt7mOCbO7s+uHgvI5n3eVAEapNdkXd1wFGkfLmnQ0ZqoXGM+20yf
         d2AZbSzdg/NZOgMbFqx5xWtTsbMu+bwvhz/5Je2d91k+7tJdXKtapyTJAhjBTfKujh
         KUWyPsApu/0rtbpAY5dZXxL8rBqGjFY8YNv5xsFophWQDSHxhQRaZ5nUf3n4PMlSA4
         DI0IizvmMbnvRf97/KxA7jYAlDhJt1IWvAzsvtKTsAPaXwf7WXHj9xa/mksgHVCiGd
         9n6rCQP7xMB8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 977AB60A48;
        Tue, 11 May 2021 23:33:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] net: wwan: Add unknown port type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077599061.17752.3944799225905263027.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:33:10 +0000
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     oliver@neukum.org, kuba@kernel.org, davem@davemloft.net,
        bjorn@mork.no, netdev@vger.kernel.org, aleksander@aleksander.es
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 11 May 2021 16:42:22 +0200 you wrote:
> Some devices may have ports with unknown type/protocol which need to
> be tagged (though not supported by WWAN core). This will be the case
> for cdc-wdm based drivers.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: Replace CDC specific port types change with that change
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: wwan: Add unknown port type
    https://git.kernel.org/netdev/net-next/c/bf30396cdf81
  - [net-next,v2,2/2] usb: class: cdc-wdm: WWAN framework integration
    https://git.kernel.org/netdev/net-next/c/cac6fb015f71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


