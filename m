Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51BE54F05B
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 06:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379976AbiFQEkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 00:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiFQEkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 00:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D73764BEB;
        Thu, 16 Jun 2022 21:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4648BB82748;
        Fri, 17 Jun 2022 04:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E508AC3411C;
        Fri, 17 Jun 2022 04:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655440814;
        bh=sEx1t+BRx828IBzL4ndbZFRyANYUPIQCi3bA6dqbKN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rOsh2lLolUhgVEo7SC/4MU3cmJShd8tqK6sO52xSVwvzft4ZkrqzBa9hvyAAF1HBo
         CPV4bpiDim8jTBKJLT1LE2grPzwn6hChI+D/kYoQxbmGoVd4nOyAbouAhGKCMmXUyA
         dGgfuxl7CeZUldYNGjcTdQC8YTQ59f8hDVuXjbWAJa7SQbEfrPvdi5WIExi53h4/c2
         eLWRz0gwwjRDjBNXA4Hab9lKMOXvGQrOf0oMe5jSrTRuYsAen5JFuvAC4/jp1kCAKt
         WsBPoJPJxQM4Iebaid2tTF0SbmPi+KXcWUg6LFDovDdOXvwFaB28j4BMykCbL5p8Hh
         l3KeM3u3XCQiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C829EFD99FF;
        Fri, 17 Jun 2022 04:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v10 0/6] New BPF helpers to accelerate synproxy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165544081381.22504.14558130099478687878.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 04:40:13 +0000
References: <20220615134847.3753567-1-maximmi@nvidia.com>
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org, tariqt@nvidia.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, shuah@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, joe@cilium.io,
        revest@chromium.org, linux-kselftest@vger.kernel.org, toke@toke.dk,
        memxor@gmail.com, fw@strlen.de, pabeni@redhat.com
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 15 Jun 2022 16:48:41 +0300 you wrote:
> The first patch of this series is a documentation fix.
> 
> The second patch allows BPF helpers to accept memory regions of fixed
> size without doing runtime size checks.
> 
> The two next patches add new functionality that allows XDP to
> accelerate iptables synproxy.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v10,1/6] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
    https://git.kernel.org/bpf/bpf-next/c/ac80287a6af9
  - [bpf-next,v10,2/6] bpf: Allow helpers to accept pointers with a fixed size
    https://git.kernel.org/bpf/bpf-next/c/508362ac66b0
  - [bpf-next,v10,3/6] bpf: Add helpers to issue and check SYN cookies in XDP
    https://git.kernel.org/bpf/bpf-next/c/33bf9885040c
  - [bpf-next,v10,4/6] selftests/bpf: Add selftests for raw syncookie helpers
    https://git.kernel.org/bpf/bpf-next/c/fb5cd0ce70d4
  - [bpf-next,v10,5/6] bpf: Allow the new syncookie helpers to work with SKBs
    https://git.kernel.org/bpf/bpf-next/c/9a4cf073866c
  - [bpf-next,v10,6/6] selftests/bpf: Add selftests for raw syncookie helpers in TC mode
    https://git.kernel.org/bpf/bpf-next/c/784d5dc0efc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


