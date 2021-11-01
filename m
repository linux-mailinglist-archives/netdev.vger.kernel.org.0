Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8B8441BCB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhKANjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhKANjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D80D610CB;
        Mon,  1 Nov 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635773408;
        bh=CwRFl5J1rCtPhkn5CuIX1G34VL8jNzf8OjQyc12BXMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gt+2rCLR9fndMg9mKw0faHZqgDUxwQU/j0x2Eq7kjXHIbg8EF1pqBCZEXKGVk1NJY
         GGm0UiJOKrfIAwAw4O3tfK/zjOeYpZLJ4XwIBRbBYGlNZQcquxUKGODekcDyzCt/Sz
         4a/E8gGQyZmH6W1qnxo1Lwb4GHnDzFhTwybtmY+HuZZDbK6AUI3x9SEE2lsghRrjiy
         n3nASRpjhqSB3BvOKDVNS5+NndkH5QMWjzVQNZ56RP/YoFHca9Hq+pAEurqaunmFM3
         PPN8cunANdY1atFCm2lcjBsO31uu2d1ftEFe1S9BXcAPCIMiyLX1wiHZpQiaaHAUN3
         5JWZNhwel+zAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8212A609B9;
        Mon,  1 Nov 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: Allow ipv6gretap interface for
 offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577340852.3113.17219014073103831158.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:30:08 +0000
References: <20211029150429.23905-1-simon.horman@corigine.com>
In-Reply-To: <20211029150429.23905-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yu.xiao@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 17:04:29 +0200 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> The tunnel_type check only allows for "netif_is_gretap", but for
> OVS the port is actually "netif_is_ip6gretap" when setting up GRE
> for ipv6, which means offloading request was rejected before.
> 
> Therefore, adding "netif_is_ip6gretap" allow ipv6gretap interface
> for offloading.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: Allow ipv6gretap interface for offloading
    https://git.kernel.org/netdev/net-next/c/f7536ffb0986

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


