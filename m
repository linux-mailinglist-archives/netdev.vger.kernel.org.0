Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F993A8AF4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFOVWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOVWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 17:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D00BC60FEB;
        Tue, 15 Jun 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623792003;
        bh=jzKHcJobg+Oydh2O9gg+WDDMJr5ZDOYBR9Gj67SIkC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E+KiRBdZ6/Xp2icKr0OKlPOC4ilZEqHm+8X1h5VFrB/PHnuadsXpZxrCoXYMnvJd7
         L18CvMNEUyfPd+AoHfyUt/BiChRJzKu+msc10iPKdoxyc42Xt3GD+KyTwgVes88DAt
         JsFSV8Mi/jcDt/ZrFTb1LvKc+gGTjnSoqSEWLdLrUWkDIiNldITn1EH2+PCSM/aWdd
         OwwT1YDKOepmu7CGn9PGTCsim8OZGuxIZrmJ0fyVYIfDq/wjAscGf4p7ZyNfZwXWcb
         olXpcqF+42I1LJQQJXwdtR+t63oXDdW5bvEADEQO9Tuy+plofiOr2T3mtp7uwkaxcc
         ymvDSHs26bYMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C3A7D609D8;
        Tue, 15 Jun 2021 21:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] lantiq: net: fix duplicated skb in rx descriptor ring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162379200379.19383.17533326316813780199.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 21:20:03 +0000
References: <20210615204257.217653-1-olek2@wp.pl>
In-Reply-To: <20210615204257.217653-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Jun 2021 22:42:57 +0200 you wrote:
> The previous commit didn't fix the bug properly. By mistake, it replaces
> the pointer of the next skb in the descriptor ring instead of the current
> one. As a result, the two descriptors are assigned the same SKB. The error
> is seen during the iperf test when skb_put tries to insert a second packet
> and exceeds the available buffer.
> 
> Fixes: c7718ee96dbc ("net: lantiq: fix memory corruption in RX ring ")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net,v2] lantiq: net: fix duplicated skb in rx descriptor ring
    https://git.kernel.org/netdev/net/c/7ea6cd16f159

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


