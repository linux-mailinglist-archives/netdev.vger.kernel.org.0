Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872264D4081
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiCJFBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiCJFBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D7E12D912;
        Wed,  9 Mar 2022 21:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A8E2B824CA;
        Thu, 10 Mar 2022 05:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15DBFC340F5;
        Thu, 10 Mar 2022 05:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646888411;
        bh=FUCafaSQYsW9Ri+24aru4nd/M6+KGOCDKqiSyFUwqwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YwCrnVvDZ0fSoP1wRMtPUTWtHR/PkRerivDKrdRCKJQz1Nj4ZcSq+AMMxEnBvd4p9
         pNnBjkHWsz2pqRLyGRo4oQR0CLVPlDP4jJ4bOW1PwADDEFjIdV5MCf5rdg/b5jCr5n
         H+FG1BrmKLQQbmRi2HC8k86u7Q/HKllMM7nButHqx0Ro0lwabRsk4x8v7c3YDTcyRa
         tK32rL/dwwowJPBJVA3ZaVqBzShG4VzoCCK9xf7FcLCQisU1T7RkIb8CqFWADCAW6u
         8UuP4K324wrSCPEeDPWyfD3KvHPyUn+1KNVdoFb+qp5CW24drmr19RZFzv/Lx8clsx
         KQ/AMgxtVwptA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE61CEAC095;
        Thu, 10 Mar 2022 05:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] selftests: pmtu.sh: Fix cleanup of processes
 launched in subshell.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688841097.28597.13633737666030841874.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 05:00:10 +0000
References: <cover.1646776561.git.gnault@redhat.com>
In-Reply-To: <cover.1646776561.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@gmail.com, vfedorenko@novek.ru, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 8 Mar 2022 23:14:57 +0100 you wrote:
> Depending on the options used, pmtu.sh may launch tcpdump and nettest
> processes in the background. However it fails to clean them up after
> the tests complete.
> 
> Patch 1 allows the cleanup() function to read the list of PIDs launched
> by the tests.
> Patch 2 fixes the way the nettest PIDs are retrieved.
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
    https://git.kernel.org/netdev/net/c/18dfc667550f
  - [net,2/2] selftests: pmtu.sh: Kill nettest processes launched in subshell.
    https://git.kernel.org/netdev/net/c/94a4a4fe4c69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


