Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DC44DDC2E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 15:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiCROvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 10:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbiCROvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 10:51:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9E6261B;
        Fri, 18 Mar 2022 07:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A49B82249;
        Fri, 18 Mar 2022 14:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 585D8C340F0;
        Fri, 18 Mar 2022 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647615011;
        bh=yWXMetl2MEFpfElplCYy9ZzL//mDSljQXhoM6bwnrHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S2c5l0I+LirlDTsHHew0DRaDY9oUzTSRBGRnXzQDYztmGNmYEb7dKQi2/hGf20tZg
         N86Fe1PP9EYqvr6q3wxMGRhaFfn6fZIUP33VlnqRurtkKRQo/IAxl/+RRSs/VYxhVq
         g5dN8xdgkZV9A/LJFvGoN3cRjPY3U1H7I8RAGfikEUoBt9ZYVyoaiM5AYcYgVxzJnv
         0GsDuIcIfE+nP+dYxcVakH63oofc2oQrr8mW1MrIO6OzdZ5BKj2UM/rX3riGcL60fU
         AO8TIZs8svuJ4hcoA8ZdH1hKkYSWK85H0y+Q0bSSgG2ZC/pP2Cy29qwUKwbyyOkDyz
         b7ikS11zD/GLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BF15E6D402;
        Fri, 18 Mar 2022 14:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/4] Fixes for sock_fields selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164761501123.8704.15272087037506805370.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 14:50:11 +0000
References: <20220317113920.1068535-1-jakub@cloudflare.com>
In-Reply-To: <20220317113920.1068535-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@cloudflare.com, iii@linux.ibm.com, kafai@fb.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 17 Mar 2022 12:39:16 +0100 you wrote:
> I think we have reached a consensus [1] on how the test for the 4-byte load from
> bpf_sock->dst_port and bpf_sk_lookup->remote_port should look, so here goes v3.
> 
> I will submit a separate set of patches for bpf_sk_lookup->remote_port tests.
> 
> 
> This series has been tested on x86_64 and s390 on top of recent bpf-next -
> ad13baf45691 ("selftests/bpf: Test subprog jit when toggle bpf_jit_harden
> repeatedly").
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/4] selftests/bpf: Fix error reporting from sock_fields programs
    https://git.kernel.org/bpf/bpf-next/c/a4c9fe0ed4a1
  - [bpf-next,v3,2/4] selftests/bpf: Check dst_port only on the client socket
    https://git.kernel.org/bpf/bpf-next/c/2d2202ba858c
  - [bpf-next,v3,3/4] selftests/bpf: Use constants for socket states in sock_fields test
    https://git.kernel.org/bpf/bpf-next/c/e06b5bbcf3f1
  - [bpf-next,v3,4/4] selftests/bpf: Fix test for 4-byte load from dst_port on big-endian
    https://git.kernel.org/bpf/bpf-next/c/deb594004644

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


