Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543604AAEF4
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 12:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiBFLKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 06:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiBFLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 06:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4910C043181
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 03:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36993B80DAD
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBB38C340ED;
        Sun,  6 Feb 2022 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644145808;
        bh=HG96MKwpUCV2rPs4VQKKgWL634qk+MD7j8GbAdlkhJo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VsPsTXx9xf2EFQK50E7WE3veNBkVa40R7BDFZU8I7lCqyyrkkb0kZi70rgdx3MPV1
         VGsVrbcqR08HAkLcsMDATvxV3Qe4p/Hs5zDWdBs8NhgpP+0X4DO73sPoFUGjgYikV9
         ZLdWZUS2m9JvzigLIzaLkbw275wtPQqSakN9gEB1/JeZ+NgPSdQCsN/ZomJc1EQ+1X
         FYPruaiNHgTznq0gojfRyEbionqURQughPz+D6u2sczw1uTSJQIP1B0+zsB9IzwKLz
         lIQNxW3TsfszL+dKTGFZhg8gWkL57UhxaV0GmtJwecmDH5LZqjsY7tMMLOCooXQjZY
         dIe5BChQ0yIBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C621AC6D4EA;
        Sun,  6 Feb 2022 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fix ref_tracker issue in smc_pnet_add()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164414580880.29882.2248402638653192895.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Feb 2022 11:10:08 +0000
References: <20220206050516.23178-1-eric.dumazet@gmail.com>
In-Reply-To: <20220206050516.23178-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Feb 2022 21:05:16 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I added the netdev_tracker_alloc() right after ndev was
> stored into the newly allocated object:
> 
>   new_pe->ndev = ndev;
>   if (ndev)
>       netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix ref_tracker issue in smc_pnet_add()
    https://git.kernel.org/netdev/net/c/28f922213886

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


