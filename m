Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD37D5F0B61
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiI3MKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiI3MKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D46C92F5D;
        Fri, 30 Sep 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96B2462316;
        Fri, 30 Sep 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9A24C4347C;
        Fri, 30 Sep 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664539818;
        bh=5+K5jRYlKamI06rr/prbf9Ud5IAol4K/+qbbTh0jG9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RQvp7P9puC8HLu8L+rJDEsYV45Ry2u+vO89AHvjCShyDqa6bJ50fEYMQ0M3AY1qoc
         VMWz/iIXEkG+7mpMSXUQJu5YXXmFFYTBNshobmD/68iofT2edtqePCbi8GNXCPgurM
         Ct6iafn2oHNozazjW+dhXCiMg2FgQuFiBzYwj2ke5c13LuqTrTooY+rpc+xobU8EAR
         lu09aKsQa1FXgRsU+5wI1a76Nf6i/Lwn2dipzY+VslChkmQDpWeAFSS9UqpMjw8ylt
         7NZuSg2IwVNjM2gFICglkK88lrPDyGmvKd5e4Yv8XmaNDzIcu9iUPkF0uVs5VotARB
         YWcfAEnlVO51Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C51B8E49FA8;
        Fri, 30 Sep 2022 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bna: Fix spelling mistake "muliple" -> "multiple"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453981780.22292.12847094037826786353.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 12:10:17 +0000
References: <20220928215439.65962-1-colin.i.king@gmail.com>
In-Reply-To: <20220928215439.65962-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 28 Sep 2022 22:54:39 +0100 you wrote:
> There is a spelling mistake in a literal string in the array
> bnad_net_stats_strings. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/brocade/bna/bnad_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: bna: Fix spelling mistake "muliple" -> "multiple"
    https://git.kernel.org/netdev/net-next/c/3b882a7bf6cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


