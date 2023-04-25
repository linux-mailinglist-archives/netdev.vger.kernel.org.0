Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43876ED9A2
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjDYBKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbjDYBKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C94200;
        Mon, 24 Apr 2023 18:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B074262AB3;
        Tue, 25 Apr 2023 01:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20C2BC4339C;
        Tue, 25 Apr 2023 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385020;
        bh=Uds3Go008k39toqC3q2GYZkOq+PKKpc9h7eSj+uYKwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7nFkvqOzhO+DeQh852TYoQBbIb4029s/WsLUVPPXS+i2nzlT6MPJQ9zsnXkDgMJb
         3pcG6n9NGGrS/5wXfdiVluF/qfwnYFoGtjNI2/ocTH/gVwxx7BW1/acHuzrO7HAHMI
         W02YY1dpopMTVevysG6aOI2mT1IwHW/x0gblH/o7geGrM6ve4QSMCEmenRWdYyG+RB
         DZAO6z9OoPj6v1styZ3IjLMtxUbWiVD75NEpVTrYKDhhkHO7YMXBFdEFJnys7Kniv9
         idw1RD0NoyAz2J0ML2y6jD555eLWFFGAZS4K/do+Y+vm09JvWcz1VimXcx+PrLTkHs
         PTnuda2HdgzHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A324E5FFCB;
        Tue, 25 Apr 2023 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] add page_pool support for page recycling in
 veth driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238502003.6495.7653449552257279063.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:10:20 +0000
References: <cover.1682188837.git.lorenzo@kernel.org>
In-Reply-To: <cover.1682188837.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 22 Apr 2023 20:54:31 +0200 you wrote:
> Introduce page_pool support in veth driver in order to recycle pages in
> veth_convert_skb_to_xdp_buff routine and avoid reallocating the skb through
> the page allocator when we run a xdp program on the device and we receive
> skbs from the stack.
> 
> Change since v1:
> - remove page_pool checks in veth_convert_skb_to_xdp_buff() before allocating
>   the pages
> - recycle pages in the hot cache if build_skb fails in
>   veth_convert_skb_to_xdp_buff()
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: veth: add page_pool for page recycling
    https://git.kernel.org/netdev/net-next/c/0ebab78cbcbf
  - [v2,net-next,2/2] net: veth: add page_pool stats
    https://git.kernel.org/netdev/net-next/c/4fc418053ec7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


