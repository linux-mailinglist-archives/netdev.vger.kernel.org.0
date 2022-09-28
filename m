Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AB55ED296
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiI1BUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiI1BUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74215915E6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C365E61940
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37575C433B5;
        Wed, 28 Sep 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664328015;
        bh=qO3uxLl0EI6yYrOJqwsQTaTa0Qs5ia/OjUUigCJl0GY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eFcV7vZVpE6JVpVZ5I6mb26o3Onp1UeyqqW/RyzZTLHVAbrmPOujArp5xy/i67yIf
         DvD2xX18H/fxYJJbYv+YeGT+4Wj4wgexoLUPWZQaiDN7HixHaI5D6sApEbi2GfQay0
         n4rr8YXsuZPyl5ncFxnLi1lzOOebp5lCwoFYZvkkN8hdo0F+JPsSXkAKs35KUWEhul
         7yHfVrWdi+ziHLd71dp0DJWSsJx7TifdJFTGMGAHV39Xjy9BLqSOw1ZI2gw2yPUzNB
         BYw0464UcgFF31ugJ4awW5EXUkgmiCZMDqcOUiSm+w66fYT5wxheD4x+5ERo+LqKs5
         NRSaA511XqZsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1600FC04E59;
        Wed, 28 Sep 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Add skb drop reasons to IPv6 UDP receive path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166432801508.13787.14798449836996046756.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 01:20:15 +0000
References: <20220926120350.14928-1-donald.hunter@gmail.com>
In-Reply-To: <20220926120350.14928-1-donald.hunter@gmail.com>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, donald.hunter@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Sep 2022 13:03:50 +0100 you wrote:
> From: Donald Hunter <donald.hunter@redhat.com>
> 
> Enumerate the skb drop reasons in the receive path for IPv6 UDP packets.
> 
> Signed-off-by: Donald Hunter <donald.hunter@redhat.com>
> ---
>  net/ipv6/udp.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] Add skb drop reasons to IPv6 UDP receive path
    https://git.kernel.org/netdev/net-next/c/0d92efdee915

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


