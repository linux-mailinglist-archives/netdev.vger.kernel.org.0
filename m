Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95D5526044
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379563AbiEMKkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379549AbiEMKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542012992FA;
        Fri, 13 May 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E17926153C;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47F95C34119;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652438416;
        bh=zTvTiCTVxbvSW+PS+KKIL6/4dwDy6vvmSFDisj1b1rs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OdmEg7jyVFt1B6nyojJY4nORTfp1ZJ7uj+56TSh9q1DQrlVz54hVn8B1xmaCkpJl+
         TvhiUvWG91RyFUFt33Gf9UON7tsB41TDOW1JJAi5I/UevEMOMOnQms9tT7YSuRJ0Ci
         v3FUAFGGOEhg1uJJHgSo/4ioQxgDSujU6GRgDFCmZW8ztYxInhkLZdMEQJ+b0MY80b
         Pm6/WDTDPGE7YtNIEVsGFx11SsvvOdD5oxmE0oR23oHZNnNjW3i9DPzhHzLobFJq3K
         daoof2bgKQ2468WGXles9Nqm1JuTet+EdmibBwmGpgnSTZOHobgJ05olyydGmNuyEi
         fD/3lMKuQVHPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24D04F03935;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: page_pool: add page allocation stats for two
 fast page allocate path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165243841613.19214.9273427764376965858.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 10:40:16 +0000
References: <20220512065631.33673-1-huangguangbin2@huawei.com>
In-Reply-To: <20220512065631.33673-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 12 May 2022 14:56:31 +0800 you wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently If use page pool allocation stats to analysis a RX performance
> degradation problem. These stats only count for pages allocate from
> page_pool_alloc_pages. But nic drivers such as hns3 use
> page_pool_dev_alloc_frag to allocate pages, so page stats in this API
> should also be counted.
> 
> [...]

Here is the summary with links:
  - [net-next] net: page_pool: add page allocation stats for two fast page allocate path
    https://git.kernel.org/netdev/net-next/c/0f6deac3a079

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


