Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815394175BB
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbhIXNbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346151AbhIXNbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B68D61039;
        Fri, 24 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632490207;
        bh=LA9c1RRdZsLCZ6uQrf5D6cbvLH3pOG1ofas9431poWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pekb/PV6WRD8AN7ecc5kHmX9x8x9qEbC03I3I80a7cNa8APeRJzl6EkhJAwCyIEVu
         HP6N0Gp6bT1CI091eJmqw0sSJOKM7grITkk7Ss8rXtOjB52sQaz/oPs48s6qyoI/lc
         9hr3ZN1aG2aowLqLU27ytrL2pNUVDC/aJuZIacw7fXt73HSj/7hdx3PlafboyFTEjf
         udC1c/CRalv3ZiO9csDidN3E6Ma795P3ZLeEphItKCAjxnnrNSIgTWZgBRcIhe+ikc
         hgNSsGP9gUIZLhaXEl7iG5UqunVbowSfILVev1Ej0W2yLzOFyqc/mRYqOT7wdw/dsO
         WkwiOsAtO1SIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D03D60A6B;
        Fri, 24 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163249020737.645.2154623435401706824.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:30:07 +0000
References: <20210924092652.3707-1-dnlplm@gmail.com>
In-Reply-To: <20210924092652.3707-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     loic.poulain@linaro.org, mani@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 24 Sep 2021 11:26:52 +0200 you wrote:
> Fix double free_netdev when mhi_prepare_for_transfer fails.
> 
> Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  drivers/net/mhi_net.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Here is the summary with links:
  - [1/1] drivers: net: mhi: fix error path in mhi_net_newlink
    https://git.kernel.org/netdev/net/c/4526fe74c3c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


