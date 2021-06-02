Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE4839948F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFBUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhFBUbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 00201613F3;
        Wed,  2 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622665805;
        bh=PjY1wZD5qzZssxY/wRGjTNylFOoiQrHeZzb9AdmMCoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BXZrgE6sqv7SetLwi16lWmaLVvzQR0saHM1TptFgwa6Yqx+fRw5OlfZIBuSu2DXdr
         /V7RCAoi5/23mSjnJ4frIVQ9W4MszwvHI8NqEJRuCLOMpVpkBnH3ZS37SgKc8ikXfD
         8lneQJrxSmqDGlpiBjtPHIDB+mwAZcKPZXQIifZFnLp2l0yb+ahTj9fC6DQ0FZpHEG
         b2Qo9FixHont3zlNaCqdbc4pZK81mSTM1XHe/9GR7z4fE7U6YMMkI5zshUIUrVl1MG
         tkbrj0Yhw+cPMN9q7Oze/Ei7IPtRLApUS8QZHb7Y82D+hldUxsu1iHY6swI92PmyLL
         yatpUcEJMZIzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC12C60A39;
        Wed,  2 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sit: replace 68 with micro IPV4_MIN_MTU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266580496.6825.13952433055085431310.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 20:30:04 +0000
References: <20210602015039.26559-1-zhangkaiheb@126.com>
In-Reply-To: <20210602015039.26559-1-zhangkaiheb@126.com>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 09:50:39 +0800 you wrote:
> Use meaningfull micro IPV4_MIN_MTU
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv6/sit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - sit: replace 68 with micro IPV4_MIN_MTU
    https://git.kernel.org/netdev/net-next/c/7f0e869c4e39

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


