Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B44FF5BA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiDMLcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiDMLcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:32:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C4E3BF96;
        Wed, 13 Apr 2022 04:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECD53B82269;
        Wed, 13 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3256C385B2;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649849412;
        bh=D90fTDZe7BfT4jc2+kLrsrUEFwd8YCdsX7EuK7RNUpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nYT9KO1VTDak1yoZnt3zP9HYLMPe0rcMMmAwQpSrKus/MhOxwIRlwunzAonvayEFt
         9hnGNW9OYvgWl3og00dQhMjJl1KkHVPuKyGF637Hb1GLLagKQwbRZ/vOQwuZWSdIII
         VhEY7SAib00IoC7VhZ4vg4Vx90BCvJtK0iI0731WzDaCvrxbquSuZJnxL8wLa2/NMA
         n+upndbcHlKvpIAsR46+Ues1W06pqyNP1J1+6b4+Yun3+kXOXmpZnjJiw5Xjh4UWpv
         gGIs25/Z/cInvLq9ZwHb6MpEYGm2D/+EPDZk5kHeXYxMR6S+/9Kjj/iwwvicRzGchn
         uv2HuEv6lzU3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8526FE8DD69;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: use after free in
 __mtk_ppe_check_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984941253.14313.10362987652351620258.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:30:12 +0000
References: <20220412092419.GA3865@kili>
In-Reply-To: <20220412092419.GA3865@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kernel-janitors@vger.kernel.org
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

On Tue, 12 Apr 2022 12:24:19 +0300 you wrote:
> The __mtk_foe_entry_clear() function frees "entry" so we have to use
> the _safe() version of hlist_for_each_entry() to prevent a use after
> free.
> 
> Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: use after free in __mtk_ppe_check_skb()
    https://git.kernel.org/netdev/net-next/c/17a5f6a78dc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


