Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C424AA9CF
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 17:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356179AbiBEQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 11:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiBEQAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 11:00:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB61C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 08:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEB5AB80833
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 16:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65132C340EF;
        Sat,  5 Feb 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644076809;
        bh=QAczK8Rs26xHhRR2yDmlHurjFCe3vSh/Ju9VTwRdiv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tHVmWUkG7YlPbp1Rb6uJAuUxpPxogLk2uJ67uzGu2f3kZ+NltLQErwZXzIvdAMYXf
         94o4wkTiQCOEL4vj5Rv1yMQ2M3DbVG9RgCsrf3fyJHwPXtkyrgCTYIMJnZRQ0tsnTI
         +9gndwTK03DyHUSeKCtvJ8ruay29C+3yXWIU4BEclNZZ9wK1zvGdBUO426rcyB55pb
         Lgr3C3Tu8eqPCfwlJzYRDgmIgwHFEkDsMDScGPNpZCXiup4HcsjxVmCZhhoSUITYqR
         thYJgltOYtq6WmaaeocjDyacyw2r/cQ3d99xgzYqDg/JzMdkb8SP8dhgkxw8kHTXBq
         NKuNJzXgX9ADw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A85AE5D07E;
        Sat,  5 Feb 2022 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: typhoon: implement ndo_features_check method
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407680930.4093.15930983192642246114.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 16:00:09 +0000
References: <20220205045459.3457024-1-eric.dumazet@gmail.com>
In-Reply-To: <20220205045459.3457024-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  4 Feb 2022 20:54:59 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Instead of disabling TSO at compile time if MAX_SKB_FRAGS > 32,
> implement ndo_features_check() method for this driver for
> a more dynamic handling.
> 
> If skb has more than 32 frags and is a GSO packet, force
> software segmentation.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: typhoon: implement ndo_features_check method
    https://git.kernel.org/netdev/net-next/c/d2692eee05b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


