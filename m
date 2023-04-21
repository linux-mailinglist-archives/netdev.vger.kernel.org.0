Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A981F6EB1DA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjDUSuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbjDUSuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AC9188;
        Fri, 21 Apr 2023 11:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84AA6121F;
        Fri, 21 Apr 2023 18:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B6AAC4339C;
        Fri, 21 Apr 2023 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682103022;
        bh=wW6FpQBZO+RBv8nOuI4HJtweleHUtWILRUnILBC8S5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=juhtV/muRJQhrv+i6LwFjLud8C/mVuBUicXmV1FTBGBww3irxYuCFu5Sb84qbTBWz
         Mj7+WbfkY69w1W/pHlMaukv6ad3xNG8yAVTCPVidkHy2WZXzxkyJeWxCyYqUhUbgdr
         ZAmPH4/YH7AjQKLmHdax5NIlKoFIPw1V0GMs4O598pQjv38+ZViZskfSP/A305ztVK
         43BEYv8T/EMgJjYDWWiU4laltffZNGFI4+VhfRulOX2xiTjkSn9hjF4nBN33zrPJOO
         nEbV4V8qXelVLqVjQgkpTOAdUoqDPkHZ12FotEm/NsHOs+tINgWDZf7m7uZftoa+aQ
         1YyGnXdfKDJPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAA18E270DA;
        Fri, 21 Apr 2023 18:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 0/7] bpf: add netfilter program type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168210302187.11240.7792947856131351121.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 18:50:21 +0000
References: <20230421170300.24115-1-fw@strlen.de>
In-Reply-To: <20230421170300.24115-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 21 Apr 2023 19:02:53 +0200 you wrote:
> Changes since last version:
> - rework test case in last patch wrt. ctx->skb dereference etc (Alexei)
> - pacify bpf ci tests, netfilter program type missed string translation
>   in libbpf helper.
> 
> This still uses runtime btf walk rather than extending
> the btf trace array as Alexei suggested, I would do this later (or someone else can).
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/7] bpf: add bpf_link support for BPF_NETFILTER programs
    https://git.kernel.org/bpf/bpf-next/c/84601d6ee68a
  - [bpf-next,v5,2/7] bpf: minimal support for programs hooked into netfilter framework
    https://git.kernel.org/bpf/bpf-next/c/fd9c663b9ad6
  - [bpf-next,v5,3/7] netfilter: nfnetlink hook: dump bpf prog id
    https://git.kernel.org/bpf/bpf-next/c/506a74db7e01
  - [bpf-next,v5,4/7] netfilter: disallow bpf hook attachment at same priority
    https://git.kernel.org/bpf/bpf-next/c/0bdc6da88f5b
  - [bpf-next,v5,5/7] tools: bpftool: print netfilter link info
    (no matching commit)
  - [bpf-next,v5,6/7] bpf: add test_run support for netfilter program type
    https://git.kernel.org/bpf/bpf-next/c/2b99ef22e0d2
  - [bpf-next,v5,7/7] selftests/bpf: add missing netfilter return value and ctx access tests
    https://git.kernel.org/bpf/bpf-next/c/006c0e44ed92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


