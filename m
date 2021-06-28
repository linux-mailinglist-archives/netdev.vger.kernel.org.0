Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840D63B697F
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhF1UMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237261AbhF1UMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:12:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A82561CC6;
        Mon, 28 Jun 2021 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624911004;
        bh=b568gSz1ja7MrHu8Av5oNjVsVEYKyL0Y2Ogu06/5NzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i+1unuCEZ/usO461bpKPpW3DsrGLOor/WlkOgBIYjMoAk3JUiJzNQNewRmBzydIip
         QaIrQ4Op/dpuouGrNpagkZD3qGTbMxyyXgU0wo1pO/Od3svffZiEKp2zvKm9B9xEcQ
         q0z0MjcMHitIbnyDZvOu3JHRalObQ1jXSpOOqT536SFTb1LuLf5A3hSabCFNO3A6/x
         5r7O9pcmPh7Fsi4iLJP1QYWC9BXF5cRkVgcw4xbTwYOBgm5hgknmmsTOc0MVtY6kUF
         V8eHLuXGnmAAFgDMgPYNXZeuGi5ZuEw+sRMgqdzXC+iGmr/pZhNYX40ELXGDWZIsDL
         0EdL9jyOuPCvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08EF060A56;
        Mon, 28 Jun 2021 20:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: lwtunnel: handle MTU calculation in forwading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491100403.2562.9093785941784611032.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:10:04 +0000
References: <20210625162139.9067-1-vfedorenko@novek.ru>
In-Reply-To: <20210625162139.9067-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 25 Jun 2021 19:21:39 +0300 you wrote:
> Commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") moved
> fragmentation logic away from lwtunnel by carry encap headroom and
> use it in output MTU calculation. But the forwarding part was not
> covered and created difference in MTU for output and forwarding and
> further to silent drops on ipv4 forwarding path. Fix it by taking
> into account lwtunnel encap headroom.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: lwtunnel: handle MTU calculation in forwading
    https://git.kernel.org/netdev/net/c/fade56410c22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


