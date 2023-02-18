Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC1569B795
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjBRBu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBRBuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4B56B32B
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B42C620B2
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0D0BC4339B;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676685017;
        bh=l8Q6ueaJN+QLhaVsmHKxWjGrQUEqPUUHKyUEIhNmPx8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZPYf6q32df71wZmX9MIcLe+7MB5Yrb4Vs8/gSUKLLn6FmMEU2Mv0onpL/iVQxneQ5
         gjOyeXqmnL79J88gJ12teuJmUTEYu+cQGMKiNMTJQxNNjZlR0DR8yuP8Wbsq/fJ17X
         7LxbbjdgAL1TaYvcP0C5P0PSMPTa3mxbyANj49Qi2x3J4CT9Gz+q4X+BusuX6PWZGl
         mPFwasDKL74Xa20oKss1+JTExKCmAsy5gO2XCHUvyMY0VBoEzaJeLV5ICgLL6iW4Un
         kg/efw+jchGaT31jndLkgkiDbvYKupT2NTEC2f8VFal06TXVZu3TbnkbBWENRAoTHO
         4Pp+hANwALv9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B40C1E21ED0;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] testsuite: fix testsuite build failure when iproute build
 without libcap-devel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167668501772.31159.343315170092712702.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 01:50:17 +0000
References: <20230210084531.98534-1-gaoxingwang1@huawei.com>
In-Reply-To: <20230210084531.98534-1-gaoxingwang1@huawei.com>
To:     gaoxingwang <gaoxingwang1@huawei.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, dsahern@kernel.org, liaichun@huawei.com,
        yanan@huawei.com
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

On Fri, 10 Feb 2023 16:45:31 +0800 you wrote:
> iproute allows to build without libcap.The testsuite will fail to
> compile when libcap dose not exists.It was required in 6d68d7f85d.
> 
> Fixes: 6d68d7f85d ("testsuite: fix build failure")
> Signed-off-by: gaoxingwang <gaoxingwang1@huawei.com>
> ---
>  testsuite/tools/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Here is the summary with links:
  - testsuite: fix testsuite build failure when iproute build without libcap-devel
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c0a06885b944

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


