Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0D43662E0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhDUAKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhDUAKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E99F961421;
        Wed, 21 Apr 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963810;
        bh=YEucPQq/mtRwa6FdmYH6SmYeZECMf7nkkJIYiPkUAXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GTsrpN1rARW7xXbeadLH5yFh56RBg+KO3iVAVmqQ7BQ60ToyWUgXMhqVu2PQm8m13
         XKPNORyKopvA2n8ckhXuJcBV552M1UNWKh/wbzZlUPVksXHSJKTH46DdAGvtpv5Fbd
         rg65WUssYFT/8Qs97BQPQclRNIVhF3Jd9LSGvykMsS/QmuRKUKmedjY/QZjxDEO+Wl
         20rdnKMClmELHCRAJ9+tkQEbE+OFyAXy3+SKdC1s8jLqTWsXAdfXwscCqXb1IsQYDG
         NRzY7WQmbyE61iayupL3c9Ro5J8zVngcnbqcg78oT2WkAWeK3YT4fU7T2hQVrMossN
         qTe7iKHZRFttg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E153160A39;
        Wed, 21 Apr 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] sfc: fix TXQ lookups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896380991.7038.8348862793426542295.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:10:09 +0000
References: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
In-Reply-To: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        themsley@voiceflex.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Apr 2021 13:24:54 +0100 you wrote:
> The TXQ handling changes in 12804793b17c ("sfc: decouple TXQ type from label")
>  which were made as part of the support for encap offloads on EF10 caused some
>  breakage on Siena (5000- and 6000-series) NICs, which caused null-dereference
>  kernel panics.
> This series fixes those issues, and also a similarly incorrect code-path on
>  EF10 which worked by chance.
> 
> [...]

Here is the summary with links:
  - [net,1/3] sfc: farch: fix TX queue lookup in TX flush done handling
    https://git.kernel.org/netdev/net/c/5b1faa92289b
  - [net,2/3] sfc: farch: fix TX queue lookup in TX event handling
    https://git.kernel.org/netdev/net/c/83b09a180741
  - [net,3/3] sfc: ef10: fix TX queue lookup in TX event handling
    https://git.kernel.org/netdev/net/c/172e269edfce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


