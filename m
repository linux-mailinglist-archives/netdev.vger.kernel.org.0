Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFD04D6D27
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiCLHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiCLHBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:01:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8DD26C2F4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 23:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B84C6B82E12
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DF62C340FD;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647068411;
        bh=VIuopcCM0/pnBFEHQqbQglGPcCgCDQAcDgINX8LqsJE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QbQZ/y6VJGlvmIstmEnihOj9zISVvPU2d5C99y2o/eRM95ZHTuJHiwih7mNd9r07f
         JOJI2rf+EgQeBsnNcETUTWcgQ9xFvNRfKWPeH/2FX0I2ccuzcBktr8rhjNJayBOmiw
         Pei4/dtiQudGyatYh6223Ht7ZzNqeodpOnfFNRhfMPYVF5YJ7LTVpOzvTvQmNOH34d
         TKIYAZp3aUfxjpOg9DjW43225TqA2hWPyVYkbp1qLTsfwWUqYvdSnFocWqu35u/h55
         L22MTa/N2E7okm7OMSGw6gV+jBh4xUGJrvCMmTDUYe+t/HkpspgVrcl3AcdJCI6NjJ
         1wK4pZ29chs3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5383EF03842;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tcp: unexport tcp_ca_get_key_by_name and
 tcp_ca_get_name_by_key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164706841133.27256.15463616742705488279.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:00:11 +0000
References: <20220310143229.895319-1-hch@lst.de>
In-Reply-To: <20220310143229.895319-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Mar 2022 15:32:29 +0100 you wrote:
> Both functions are only used by core networking code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  net/ipv4/tcp_cong.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - tcp: unexport tcp_ca_get_key_by_name and tcp_ca_get_name_by_key
    https://git.kernel.org/netdev/net-next/c/515bb3071e16

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


