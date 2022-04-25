Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B625150DD31
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbiDYJx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239910AbiDYJx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC35D3EA9B;
        Mon, 25 Apr 2022 02:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A831B811A2;
        Mon, 25 Apr 2022 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 425BDC385AD;
        Mon, 25 Apr 2022 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650880213;
        bh=80RRtGvuoBRD9GGXSdxDFqx1jir+bG1S+DXWe53k7rs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P/XKjDilWy/XrgAbdMrQjkuTa5vOIYJT9e+wjzNWdyzDxYApEUrcqGpdh9nJEoNk9
         8J0gmZSLnPwgQADdDoDvNslFwMT0Ersa1rCe9NbYYGySFdX/B4PJBbbTxBVYyeP1Dv
         Yw2KkbDbn1LKM0shWrlJbIrGHiBrRyOm9XFN/7ktEqeHg689RFS1YFvMq+IU5dqbMT
         swbiMXozYIrI9okM9mK015S4O13Fwi42EL2lEMe8rVxcINx42xFsb83Nzive+RfZgc
         UcUdGq9ved+WRRp0VrggskNPmo563Y04NMt4i7lo4kCSBBZ/GQl9Pjka344l/IANJA
         wOxUGMMCFtcQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29FC2F0383D;
        Mon, 25 Apr 2022 09:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] ipvs: correctly print the memory size of
 ip_vs_conn_tab
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088021316.12536.3526307693945776005.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 09:50:13 +0000
References: <20220425091631.109320-2-pablo@netfilter.org>
In-Reply-To: <20220425091631.109320-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 25 Apr 2022 11:16:28 +0200 you wrote:
> From: Pengcheng Yang <yangpc@wangsu.com>
> 
> The memory size of ip_vs_conn_tab changed after we use hlist
> instead of list.
> 
> Fixes: 731109e78415 ("ipvs: use hlist instead of list")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Acked-by: Julian Anastasov <ja@ssi.bg>
> Acked-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/4] ipvs: correctly print the memory size of ip_vs_conn_tab
    https://git.kernel.org/netdev/net/c/eba1a872cb73
  - [net,2/4] netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion
    https://git.kernel.org/netdev/net/c/babc3dc9524f
  - [net,3/4] netfilter: flowtable: Remove the empty file
    https://git.kernel.org/netdev/net/c/b9b1e0da5800
  - [net,4/4] netfilter: Update ip6_route_me_harder to consider L3 domain
    https://git.kernel.org/netdev/net/c/8ddffdb9442a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


