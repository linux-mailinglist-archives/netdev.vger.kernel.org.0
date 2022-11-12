Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527EA626745
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiKLGAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiKLGAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6FD16595
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 22:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A83EDB80011
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28C07C433D7;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668232818;
        bh=4BR3NC065tro16SeOVjHpALaYYRH73rjVs5crC8XW2k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jAMFwIZgENHZbs/K9Vuu5bdMCg2vgrsFJoo0oK4ogeZEdslxSRsZF3H7xf8L9BoVG
         O385VzrQA8kCC2Sdunz1/sCKFIrTNXnVxoAMkh52Kk024xFh1cpVf6N+vXlH6WaRfb
         F6QtNLEtMvq2ji2i7kDC9cIiXywTM6W+NaFRZuIAz+maQQDniqaou9IhxoEIiqenvs
         tQh4DaASvttetXlzkZHR25hNXq3j+j0nTr/Ka5qa777we0/4qkNCk8lD28XLSmFV62
         4lhhrTGsBu6MOv1JwNc4yleB/12e/OwF6ePude93MRhR6hXQYNTm3EQrTkDe/jPVp3
         ESJkh1uW3wTmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A34BE270C6;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Miscellaneous refactoring and small fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166823281803.10181.5636774092577244833.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 06:00:18 +0000
References: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 15:23:17 -0800 you wrote:
> Patches 1-3 do some refactoring to more consistently handle sock casts,
> and to remove some duplicate code. No functional changes.
> 
> Patch 4 corrects a variable name in a self test, but does not change
> functionality since the same value gets used due to bash's
> scoping rules.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: use msk instead of mptcp_sk
    https://git.kernel.org/netdev/net-next/c/00df24f19179
  - [net-next,2/5] mptcp: change 'first' as a parameter
    https://git.kernel.org/netdev/net-next/c/73a0052a61f9
  - [net-next,3/5] mptcp: get sk from msk directly
    https://git.kernel.org/netdev/net-next/c/80638684e840
  - [net-next,4/5] selftests: mptcp: use max_time instead of time
    https://git.kernel.org/netdev/net-next/c/31b4e63eb24a
  - [net-next,5/5] mptcp: Fix grammar in a comment
    https://git.kernel.org/netdev/net-next/c/4373bf4b72f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


