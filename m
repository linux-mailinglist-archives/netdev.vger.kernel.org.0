Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26C34FB8D2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiDKKEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344956AbiDKKC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE421102
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75C2DB811DD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37D66C385B1;
        Mon, 11 Apr 2022 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649671213;
        bh=eP3leWr5yfQ1OHUpuuwSrSMHitX4XK+rK+lZNzFF5mg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TInO1Ekb/6AG6JgREOsGkPIVtWopsAUeNPnIZR5IxhBPRlVW5WzON2Hbknjuux4X7
         1yJCyCRLX2ZIcZWdtZ6oUDc9GM5guIt3F4FmqxiSN2g58TfQi1ifjxoVFEcu7cMaaB
         jVgkxEGbVeSpE4nB/UZ8sINpoWhRaNsrVTtATp8vZvkYaCeJLmWgbYXQb64NPVD+3u
         syyX1TtvwXfGKz8zwzIwfVKCjTuPLhb6qcmz0llMPLFANjl+9EgVJ9RRCgkA48ZSZA
         yk/z7exOYrRa57PkC+R9Or+33U4u1c8Nd/tdNE4QQ6c8JTZaSyFpYaiYWO9looXX4U
         8aSNxbzFNF0qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25916E8DBD1;
        Mon, 11 Apr 2022 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc/wed: fix sparse endian warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967121315.20630.18412157221663475360.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 10:00:13 +0000
References: <20220408085945.64227-1-nbd@nbd.name>
In-Reply-To: <20220408085945.64227-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, lkp@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Apr 2022 10:59:45 +0200 you wrote:
> Descriptor fields are little-endian
> 
> Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)

Here is the summary with links:
  - net: ethernet: mtk_eth_soc/wed: fix sparse endian warnings
    https://git.kernel.org/netdev/net-next/c/4d65f9b6869a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


