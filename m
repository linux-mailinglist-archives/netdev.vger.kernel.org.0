Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044EC441B6B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhKANCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhKANCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2731610CB;
        Mon,  1 Nov 2021 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635771609;
        bh=9MDt+WhitCcmUwvZf4NzsL4QyBGm+A/J+wXhVbZwU48=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rnx1RCJSnRU4n2WWRSU344yoynGItrl/07NT4o9qdgbh/nc9zm7QosVRR/waQMupg
         9onydt2UmDXZZful0njBnfuWIG2yrgjowDDMB5jG3fC4wR73RKlgpkCDB892xc4wgJ
         62knR26YM17lF3pEMREkKNTdNLuTmT/7qh7gXR8jvpWYnsN/0LDQK3V4d1cW8QBWJv
         oELUPAduSrvb+axtL4fVgxaCw7l7yquN3cO7KIKwiFZJjiIKG17XfcrtqXDmUjv71G
         JltCO8tEwSfCkyyEleRSTiMrqh3k9TrV0nLeP2uBxEVhfcUaJoXZKt1bmQQTVWpeXc
         pnK4t10lGG6yw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E901360A0F;
        Mon,  1 Nov 2021 13:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/14] net/mlx5: Add esw assignment back in
 mlx5e_tc_sample_unoffload()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577160894.21575.1335066901780005432.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:00:08 +0000
References: <20211029205632.390403-2-saeed@kernel.org>
In-Reply-To: <20211029205632.390403-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        nathan@kernel.org, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 29 Oct 2021 13:56:19 -0700 you wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> 
> Clang warns:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c:635:34: error: variable 'esw' is uninitialized when used here [-Werror,-Wuninitialized]
>         mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, sample_flow->pre_attr);
>                                         ^~~
> drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c:626:26: note: initialize the variable 'esw' to silence this warning
>         struct mlx5_eswitch *esw;
>                                 ^
>                                  = NULL
> 1 error generated.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net/mlx5: Add esw assignment back in mlx5e_tc_sample_unoffload()
    https://git.kernel.org/netdev/net-next/c/1aec85974ab7
  - [net-next,02/14] net/mlx5: CT: Remove warning of ignore_flow_level support for VFs
    https://git.kernel.org/netdev/net-next/c/ae2ee3be99a8
  - [net-next,03/14] net/mlx5e: IPsec: Refactor checksum code in tx data path
    https://git.kernel.org/netdev/net-next/c/428ffea0711a
  - [net-next,04/14] net/mlx5: Allow skipping counter refresh on creation
    https://git.kernel.org/netdev/net-next/c/504e15724893
  - [net-next,05/14] net/mlx5: DR, Add check for unsupported fields in match param
    https://git.kernel.org/netdev/net-next/c/941f19798a11
  - [net-next,06/14] net/mlx5e: Refactor rx handler of represetor device
    https://git.kernel.org/netdev/net-next/c/28e7606fa8f1
  - [net-next,07/14] net/mlx5e: Use generic name for the forwarding dev pointer
    https://git.kernel.org/netdev/net-next/c/189ce08ebf87
  - [net-next,08/14] net/mlx5: E-Switch, Add ovs internal port mapping to metadata support
    https://git.kernel.org/netdev/net-next/c/4f4edcc2b84f
  - [net-next,09/14] net/mlx5e: Accept action skbedit in the tc actions list
    https://git.kernel.org/netdev/net-next/c/dbac71f22954
  - [net-next,10/14] net/mlx5e: Offload tc rules that redirect to ovs internal port
    https://git.kernel.org/netdev/net-next/c/27484f7170ed
  - [net-next,11/14] net/mlx5e: Offload internal port as encap route device
    https://git.kernel.org/netdev/net-next/c/100ad4e2d758
  - [net-next,12/14] net/mlx5e: Add indirect tc offload of ovs internal port
    https://git.kernel.org/netdev/net-next/c/166f431ec6be
  - [net-next,13/14] net/mlx5e: Term table handling of internal port rules
    https://git.kernel.org/netdev/net-next/c/5e9942721749
  - [net-next,14/14] net/mlx5: Support internal port as decap route device
    https://git.kernel.org/netdev/net-next/c/b16eb3c81fe2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


