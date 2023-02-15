Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA8469817C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBORAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjBORAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C03241DF;
        Wed, 15 Feb 2023 09:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53EECB8231B;
        Wed, 15 Feb 2023 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BC55C433D2;
        Wed, 15 Feb 2023 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676480418;
        bh=swbd+wZUA66xVOo9xKlE443jq9ex+Gys+6KhRlJqZBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EtzSrpBPbp+TY99B9YQu2xY9ptF67ynHK3g0L4v++0qlT4fbSsXEqKrA083ajpvfr
         PoS43+2opnUQgDE67eO+784/7YMRpz99/UiJuccjTqD012CEYOJLX9CPWHo33RGZe/
         lDFQgxorNEOU6yko7CE1Rs5xg7TkcsYEe/UwE3t3pO/Uoeld3joSl0SUFo9uPyamKw
         jsQn0BE25cNFsS8GI6BUGWnbZ7jCrlu/adQDqOSSc1cn7TRwHRVQrEax1GGhyApM3r
         RUviKTVHoAB2D4fSvCglLkmBkqgy1XLjFWs5wNa8WpXg+ykdeTsdTneIvhDevpNUGQ
         HSKHWwVUY9UGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7B4CC41677;
        Wed, 15 Feb 2023 17:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Cross-compile bpftool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167648041794.12108.7209836979212211534.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 17:00:17 +0000
References: <20230214161253.183458-1-bjorn@kernel.org>
In-Reply-To: <20230214161253.183458-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn@rivosinc.com,
        jean-philippe@linaro.org, zachary.leaf@arm.com,
        quentin@isovalent.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 14 Feb 2023 17:12:53 +0100 you wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> When the BPF selftests are cross-compiled, only the a host version of
> bpftool is built. This version of bpftool is used on the host-side to
> generate various intermediates, e.g., skeletons.
> 
> The test runners are also using bpftool, so the Makefile will symlink
> bpftool from the selftest/bpf root, where the test runners will look
> the tool:
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: Cross-compile bpftool
    https://git.kernel.org/bpf/bpf-next/c/5e53e5c7edc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


