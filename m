Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D221C6668ED
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 03:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbjALCan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 21:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjALCae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 21:30:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0434A3D9DC;
        Wed, 11 Jan 2023 18:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61707B81DAB;
        Thu, 12 Jan 2023 02:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDCA6C433EF;
        Thu, 12 Jan 2023 02:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673490626;
        bh=w2IwsGN0o3LLtYByqFZPHgmCpcA2+aIo6UWPI7ZDCLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nybjHTRU6F+cAyj0d+mT5bpEpf8Ib8P6tQxsUYb1++uz6gPb2J+dYwiHkYTJVR8Md
         uaK7YZR0kmAKdp2trM4QoC4cBL+XxHr+GKHnFYGEdP631s+D+RIj8RcoY5VHm8Eo+K
         WhhXNoy6UKdthL9fj918KqNLPI2MpV8TaTMllN9CC2uIFx4+pUvAqfLokv9MtOkYUc
         rm4U0/efwnWEAKsRkXfEDnA648aG+ljz8F0S5K1iFpNEgvYdcmfArkqdfdnAITtNDS
         t9ngw6jys7qTmJ6Cqo/nRhRUyg0JaliJu075k9nXZ0EFeOgJu75FjPo6momU/WLQyL
         q+X82mFxgSRYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEA02E45233;
        Thu, 12 Jan 2023 02:30:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 00/15] selftests/xsk: speed-ups, fixes,
 and new XDP programs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167349062577.27632.8804687487948517842.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 02:30:25 +0000
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 11 Jan 2023 10:35:11 +0100 you wrote:
> This is a patch set of various performance improvements, fixes, and
> the introduction of more than one XDP program to the xsk selftests
> framework so we can test more things in the future such as upcoming
> multi-buffer and metadata support for AF_XDP. The new programs just
> reuse the framework that all the other eBPF selftests use. The new
> feature is used to implement one new test that does XDP_DROP on every
> other packet. More tests using this will be added in future commits.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,01/15] selftests/xsk: print correct payload for packet dump
    https://git.kernel.org/bpf/bpf-next/c/2d0b2ae2871a
  - [bpf-next,v3,02/15] selftests/xsk: do not close unused file descriptors
    https://git.kernel.org/bpf/bpf-next/c/5adaf52776a4
  - [bpf-next,v3,03/15] selftests/xsk: submit correct number of frames in populate_fill_ring
    https://git.kernel.org/bpf/bpf-next/c/1e04f23bccf9
  - [bpf-next,v3,04/15] selftests/xsk: print correct error codes when exiting
    https://git.kernel.org/bpf/bpf-next/c/085dcccfb7d3
  - [bpf-next,v3,05/15] selftests/xsk: remove unused variable outstanding_tx
    https://git.kernel.org/bpf/bpf-next/c/a4ca62277b6a
  - [bpf-next,v3,06/15] selftests/xsk: add debug option for creating netdevs
    https://git.kernel.org/bpf/bpf-next/c/703bfd371013
  - [bpf-next,v3,07/15] selftests/xsk: replace asm acquire/release implementations
    https://git.kernel.org/bpf/bpf-next/c/efe620e5ba03
  - [bpf-next,v3,08/15] selftests/xsk: remove namespaces
    https://git.kernel.org/bpf/bpf-next/c/64aef77d750e
  - [bpf-next,v3,09/15] selftests/xsk: load and attach XDP program only once per mode
    https://git.kernel.org/bpf/bpf-next/c/aa61d81f397c
  - [bpf-next,v3,10/15] selftests/xsk: remove unnecessary code in control path
    https://git.kernel.org/bpf/bpf-next/c/6b3c0821caa4
  - [bpf-next,v3,11/15] selftests/xsk: get rid of built-in XDP program
    https://git.kernel.org/bpf/bpf-next/c/f0a249df1b07
  - [bpf-next,v3,12/15] selftests/xsk: add test when some packets are XDP_DROPed
    https://git.kernel.org/bpf/bpf-next/c/80bea9acabb7
  - [bpf-next,v3,13/15] selftests/xsk: merge dual and single thread dispatchers
    https://git.kernel.org/bpf/bpf-next/c/7f881984073a
  - [bpf-next,v3,14/15] selftests/xsk: automatically restore packet stream
    https://git.kernel.org/bpf/bpf-next/c/e67b2554f301
  - [bpf-next,v3,15/15] selftests/xsk: automatically switch XDP programs
    https://git.kernel.org/bpf/bpf-next/c/7d8319a7cc66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


