Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CD83A6FBB
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhFNUCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233575AbhFNUCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BF4E26124B;
        Mon, 14 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623700805;
        bh=hwX2Ljm87r2IjeS7guvI2G5H0d4q/fsnz6rcW/f7xXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YJLil4Wsh5H2E23/8E2lnOlg8LveOJtVU24PCEo+NJ09Kl7z/RyzBEeIAp1f0GDMW
         sJLe56dxHfNokPZt93eEgcG0vWobQhef7csnjH9Wobs1BBt+iJzfDV7r+FmpiDqrI4
         RptjuA6aINykHK34As3LV97x/yC5FI3vzTAAgHp0bB7qzZcAUR709vY7/yIEj1Ia4r
         8Rz010EZi2VNXkktzPRfB7tpuT3gX6nb73fL+eL7l12Gq0yQn8IAx/kh6ONVtL8s3n
         ja2QSL7OkGWjOZuA8UaU05r0EJK71ROYtUgK+9TQ0IfrduDb8ey9k4xaNs54JG7QFz
         UjeJjqx0gnUmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8D0D609E7;
        Mon, 14 Jun 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: Remove DEBUG flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370080568.15507.14889242572607092508.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:00:05 +0000
References: <1623658600-21100-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1623658600-21100-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com, leon@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 10:16:40 +0200 you wrote:
> Author forgot to remove that flag.
> 
> Fixes: f7af616c632e ("net: iosm: infrastructure")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wwan/iosm/Makefile | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - net: wwan: iosm: Remove DEBUG flag
    https://git.kernel.org/netdev/net-next/c/ea99750e4019

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


