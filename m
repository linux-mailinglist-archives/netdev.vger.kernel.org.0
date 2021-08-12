Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414873EA9C8
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 19:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhHLRuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 13:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhHLRub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 13:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10F4D6101E;
        Thu, 12 Aug 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628790606;
        bh=yYn4zzWSGvHEceN5sD+zPW+yq54/wjUSasxAUiEn3lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qIK1FYBC4xk9mLZIoUzozIlxDFYTheheTuzP83i2sW9b0ttrQQ48wdFqT5Asov2DM
         DpEsFoGBdLxmt9lfyacbb8aqwEV4KWhqGKf8KqkxZXS3lFcnZFWtTzv9n4ULBpHVnB
         xTYW4UxDX74CDw1U34U/c8bKxZpwwHRMJjucQnoXR8o/PB9hgpn0gL3UiTqooZbaX3
         JO1YaqIv/ynxrccTrOAg0M8dvos5VXkw65Pf9x3BuuIBqdsa3ktjtw0bNQdEYFc8T2
         25U4wJSvw67LFg6ZeiCkp+svmIIMWZdKSQ0l6OS/uNPfyZMCCH+Pvl06tLWu3zEHxg
         nEAQBG5ZaEVIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0098160A69;
        Thu, 12 Aug 2021 17:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 1/1] wwan: core: Avoid returning NULL from
 wwan_create_dev()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162879060599.6809.15342160741755440449.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 17:50:05 +0000
References: <20210811124845.10955-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210811124845.10955-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 11 Aug 2021 15:48:45 +0300 you wrote:
> Make wwan_create_dev() to return either valid or error pointer,
> In some cases it may return NULL. Prevent this by converting
> it to the respective error pointer.
> 
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [v3,net,1/1] wwan: core: Avoid returning NULL from wwan_create_dev()
    https://git.kernel.org/netdev/net/c/d9d5b8961284

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


