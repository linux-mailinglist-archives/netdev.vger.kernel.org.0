Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794EA31208E
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhBGAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGAAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 19:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3C8A464E54;
        Sun,  7 Feb 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612656008;
        bh=gK1pygfKTMPF7MwlCM+NolIGSgXAPeAMMR5wiMvGp7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cmWsiZnUzxMPxV92JNzLo2RV72z3JhSSYeIuFbUyysg+tCVRs1c+wXrlX7cH2ltUU
         l6ja06jvULL7o/1/RLG6YIZazrGPVoIkbhq9kDVLzYFi5ikOwFudBtsAe6xw4a7JMp
         oAdLb5uyNuIJXD2OlSfxI8S0iQa8NdU8SK96IGqppih8kaax3tjQLIqvJkxT27e8Mi
         rDJ7pUuZJOR33qdWzjeJSv9P5OULR/r39xAN9aCrGTAK+x6HaJYqfJZJX2fVPh9hmt
         H5+5+7GlVU1kHwb4Hu+tZGNPEexxfSabGEY6Zrm5cX9dmrYRqzoJiTZ36mYD0w4jcL
         C1yWcTjI7+ltg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27606609F7;
        Sun,  7 Feb 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/7] netfilter: ctnetlink: remove get_ct indirection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265600815.10570.16310764666033863453.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Feb 2021 00:00:08 +0000
References: <20210206015005.23037-2-pablo@netfilter.org>
In-Reply-To: <20210206015005.23037-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat,  6 Feb 2021 02:49:59 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Use nf_ct_get() directly, its a small inline helper without dependencies.
> 
> Add CONFIG_NF_CONNTRACK guards to elide the relevant part when conntrack
> isn't available at all.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] netfilter: ctnetlink: remove get_ct indirection
    https://git.kernel.org/netdev/net-next/c/83ace77f5117
  - [net-next,2/7] ipvs: add weighted random twos choice algorithm
    https://git.kernel.org/netdev/net-next/c/012da53d1afb
  - [net-next,3/7] netfilter: flowtable: add hash offset field to tuple
    https://git.kernel.org/netdev/net-next/c/dbc859d96f1a
  - [net-next,4/7] netfilter: nftables: add nft_parse_register_load() and use it
    https://git.kernel.org/netdev/net-next/c/4f16d25c68ec
  - [net-next,5/7] netfilter: nftables: add nft_parse_register_store() and use it
    https://git.kernel.org/netdev/net-next/c/345023b0db31
  - [net-next,6/7] netfilter: nftables: statify nft_parse_register()
    https://git.kernel.org/netdev/net-next/c/08a01c11a5bb
  - [net-next,7/7] netfilter: nftables: remove redundant assignment of variable err
    https://git.kernel.org/netdev/net-next/c/626899a02e6a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


