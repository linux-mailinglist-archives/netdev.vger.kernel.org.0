Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9FF502897
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352537AbiDOLCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349582AbiDOLCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:02:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABEF6C94F;
        Fri, 15 Apr 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AD4EB82E29;
        Fri, 15 Apr 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07A08C385A5;
        Fri, 15 Apr 2022 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650020412;
        bh=g48syiqForTtjSamBy3G6+NgNdihZfaWCdYQFRshKLE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tk8IdF/PapwRvbeRW09wY/whjAyoM/7CNSDnzspFDqdhHJtumsYHMNsjAaZvzc3M/
         6soVnCw4T7FLiinluvyaS3NvDeVBVq7VnKzntoBxdB3FNtl23L3iFWYpjqzbBSQPlK
         jFpxF17lnzRP7ETuydAATiip9tsSgHcnSAqXqcbueGm8JxR7SApABGmXvqpgcY156v
         +4AZ5gX8MjtPiy+9rzQ7g2dlnKjrgIsXhw5QBR+VtRsdQofRuG6/oRwj2jhN74s2au
         atizNxr7Bmh6e/Nq/YSqQLw4swjvYx/GVuhwuzr+7gnDUkSw9YEGDEQm3qmPEfIB2q
         n0buJcuO96Fwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE9A4E8DBD4;
        Fri, 15 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/2] ip6_gre: Avoid updating tunnel->tun_hlen in
 __gre6_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165002041190.31119.6365175002625419813.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 11:00:11 +0000
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649967496.git.peilin.ye@bytedance.com>
In-Reply-To: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649967496.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, peilin.ye@bytedance.com, u9012063@gmail.com,
        cong.wang@bytedance.com, zhoufeng.zf@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Apr 2022 13:34:26 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Do not update tunnel->tun_hlen in data plane code.  Use a local variable
> instead, just like "tunnel_hlen" in net/ipv4/ip_gre.c:gre_fb_xmit().
> 
> Co-developed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
    https://git.kernel.org/netdev/net/c/f40c064e933d
  - [v2,net,2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
    https://git.kernel.org/netdev/net/c/ab198e1d0dd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


