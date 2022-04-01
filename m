Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF0E4EEBEB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiDALCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345271AbiDALCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB27EBADF
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51AF1B8247F
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E215AC340F3;
        Fri,  1 Apr 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648810812;
        bh=PjMuQG0pVFct7Dtiv6zrF6B7XB0E/PaKOjhWG6e1ykU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kXJqXqtFw7wHWKucDxKfsQF6W09rt0OhkD6aCm7qqzY4RBlP/8UOe5Gz5NnKtwffl
         KNhFW94iKbLz/ozYOSPefIiPoyNskhIGZWTsXgSetmKvdlXd6vT9UQ+tPjUyHlXcud
         +aYIY8Znfgso4Nsx8FAhulHV/a9uYG4g7R2xIiz1hilK+FxDz3Rbgzx+7pKbw8EEKr
         FhgzK8Ixzn7/U7LIISxqSICteOM6sxMDLmSJ/PHlfc3OF8Z/YiV+ptemyh9qwkcG0U
         JBBRkaIOpEktrgvW8zTHFMTCnSYEGVZCqQS91p7/JVd29XGIm9iJM1RWuqRwyHLtd9
         fAwXwzYDQdOng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6ECAF03849;
        Fri,  1 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: dsa: stop updating master MTU from master.c"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881081181.13357.16351916518973273003.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:00:11 +0000
References: <20220331132854.1395040-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220331132854.1395040-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, luizluca@gmail.com
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

On Thu, 31 Mar 2022 16:28:54 +0300 you wrote:
> This reverts commit a1ff94c2973c43bc1e2677ac63ebb15b1d1ff846.
> 
> Switch drivers that don't implement ->port_change_mtu() will cause the
> DSA master to remain with an MTU of 1500, since we've deleted the other
> code path. In turn, this causes a regression for those systems, where
> MTU-sized traffic can no longer be terminated.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: dsa: stop updating master MTU from master.c"
    https://git.kernel.org/netdev/net/c/066dfc429040

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


