Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13A53ABBD4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhFQScN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhFQScL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD8A6610A5;
        Thu, 17 Jun 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623954603;
        bh=1isSZmUH8CJvNaSVc5tipJCq1Nv4yebHA9XeB04QpHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VNOjiPuFP/6vST0cSWckWxoL6tKzurrQ6hegJuSgDKZMeFKGQbsB4s20w8AMmCBcD
         fzxL7PR683EM6dcgHfq8IFmTtrKADwfdPsKU71rdQjE+jxkln8WOHu+hCyDIVLIl6W
         A+rgf+j8JBTiPKl6N1nrIwtMJg0p43SpOiVSCwLZIS3vfoYHm+qNSU1bzPHNq1Qu7H
         V2vXHlqxZpi22cz/uUrOnjVsfNd9yKTwRKu0Y2mkZNLct1Q8srHLcYucD3gnlQYmtb
         bZ1krGp/9/XolH7rXCVATeXf9I87M9LQ/RyXKw8uL7daZ9yZR4qGDpkQ7VBvgzvX5b
         npwFLgfQdSrjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB4A660A6C;
        Thu, 17 Jun 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hamradio: fix memory leak in mkiss_close
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395460369.29839.9087281516154892944.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:30:03 +0000
References: <20210616190906.12394-1-paskripkin@gmail.com>
In-Reply-To: <20210616190906.12394-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 22:09:06 +0300 you wrote:
> My local syzbot instance hit memory leak in
> mkiss_open()[1]. The problem was in missing
> free_netdev() in mkiss_close().
> 
> In mkiss_open() netdevice is allocated and then
> registered, but in mkiss_close() netdevice was
> only unregistered, but not freed.
> 
> [...]

Here is the summary with links:
  - net: hamradio: fix memory leak in mkiss_close
    https://git.kernel.org/netdev/net/c/7edcc6823014

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


