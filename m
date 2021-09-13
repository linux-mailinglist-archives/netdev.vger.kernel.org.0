Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430A408A6F
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhIMLl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239071AbhIMLlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 07:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B96E610CC;
        Mon, 13 Sep 2021 11:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631533207;
        bh=SXYsNW528KKkY1DlRYz1BsczSvkR6paU51bNVWuvjfI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ArWuWfW4hjJJT5Aoz1Gd/H2bLDi+tkgzqFIde7Yfy2tiuJI4vDfDzVslKOIav+QAG
         s0nmTx+GKLO+BMwswHS4CRmMT82Z6XTtiekWbE3rKAyPF2VFoBjdixJzXbZcdl9qsp
         quofFG9aSStR0nkX53nDCWMfE0NlFMPQutGfH01jGom5NKNaywZrIE9wVmW2BXKEz4
         CNs97gchbrFmiYnTmrWOk9bcG4kgwshTBVgaHI30WNyd5PVHJeav+yl/Y0c87nKYLO
         RcRxlcbr8euI7hTg07Nt4SyKdCBFXwPsJcJr3TnmGqB3SBnZBF8AWet6EAiZA2DERe
         abYpun7jnQUow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C81160A7D;
        Mon, 13 Sep 2021 11:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] udp_tunnel: Fix udp_tunnel_nic work-queue type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163153320737.25807.3776580129553678760.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 11:40:07 +0000
References: <1631519629-12338-1-git-send-email-ayal@nvidia.com>
In-Reply-To: <1631519629-12338-1-git-send-email-ayal@nvidia.com>
To:     Aya Levin <ayal@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, moshe@mellanox.com,
        tariqt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 13 Sep 2021 10:53:49 +0300 you wrote:
> Turn udp_tunnel_nic work-queue to an ordered work-queue. This queue
> holds the UDP-tunnel configuration commands of the different netdevs.
> When the netdevs are functions of the same NIC the order of
> execution may be crucial.
> 
> Problem example:
> NIC with 2 PFs, both PFs declare offload quota of up to 3 UDP-ports.
>  $ifconfig eth2 1.1.1.1/16 up
> 
> [...]

Here is the summary with links:
  - [net] udp_tunnel: Fix udp_tunnel_nic work-queue type
    https://git.kernel.org/netdev/net/c/e50e711351bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


