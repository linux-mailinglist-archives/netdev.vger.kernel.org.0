Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0999F3D131D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhGUPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240168AbhGUPTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:19:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B41EB61249;
        Wed, 21 Jul 2021 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883206;
        bh=aNx57MjkExvwH/RBivYW0wkowH9w22v3xcmSE9Iii7k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LiEbdPVt3T1rO4udg7gNx2Na7XCyjL2IE3umoOLRxNvYCpUM/BKZLWT9LgSDNTAZr
         2DxUHnFle/LDilWV3i/iDMruzNvSo7qwNQnmp8VXRvhj3CZ22Z3U5gJfQ9x+/T7TwZ
         HY1tBi5FA9/8PIcir6bYvEc0sZcoiMge/y7ggPIR/GsLhOhJtL+xUeL+Sditxy35F2
         tvnHEl3HiDzucm2H7kP0EByWFLThfcWNV6HhOd1eD/nxrSg1MhMAFkAG0Th/3ycKnr
         Cg1M9eHvCR4P7CYFyT+dUUZadbPZFn5SWYgMSQEg2fRatztp9C8BdKwYf3EUcjhqVV
         kPfmngKTxIlUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD5E160CCF;
        Wed, 21 Jul 2021 16:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next  0/2] Remove duplicate code around MTU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688320670.24738.11086277492729569014.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:00:06 +0000
References: <20210720200628.16805-1-vfedorenko@novek.ru>
In-Reply-To: <20210720200628.16805-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     dsahern@kernel.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        pablo@netfilter.org, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 23:06:26 +0300 you wrote:
> This patchset is intended to remove duplicated code around MTU calculation
> and consolidate in one function. Also it alignes IPv4 and IPv6 code in
> functions naming and usage
> 
> Vadim Fedorenko (2):
>   net: ipv6: introduce ip6_dst_mtu_maybe_forward
>   net: ipv4: Consolidate ipv4_mtu and ip_dst_mtu_maybe_forward
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/2] net: ipv6: introduce ip6_dst_mtu_maybe_forward
    https://git.kernel.org/netdev/net-next/c/427faee167bc
  - [RESEND,net-next,2/2] net: ipv4: Consolidate ipv4_mtu and ip_dst_mtu_maybe_forward
    https://git.kernel.org/netdev/net-next/c/ac6627a28dbf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


