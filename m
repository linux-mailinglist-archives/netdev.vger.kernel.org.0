Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9847483B3A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 05:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiADEKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 23:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiADEKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 23:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A8D061262
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 052C0C36AEF;
        Tue,  4 Jan 2022 04:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641269411;
        bh=vl194+AQ1xJktz6Zg8Z1UoNbJXjlThmJGc34Fw/vApM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h51/A2qsX626TKZN20dKijV7mA18Dhx1x+lPI04N+8ZaID3kwaYn4t9aQCE9dlL6T
         qYH/xEle+eaUBaFEMyOmUo/Ipnt1Vu+MiehbV4US8/SpiwIf5ggxUcvSfQmM/p3+PA
         euX1TTfa8bERdOqmxW94DARqjOP3nTbIsSFhyLechigE5Izp9MjIvYz4GFShIUNB7h
         qGMKidRBAm09mkP2hn1w1ihDqaHAS0fdX/es0i1EQfEYjslH94u5gX0/w9urWU0fWJ
         HdhbUXFv684LmrwgO8vqWo9MBHtsLtlErNBPJHYoJ4BOC5iCwUuySFMqNGKyWOR3Pn
         W27sJ9Q1ZvJqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E01CBF79408;
        Tue,  4 Jan 2022 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164126941090.3337.3399710514018347761.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 04:10:10 +0000
References: <20220103171722.1126109-2-sw@simonwunderlich.de>
In-Reply-To: <20220103171722.1126109-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Mon,  3 Jan 2022 18:17:20 +0100 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 5.17.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [1/3] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/c2262123cc49
  - [2/3] batman-adv: allow netlink usage in unprivileged containers
    https://git.kernel.org/netdev/net-next/c/9057d6c23e73
  - [3/3] batman-adv: remove unneeded variable in batadv_nc_init
    https://git.kernel.org/netdev/net-next/c/cde3fac565a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


