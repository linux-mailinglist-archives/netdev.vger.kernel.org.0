Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C5515D2B
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381387AbiD3NDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiD3NDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BE7A1AF
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 06:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D59360C14
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF9FEC385AA;
        Sat, 30 Apr 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651323612;
        bh=xjBqPQ2XtCKizwdj1H8HP4WnikN/z2gfWCu0c43uaCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bDc6KJwJzQXrlCDosYdu9YOOAvnpep6vdW+zDTkR29CCVjV68hcbCvwayiizBTQ+Z
         Qq6wyce2BS6u8uJ5JGnk9oyrmJ+rUf+CzT72x7U1Ro4KSfEyWir36citBLN+kmcXa4
         Yphv41Z1+aQEprDu/FOEA+qiwPP7MKalta08knIUpn848230cMTvvsv3i/EGdnYXUL
         G6+5meJ9tna2CJX42Fg7MXKA29gBQIq+Wz2UyofQSuvLu/qQiUA2Yhe9DSHBDx/dz+
         8+Ya08kKiuivrVOpWry7bKRBwhWwUjOXqhToqcLofGKTyc1oRXDfs/Bv7SZM+ksa4t
         jJ2iIT53pssow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF0ECE8DBDA;
        Sat, 30 Apr 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: use tcp_skb_sent_after() instead in RACK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132361177.2405.2829418638153494256.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 13:00:11 +0000
References: <1651228376-10737-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1651228376-10737-1-git-send-email-yangpc@wangsu.com>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     edumazet@google.com, ncardwell@google.com, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 18:32:56 +0800 you wrote:
> This patch doesn't change any functionality.
> 
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  net/ipv4/tcp_recovery.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] tcp: use tcp_skb_sent_after() instead in RACK
    https://git.kernel.org/netdev/net-next/c/5a8ad1ce2c60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


