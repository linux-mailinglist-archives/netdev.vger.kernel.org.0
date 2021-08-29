Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0E3FAAA9
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 12:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhH2KBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 06:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhH2KA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 06:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD56760E76;
        Sun, 29 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630231205;
        bh=fo5yyIbYtpZvONWixWH2PDGhtDSsdE/tYEwFyfuPnmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=um8y61RZAMVxoUFQjSfEr1P5WhI5wmawWnTkTE63mls67hhYngW5JBNEnrR3lvy1V
         72qMVAeu96n1cXA0k+FSL+xopNxzsd6chimZMm3LL+5vk4jG0lQv77EIdNm6VGUQsf
         lXuycuaD+wm5O3U42u+7lrhdDexz4BZCJm0K4L5rAR9EbmIinBebgHTYa7ppYCLrhp
         To3B2XPNkSHwbnHCzgvDRCXuDdTkn2eMKQpJT4XO3W5ae3tmO9kTsfKdgZof30xeNQ
         bhpFDGjUP8iKGwTVQ4kmzIgN1IkuNIzsCyOv+onKZ/x/1c4qPNSyWD94KwJ39M7MDI
         5/vzXlGjQbang==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B24FE60A3C;
        Sun, 29 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] niu: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023120572.23170.3969043129089665520.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 10:00:05 +0000
References: <24bff575e35f3f5990d7c53741000a3ed29fb60a.1630094750.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <24bff575e35f3f5990d7c53741000a3ed29fb60a.1630094750.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 22:06:37 +0200 you wrote:
> In [1], Christoph Hellwig has proposed to remove the wrappers in
> include/linux/pci-dma-compat.h.
> 
> Some reasons why this API should be removed have been given by Julia
> Lawall in [2].
> 
> A coccinelle script has been used to perform the needed transformation
> Only relevant parts are given below.
> 
> [...]

Here is the summary with links:
  - niu: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/9b0df250a708

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


