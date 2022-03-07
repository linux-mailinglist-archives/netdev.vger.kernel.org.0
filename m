Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9914CFD2B
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbiCGLlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiCGLlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:41:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286B34D63D;
        Mon,  7 Mar 2022 03:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B586460BC7;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D3EAC340F6;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646653210;
        bh=mlyRSGMHDuhd6nyifNSBdwxacmrAWkn6Zv76vL2R+Dg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y8kVToEpDuYiWVC1wfcN2bWP0qdVHiTo+6lD924xIB6lqlXsSkvJnuEZqPL0C8l1a
         uMbT80xVtt1Ht6cbrtUgXj7nVb2ItOEfU725ecKA9I38GjAuLQs8GuKh1afivAms60
         OEy6Y9vYshhMHJuXvla3YBNt7XJQOkTHrqcZ/w7IYI+ftAU7oVH/bK2gSS1OKaT75c
         Ye91PbsFSbxbIh+4F1kqRxrYvp4OUSmxY1lexnkB61Tm94xzAunv8ceQjh+Nxn6qe2
         Mhm5Tx8nIv5koK+jcThsrz4q9aEYU//NEHzmov5Mi7ZiHKXedmvWjJJvpqu7NWfwYp
         am1+6fcfeuavQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01C8CE6D3DE;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lantiq_xrx200: fix use after free bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665321000.12267.17544619753761934612.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 11:40:10 +0000
References: <20220305112039.3989-1-olek2@wp.pl>
In-Reply-To: <20220305112039.3989-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Mar 2022 12:20:39 +0100 you wrote:
> The skb->len field is read after the packet is sent to the network
> stack. In the meantime, skb can be freed. This patch fixes this bug.
> 
> Fixes: c3e6b2c35b34 ("net: lantiq_xrx200: add ingress SG DMA support")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net] net: lantiq_xrx200: fix use after free bug
    https://git.kernel.org/netdev/net/c/dd830aed23c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


