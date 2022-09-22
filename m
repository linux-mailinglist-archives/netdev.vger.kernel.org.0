Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEF5E5808
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiIVBaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiIVBaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0781C9E8AB
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BC162DE2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF5F9C433B5;
        Thu, 22 Sep 2022 01:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810216;
        bh=lXMPMA8XN4asNSgBob3VA41ZPhMqAC+GDVyY7Sfij7s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k6pHEA6GvXioO9102ebVLaHuyvfG/GnixEvTIao509nH5V8hCS6m5v8ocV0o2Bk1I
         q4aHvdewFBDiraczzDULjE1/sJ8foRpNoIS0RAdVwNHUe0Cwy8bo7WvfTwadK503/3
         8nKn4JoJt1Sad/CiEcZd6FWB1vSs9Vh4k2gWgatswEsSBc7aiqw/0PSeHjMMCaigUA
         I2BRkEWL4kTRrYXzVkqA0f7X4ibm2TWBJDFwtdO+H3fMoH+bUAbXHhnowIhJ6eF6Mt
         aeIIwK+EVtoRSNDYsNodygFLxXmXg8hpMD3xYcdT1icfVoBU882hvO22kYUuzssWJC
         x+5onLfQ9qrSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D605AE4D03C;
        Thu, 22 Sep 2022 01:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macvtap: add __init/__exit annotations to module
 init/exit funcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381021587.720.18175433183770628522.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:30:15 +0000
References: <20220917083535.20040-1-xiujianfeng@huawei.com>
In-Reply-To: <20220917083535.20040-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
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

On Sat, 17 Sep 2022 16:35:35 +0800 you wrote:
> Add missing __init/__exit annotations to module init/exit funcs.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  drivers/net/macvtap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: macvtap: add __init/__exit annotations to module init/exit funcs
    https://git.kernel.org/netdev/net-next/c/d57aae2e0563

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


