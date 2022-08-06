Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C06D58B34F
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiHFCAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbiHFCAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F9510E3
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 19:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BED6615B1
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBFF8C43470;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751215;
        bh=mXcS8acaxqdoKQURNUS2TFICAQuECPGcMxxHOW9MJMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOyy75HBnHLuaU/UlcG1AHblq48ynEa4KfaMDvC4rGRwumQTL0Ck8ZK1c/E5mnOxv
         1zWvvOS6srMZ6H7ae8jkIQtOP8uTUAVgsn/VUCiwqAQ9PzI6HBMic4SoRFoOGZEf4o
         pA8m1AJZUwFHoqpNRsZ+PLWE/25zF7yIgWw7wz5pJVh8a4K4SHwiWT+g1vSzwcHayg
         AFVQBQ7bjIE9likeseuxU33LwXbk7r/MSurDYUxiFot4kT6QmmUch9/Hv0IbEanNbj
         j465Ze0GTSs+OwfhtOPHUbWb/PoyxdcF3bFp0hpW5awduR4QDGYxkjEALu5PUlgASc
         XV385+akkR6HA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C13F0C43143;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] netfilter followup fixes for net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975121578.22545.985329893402476282.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:00:15 +0000
References: <20220804172629.29748-1-fw@strlen.de>
In-Reply-To: <20220804172629.29748-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Aug 2022 19:26:26 +0200 you wrote:
> Regressions, since 5.19:
> Fix crash when packet tracing is enabled via 'meta nftrace set 1' rule.
> Also comes with a test case.
> 
> Regressions, this cycle:
> Fix Kconfig dependency for the flowtable /proc interface, we want this
> to be off by default.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: fix crash when nf_trace is enabled
    https://git.kernel.org/netdev/net/c/399a14ec7993
  - [net,2/3] selftests: netfilter: add test case for nf trace infrastructure
    https://git.kernel.org/netdev/net/c/fe9e420defab
  - [net,3/3] netfilter: flowtable: fix incorrect Kconfig dependencies
    https://git.kernel.org/netdev/net/c/b06ada6df9cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


