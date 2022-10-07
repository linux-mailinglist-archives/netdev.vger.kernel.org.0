Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C545F74FF
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJGIAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJGIAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A14C7075;
        Fri,  7 Oct 2022 01:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD00F61C33;
        Fri,  7 Oct 2022 08:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A049C433C1;
        Fri,  7 Oct 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129615;
        bh=ENn1jEmJ76EBZlgO5yPlS7O6sGItx6ygrrCPF7KEtUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aMiXpfH8Xw5KgQ0PJdNGjYgWx10iZm/T20VgBNmFWMf0s1zfykjiWibkdZpSZseul
         rBLhgb1oux9GtFfZGZkXySIRTCbAbGJRiFN6RvW/j1bU9uWdyHdWebajZNMptsI/Dm
         90hPjuyuSL5bbFcD1yev/iRS4LME/sKKqnEmpqFxbCQbWgTunNHIOAL+9DBCSHurbd
         nLCUwxTXAjuFc2/vOJaRvPUMm1EO6r/ylIOb4fjVREg6oP7nM2YVDjq7UYbx9kWXeH
         BWh63YBUGZHzxyKc0qQ4rX5UMaw84wcp3J73AAMq1EBHIDbPj5Selw90fpQvbv8rAH
         zp/gBnmv2uo9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25131E2A05C;
        Fri,  7 Oct 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: bgmac: Remove -Warray-bounds exception
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512961514.5723.15285971460994022260.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 08:00:15 +0000
References: <20221006192053.1742965-1-keescook@chromium.org>
In-Reply-To: <20221006192053.1742965-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Oct 2022 12:20:53 -0700 you wrote:
> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=shift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
> 
> Remove the local work-around.
> 
> [...]

Here is the summary with links:
  - net: ethernet: bgmac: Remove -Warray-bounds exception
    https://git.kernel.org/netdev/net/c/aabf6155dfb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


