Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0958A38CF7F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhEUVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUVBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F588613EE;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621630810;
        bh=HcNzOANr7xi4Q0KxmtIhzn7sqInmnhwHK/emzpPrHMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AGGWPOfC53tMmMhVeBhdDQhhvmWOIaRZ+tzwEFu7LCtcWSdQtKBgF3ZpSIkZYvHaP
         66Rj0hPPJYfF5RYO5gQhoft5qCXyUwHdDurt5u6ImSabqnou+yS8uubwwsy/fLLKaV
         BW+Wl7dIcDuqHGlXLIK3De/cPcyPigwwqdM/XiFZhOEFMkuCUlA5isp0hbkUcl2+nL
         YIXEg58aTZkOV6rYRYr7/V9Cf5CvFY3wpaLDPi48tcQy4mf1E/fVGt54jbMGviTn4L
         Kt/zfNWH/1VVjY7ph7ePNmsi4V8dTiqmnp3WdF5c0fuw6SVTtdYQkgIuuTbEWKgMr+
         maSg3M5wFN4ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 83D0860A56;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: Fix typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163081053.24690.8134672534907424278.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:00:10 +0000
References: <20210521094522.1862-1-zuoqilin1@163.com>
In-Reply-To: <20210521094522.1862-1-zuoqilin1@163.com>
To:     None <zuoqilin1@163.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 17:45:22 +0800 you wrote:
> From: zuoqilin <zuoqilin@yulong.com>
> 
> Change 'contol' to 'control'.
> 
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>
> ---
>  drivers/atm/zeprom.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - atm: Fix typo
    https://git.kernel.org/netdev/net-next/c/04fdfad68b81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


