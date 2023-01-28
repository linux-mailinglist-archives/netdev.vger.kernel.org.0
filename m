Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B6267F672
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbjA1Ikw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbjA1Ikt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475D9908D5
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 00:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD03B81239
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97EDAC4339B;
        Sat, 28 Jan 2023 08:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895231;
        bh=fEhyk81SDnYWxOo+fwtvOfwberNeKTh/9PPm1JgzvTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W6s6bThjkRHBMCF5NIMBZLg8MHuAGSLLCrOsrA1iz7czb13QXCyYo0e11YkGivM12
         jxyk9pxOpplhwHhGs/efZfvjXHixD5aRG6pITUc2Tqze9FlrFvB8jnEYhDRG5exTdQ
         1pT+2oglHSZfNz13+eQ3v/dn6MeVmF3HbWi2WSJxqISQ3RhXE/eGRCgfrgtTn/8hAi
         VCupzKji6g6VIxjBWtiADyaK9MnQtSD5Dq/SYddRQRJGtOr2K6YnJ+h28R02MJkHgo
         +vDETcEcx8lXYaDII4pkV59xcaLKaGHcKAs7vabDgGgJUfdyDOEU2SWCkCbLQvVhLN
         MJtjm4wzjkbdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86CA9E54D2D;
        Sat, 28 Jan 2023 08:40:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: netlink: recommend policy range validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489523154.20245.2288032415564432661.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:31 +0000
References: <20230127084506.09f280619d64.I5dece85f06efa8ab0f474ca77df9e26d3553d4ab@changeid>
In-Reply-To: <20230127084506.09f280619d64.I5dece85f06efa8ab0f474ca77df9e26d3553d4ab@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com
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

On Fri, 27 Jan 2023 08:45:06 +0100 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For large ranges (outside of s16) the documentation currently
> recommends open-coding the validation, but it's better to use
> the NLA_POLICY_FULL_RANGE() or NLA_POLICY_FULL_RANGE_SIGNED()
> policy validation instead; recommend that.
> 
> [...]

Here is the summary with links:
  - [net-next] net: netlink: recommend policy range validation
    https://git.kernel.org/netdev/net-next/c/70eb3911d80f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


