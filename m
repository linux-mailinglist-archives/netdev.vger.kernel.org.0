Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8944D532A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbiCJUlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245009AbiCJUlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:41:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDE115961
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78CF0617CB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D855CC340F9;
        Thu, 10 Mar 2022 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646944812;
        bh=MMhOyu6tnd7hTfAwk4IsBSsp0bwfdLqL5RHOQF14ZlE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VOeeTbfMlOScquX1kfxepFCZXIsXT0Q6t88BSBx6kVv/+tEIulyeM/3lKbks4IHXC
         VIzHKTXZ0/r7kl1b2TBBSxpyg2eU5ROkRvZtnVb56+0AiCxD23VqurNGhdC7q55GgV
         W2SkRKjv6KdvoQm07mvSw4jFdLCG7/zCQzg4ve2dP0cqDPge98vyAczhzu6A6zortj
         1KzOY+gG/46R94Vz6BCM5A+Vs9zsfqASskcnqZS7/fMF/hrdYzYIBOQFc9QgwPq1ba
         PjCjFIJuPjguIOFCrWWZg0EI9YOufMMphMYdodVVNDUsph5cSqhLz30etv5cKw+gWd
         TLi5IfxN5xkDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5007F0383E;
        Thu, 10 Mar 2022 20:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mptcp: selftests: Refactor join tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164694481280.30429.14970887623860574958.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 20:40:12 +0000
References: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 11:16:26 -0800 you wrote:
> The mptcp_join.sh selftest is the largest and most complex self test for
> MPTCP, and it is frequently used by MPTCP developers to reproduce bugs
> and verify fixes. As it grew in size and execution time, it became more
> cumbersome to use.
> 
> These changes do some much-needed cleanup, and add developer-friendly
> features to make it easier to see failures and run a subset of the tests
> when verifying fixes.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] selftests: mptcp: drop msg argument of chk_csum_nr
    https://git.kernel.org/netdev/net-next/c/3c082695e78b
  - [net-next,02/10] selftests: mptcp: join: define tests groups once
    https://git.kernel.org/netdev/net-next/c/3afd0280e7d3
  - [net-next,03/10] selftests: mptcp: join: reset failing links
    https://git.kernel.org/netdev/net-next/c/e59300ce3ff8
  - [net-next,04/10] selftests: mptcp: join: option to execute specific tests
    https://git.kernel.org/netdev/net-next/c/ae7bd9ccecc3
  - [net-next,05/10] selftests: mptcp: join: alt. to exec specific tests
    https://git.kernel.org/netdev/net-next/c/c7d49c033de0
  - [net-next,06/10] selftests: mptcp: join: list failure at the end
    https://git.kernel.org/netdev/net-next/c/39aab88242a8
  - [net-next,07/10] selftests: mptcp: join: helper to filter TCP
    https://git.kernel.org/netdev/net-next/c/3469d72f135a
  - [net-next,08/10] selftests: mptcp: join: clarify local/global vars
    https://git.kernel.org/netdev/net-next/c/1e777bd818bd
  - [net-next,09/10] selftests: mptcp: join: avoid backquotes
    https://git.kernel.org/netdev/net-next/c/4bfadd7120a1
  - [net-next,10/10] selftests: mptcp: join: make it shellcheck compliant
    https://git.kernel.org/netdev/net-next/c/d8d083020530

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


