Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABED5518AD
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241942AbiFTMUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiFTMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B116E6338;
        Mon, 20 Jun 2022 05:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67088B81135;
        Mon, 20 Jun 2022 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 280BFC341C5;
        Mon, 20 Jun 2022 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655727613;
        bh=zjVOB6kM2wihsUjBetCJRtUNGfaeBSmEzTkKTvIXmT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Idg/O/Mr1PnYu7OsKdJU4nB2bnNmRb22DDMhF6lWNSESnJbN2Q9CrShIGQtitORL9
         LPU7kAVJNhyCEjU2rffJUIOvOAY/HdlhD2Jv7hECy3P+GnaO7XOYGXWyQYrMMBEtcn
         M6aDA0CbbATtO44esd5OjAbd9ujtXGbVPxKSbozybEVY/+OGu2T//7o+343wpxP7Pd
         M8HcxEDJcAyGQyevpUO1snToTSbrVtL5kEUyaS8VwMOjHzFvEZFwZGdQRhBmsgSwIO
         jCm8GVGLsMvyY4xb/yFyjFIlHcBqLCfvXi4mzteTbAB3lKyu7DrSZovhsh8+N9LyDw
         nIG8IAwQiPC3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10EB2E73877;
        Mon, 20 Jun 2022 12:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Enable config options needed for
 xdp_synproxy test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165572761306.11702.15473931034357960963.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 12:20:13 +0000
References: <20220620104939.4094104-1-maximmi@nvidia.com>
In-Reply-To: <20220620104939.4094104-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, shuah@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        alexei.starovoitov@gmail.com
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 20 Jun 2022 13:49:39 +0300 you wrote:
> This commit adds the kernel config options needed to run the recently
> added xdp_synproxy test. Users without these options will hit errors
> like this:
> 
> test_synproxy:FAIL:iptables -t raw -I PREROUTING         -i tmp1 -p
> tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 256
> (errno 22)
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Enable config options needed for xdp_synproxy test
    https://git.kernel.org/bpf/bpf-next/c/e068c0776b0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


