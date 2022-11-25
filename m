Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D26639020
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 20:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKYTAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 14:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKYTAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 14:00:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31F022BE2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 11:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25D70CE2F72
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 19:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53FA5C433C1;
        Fri, 25 Nov 2022 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669402816;
        bh=9GyC/ls2FlOYcleKnFfjRbuo9bM8VVJ0neSQhaJZ0EU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MHqXaYSwGBQIaJzOjENH12Xa0v8REGQUagsx7bC/F6XMHCCImQq3FEIVC4jY6CaVT
         zScrkU4E67LXu7H/lw0Z4k1S0x/GF6wIZYlZd0G8fkOdQPpWgMW1VyoVYTe2dolzE+
         4Yr1dqKNLc8wcJEtbm10BEQFMQqkBg2TWyPwTh2buM2X0vqHiUWFgW9A4UHvAj/Qb0
         k9RbJuq9/7J8PhZLmTRR6sYRTFZ+6rBOFCAiiNBC5y5Vl2WJ4gIfRngxg0YhO+y5ne
         bVDSPxV8EfQAhQvPr6wbCZ6PutGqQApFJ83C1bgJ5xdkT0oziUKVmveBgDvPTsne3X
         j9q8k5vJlGJoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CECBC395EC;
        Fri, 25 Nov 2022 19:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-main REPOST] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166940281624.5064.12531965928739571935.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 19:00:16 +0000
References: <20221125091251.1782079-1-jiri@resnulli.us>
In-Reply-To: <20221125091251.1782079-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 25 Nov 2022 10:12:51 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
> the ifname map to be loaded on demand from ifname_map_lookup(). However,
> it didn't put this on-demand loading into ifname_map_rev_lookup() which
> causes ifname_map_rev_lookup() to return -ENOENT all the time.
> 
> [...]

Here is the summary with links:
  - [iproute2-main,REPOST] devlink: load ifname map on demand from ifname_map_rev_lookup() as well
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=63d84b1fc98d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


