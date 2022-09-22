Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8115E580A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiIVBaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiIVBaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F15C9E8BF
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC9F962E1A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AA80C4347C;
        Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810216;
        bh=fbbYRNaPIgV6Ro8IEPOBd8SWHJyjgmwoNmeJ1zVUX3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RvejX86nG40okq5eUtp5NJFx/gzn4OdbVmDbhvmeFcHV9BDbFOoJku3reKTv1MHrw
         kDJWtf4yW6rRZCAIqqW/Qgs6Z2vlarUDpxay/aR7dXigAHUlJjPkM5TmcX/WH1xBfX
         YZJuF/wFpkL+yBah39dnDkhLHFRU6l+cGiITtXb6sd/0+2+5RIr6EvHVG46FIb0fCH
         NH/hl6dvOsVUX6KQJFutmGAZyKkQnVQNjZS+jQRVaknbxqiLTlxIL21Xn2RaaYVxYg
         6ddMWjySi9Qixn33AoH+phP9CCXhrgqHMqPkk87/yt+UnmQW3qz35pIGOm5gNPHz4w
         o3RScrt66FXMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1615E4D03F;
        Thu, 22 Sep 2022 01:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns3: add __init/__exit annotations to module init/exit
 funcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381021591.720.3462302801126026840.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:30:15 +0000
References: <20220917082118.7971-1-xiujianfeng@huawei.com>
In-Reply-To: <20220917082118.7971-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 17 Sep 2022 16:21:18 +0800 you wrote:
> Add missing __init/__exit annotations to module init/exit funcs.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 4 ++--
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: hns3: add __init/__exit annotations to module init/exit funcs
    https://git.kernel.org/netdev/net-next/c/134a46479222

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


