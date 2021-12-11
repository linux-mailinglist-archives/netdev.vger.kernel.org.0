Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE884471187
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 05:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345948AbhLKEny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 23:43:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56938 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbhLKEnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 23:43:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF91ECE2D5D;
        Sat, 11 Dec 2021 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC44BC341CF;
        Sat, 11 Dec 2021 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639197610;
        bh=yQ40/VSB0PhGxV2OmMT58x3/7J4MzWLJkw7kvEAUxNc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KeqQavl2bY1tIT6aci3596dT4I9xX3q43n7/VzDxvhPXFfwgA2UZhy9ykLZfZFUTc
         hHeIqQFBqGkAi3XV3l+RQJTKq8VUCOf8kRLT+QYj4Vw8WzC3U7vHNQii0ecxGcPHbS
         shBiMrm9CTQmBHu2o434jn8nQyZtyiks51a5Talsx6uAYdedzT7/qUFqTjiC1O0Pcr
         2Y1M/GzX0iplxEA8c+5pNHbKnhJ+xlFT4sc+vcqci/kvFgcPm+SjB1GeNl1TfSh8c3
         xD1jcOa+E460EzqblHSKeLrd4KmG+xzCNAq3/ZJt+4YCm90IhH28S70tju78ErSsRN
         2KlIt+h+eYEow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D182260A90;
        Sat, 11 Dec 2021 04:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bna: Update supported link modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163919760985.24757.992471831878411156.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 04:40:09 +0000
References: <20211208230022.153496-1-erik@kryo.se>
In-Reply-To: <20211208230022.153496-1-erik@kryo.se>
To:     Erik Ekman <erik@kryo.se>
Cc:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 00:00:22 +0100 you wrote:
> The BR-series installation guide from https://driverdownloads.qlogic.com/
> mentions the cards support 10Gbase-SR/LR as well as direct attach cables.
> 
> The cards only have SFP+ ports, so 10000baseT is not the right mode.
> Switch to using more specific link modes added in commit 5711a98221443
> ("net: ethtool: add support for 1000BaseX and missing 10G link modes").
> 
> [...]

Here is the summary with links:
  - net: bna: Update supported link modes
    https://git.kernel.org/netdev/net-next/c/7adf905333f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


