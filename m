Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6A35775E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhDGWK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhDGWKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CFBB76121E;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833411;
        bh=6mMBDnTDjZrMNVXWFBlrSvKQyd/9N7sKnpHJzyrp/0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l5ylhzbpO43drOSQAwS76cWlaizO6GTMjnFjeVIMn7S1/KfVfLxtQi/0sztaR/qC0
         0ie8Ul5pyw+hqUoGDF4Q192Ok3+sh5RxEPktXG1kMbJi5ewAL2jj1CK1K5L0dIVNmI
         nyMP574XexurFy6GzFYjlO9quhZz1+tOP8+RbHr4qaHEfUx4caw8IMvFY7hR0FPABh
         sRD6kOsIZTNXSQRK9LDMUyggVbEvDP8nc9Egca3dOekUEUMd9BggRdE1Fb5W9+gCZ9
         EI60lKBTwX7twtR3evw70lFmIen62zTBem43dkOxi3lV8kCz/7dUKU1VNpcZA+jht2
         vMcy1+6suImYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA822609D8;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wan: z85230: drop unused async state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783341182.5631.13906538534486148540.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:11 +0000
References: <20210407104856.1345-1-johan@kernel.org>
In-Reply-To: <20210407104856.1345-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 12:48:56 +0200 you wrote:
> According to the changelog, asynchronous mode was dropped sometime
> before v2.2. Let's get rid of the unused driver-specific async state as
> well so that it doesn't show up when doing tree-wide tty work.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/wan/z85230.h | 39 ---------------------------------------
>  1 file changed, 39 deletions(-)

Here is the summary with links:
  - [net-next] net: wan: z85230: drop unused async state
    https://git.kernel.org/netdev/net-next/c/a18f19e91201

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


