Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB60E517FE2
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 10:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiECInr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 04:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiECInq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 04:43:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA79555B7;
        Tue,  3 May 2022 01:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B30DB81A56;
        Tue,  3 May 2022 08:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E439CC385B0;
        Tue,  3 May 2022 08:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651567212;
        bh=Wr0TRpkyoIJECpGGv+xMmzUUlBKnAieOyCwAFDqHIQo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JIBTBLyu+xZnv37nyu+Tp8F3osr9TJYGLf/+GPp/VYZWcJLW0YVzkQKJnweB+mtT/
         iB+12j7B2ESuTi3JVtkhWDthKyLz/s9PlCf1bKFCJNcsPZb/lNqtMRN+v2gdjm1eta
         KqyrxsPkzzpZWO3kN8dAQ2YK2giNnrMcSyr9zv1BOgVO7VRuyuWgcpPanjAV5NYKm5
         rhLoIk8E5XhRc2QcgBs/KRT5zEh2scsHQm1ANdtCKXGUvf8XfnRSMk/iHBTW9VkeoV
         QH94jgKaYT+esgdkP+akCrFPF9C3PZttH96roZA7NRLpmh5Dxb6QdT2GWs0THZT/8c
         xYEMONM/tY8vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C48A2E6D402;
        Tue,  3 May 2022 08:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/3] use standard sysctl macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165156721180.10948.17020388517829329792.git-patchwork-notify@kernel.org>
Date:   Tue, 03 May 2022 08:40:11 +0000
References: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, horms@verge.net.au,
        ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        shuah@kernel.org, akpm@linux-foundation.org, ast@kernel.org,
        edumazet@google.com, lmb@cloudflare.com, hmukos@yandex-team.ru
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  1 May 2022 11:55:21 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patchset introduce sysctl macro or replace var
> with macro.
> 
> Tonghao Zhang (3):
>   net: sysctl: use shared sysctl macro
>   net: sysctl: introduce sysctl SYSCTL_THREE
>   selftests/sysctl: add sysctl macro test
> 
> [...]

Here is the summary with links:
  - [v5,1/3] net: sysctl: use shared sysctl macro
    https://git.kernel.org/netdev/net-next/c/bd8a53675c0d
  - [v5,2/3] net: sysctl: introduce sysctl SYSCTL_THREE
    https://git.kernel.org/netdev/net-next/c/4c7f24f857c7
  - [v5,3/3] selftests/sysctl: add sysctl macro test
    https://git.kernel.org/netdev/net-next/c/57b19468b369

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


