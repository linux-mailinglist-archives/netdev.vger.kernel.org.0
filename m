Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FAA3B6A27
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhF1VXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237345AbhF1VXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7DB7761D01;
        Mon, 28 Jun 2021 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915254;
        bh=0qiR1b2ajo7C7e6kEC9+CaBgFnJgK5v9FELePrQIrls=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lfzlcp7QdHU8bHUtHTZMMnQESRSaqnVpqFDZEXWEOJUsqWHh2XMXk8N6NAnAhhwFq
         e5e0Ln1aaVb9AR7QmklTl/6Omq6LpJYBN5QihNsuCQdfnnNfYMmD1lb8jYkaj2yaJq
         PQ+XpOxJuQMC/pGohXNrwQAnO1yoFysF5EXljIfil0DJUqApwpByUY0b4SG2RoVGB7
         GgAXMGW2+LZVFoBX/hh27saKAHubcea7qiAK35Ow88WHyhdh4JePkYWpL3+PPhDsVS
         jay2eFj7Vj0QKmoh0MSDot6cFu4q+wWyf/wcNILJgdsnM7imeeHeqcG/ABpRO9Oiiz
         Je4WKBrbV6/aA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6CE2760A38;
        Mon, 28 Jun 2021 21:20:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] xdp: move the rxq_info.mem clearing to
 unreg_mem_model()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491525444.9606.11980237651538254312.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 21:20:54 +0000
References: <20210625221612.2637086-1-kuba@kernel.org>
In-Reply-To: <20210625221612.2637086-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, hawk@kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, lorenzo@kernel.org, bsd@fb.com,
        alexanderduyck@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 25 Jun 2021 15:16:12 -0700 you wrote:
> xdp_rxq_info_unreg() implicitly calls xdp_rxq_info_unreg_mem_model().
> This may well be confusing to the driver authors, and lead to double
> free if they call xdp_rxq_info_unreg_mem_model() before
> xdp_rxq_info_unreg() (when mem model type == MEM_TYPE_PAGE_POOL).
> 
> In fact error path of mvpp2_rxq_init() seems to currently do
> exactly that.
> 
> [...]

Here is the summary with links:
  - [bpf-next] xdp: move the rxq_info.mem clearing to unreg_mem_model()
    https://git.kernel.org/bpf/bpf-next/c/a78cae247681

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


