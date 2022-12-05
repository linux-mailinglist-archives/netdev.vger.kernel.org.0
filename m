Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6A6427AF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiLELkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiLELkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52C013FA2;
        Mon,  5 Dec 2022 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64FCFB80EFF;
        Mon,  5 Dec 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAA7BC433D6;
        Mon,  5 Dec 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670240416;
        bh=Apgz1+wdoqkJwdjY7kGoA+i9RMjAbaTi8PExuSGSOwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qt7LoVobZAZw9SwXPh1LTWVyi8wgNUS3cZYRoXpsAiDRM2TB0yw+M1s8n/Jm2K8I7
         1EsMipiE9+Y4heti/QdPFNuRhnK6vbcdX+UY78/SH9TjMevJ3Cl/IJTy80uGIJaPsp
         pm79xXxhXuByQFQrrB64+nWts6QN35nrO3L3XhN56fqVnUgZppgp/KzP2WSN5bloEI
         AhPTXLkvxz8xBk4iQJKNnvhstGI1AmRNpEgwKktmHouVYqyA0JbRpzMX41XhP02gYi
         V6GF9C4+rlrh1gXKN7Vkeu8RvY/NYv8mykKUFa0BoPtElhCHmyvIEGmSvwbNFoeELg
         RkVcWgX3EDEfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1E08E21EFD;
        Mon,  5 Dec 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] octeontx2-pf: Fix potential memory leak in
 otx2_init_tc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167024041585.2981.11881654323637354779.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:40:15 +0000
References: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Dec 2022 19:04:30 +0800 you wrote:
> In otx2_init_tc(), if rhashtable_init() failed, it does not free
> tc->tc_entries_bitmap which is allocated in otx2_tc_alloc_ent_bitmap().
> 
> Fixes: 2e2a8126ffac ("octeontx2-pf: Unify flow management variables")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
> v2:
>   - Remove patch 2 which is not a problem, see the following link:
>     https://www.spinics.net/lists/netdev/msg864159.html
> 
> [...]

Here is the summary with links:
  - [net,v2] octeontx2-pf: Fix potential memory leak in otx2_init_tc()
    https://git.kernel.org/netdev/net/c/fbf33f5ac76f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


