Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE74071CA
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 21:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhIJTVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 15:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhIJTVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 15:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B6F5611CC;
        Fri, 10 Sep 2021 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631301609;
        bh=gKo4XiDx5MDqSVQsZg2mgxuITCI1etC2FoFsT+zkE38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nLFXWgxyGqiVSOPitSj+wpEW5wlsbX5FyRaTNeATrSpcP1FgoMJO2VRO8HaKGkW3H
         CuAnsQLcQtDUD3OhDLhY6is8oIUI3W7S2vamjkzn8G3azuHHIPfSCbNe5WkaB2IP+T
         v1MyXU72RxHUfYozYibyQXSbgQZCyOGz3VGlOijSELisDyOkkIn4FI1LBedbmpxDFg
         gIZWC5selBsIc6BtqlmimtZFoDrb4nBho8v7PkAgA/iLUlkzcp9WNIjnRq36qoreKD
         6s3XHMtBOXifyrMCuhtggm/QT3AQfjOECBgyQpWuqON92+AwyFwl7PUBqntUv+JvE8
         CXM5PLTfT/GRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8ED51609F8;
        Fri, 10 Sep 2021 19:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 00/20] selftests: xsk: facilitate adding tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163130160958.18469.252276262361862067.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Sep 2021 19:20:09 +0000
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  7 Sep 2021 09:19:08 +0200 you wrote:
> This patch set facilitates adding new tests as well as describing
> existing ones in the xsk selftests suite and adds 3 new test suites at
> the end. The idea is to isolate the run-time that executes the test
> from the actual implementation of the test. Today, implementing a test
> amounts to adding test specific if-statements all around the run-time,
> which is not scalable or amenable for reuse. This patch set instead
> introduces a test specification that is the only thing that a test
> fills in. The run-time then gets this specification and acts upon it
> completely unaware of what test it is executing. This way, we can get
> rid of all test specific if-statements from the run-time and the
> implementation of the test can be contained in a single function. This
> hopefully makes it easier to add tests and for users to understand
> what the test accomplishes.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,01/20] selftests: xsk: simplify xsk and umem arrays
    https://git.kernel.org/bpf/bpf-next/c/ed7b74dc7777
  - [bpf-next,v2,02/20] selftests: xsk: introduce type for thread function
    https://git.kernel.org/bpf/bpf-next/c/744eb5c882e8
  - [bpf-next,v2,03/20] selftests: xsk: introduce test specifications
    https://git.kernel.org/bpf/bpf-next/c/ce74acaf015c
  - [bpf-next,v2,04/20] selftests: xsk: move num_frames and frame_headroom to xsk_umem_info
    https://git.kernel.org/bpf/bpf-next/c/83f4ae2f26bd
  - [bpf-next,v2,05/20] selftests: xsk: move rxqsize into xsk_socket_info
    https://git.kernel.org/bpf/bpf-next/c/4bf8ee65ba4e
  - [bpf-next,v2,06/20] selftests: xsk: make frame_size configurable
    https://git.kernel.org/bpf/bpf-next/c/c160d7afba8f
  - [bpf-next,v2,07/20] selftests: xsx: introduce test name in test spec
    https://git.kernel.org/bpf/bpf-next/c/53cb3cec2f1e
  - [bpf-next,v2,08/20] selftests: xsk: add use_poll to ifobject
    https://git.kernel.org/bpf/bpf-next/c/119d4b02feb5
  - [bpf-next,v2,09/20] selftests: xsk: introduce rx_on and tx_on in ifobject
    https://git.kernel.org/bpf/bpf-next/c/1856c24db0a8
  - [bpf-next,v2,10/20] selftests: xsk: replace second_step global variable
    https://git.kernel.org/bpf/bpf-next/c/55be575dc13c
  - [bpf-next,v2,11/20] selftests: xsk: specify number of sockets to create
    https://git.kernel.org/bpf/bpf-next/c/85c6c9573970
  - [bpf-next,v2,12/20] selftests: xsk: make xdp_flags and bind_flags local
    https://git.kernel.org/bpf/bpf-next/c/af6731d1e1c6
  - [bpf-next,v2,13/20] selftests: xsx: make pthreads local scope
    https://git.kernel.org/bpf/bpf-next/c/e2d850d5346c
  - [bpf-next,v2,14/20] selftests: xsk: eliminate MAX_SOCKS define
    https://git.kernel.org/bpf/bpf-next/c/8ce7192b508d
  - [bpf-next,v2,15/20] selftests: xsk: allow for invalid packets
    https://git.kernel.org/bpf/bpf-next/c/8abf6f725a9e
  - [bpf-next,v2,16/20] selftests: xsk: introduce replacing the default packet stream
    https://git.kernel.org/bpf/bpf-next/c/605091c5100d
  - [bpf-next,v2,17/20] selftests: xsk: add test for unaligned mode
    https://git.kernel.org/bpf/bpf-next/c/a4ba98dd0c69
  - [bpf-next,v2,18/20] selftests: xsk: eliminate test specific if-statement in test runner
    https://git.kernel.org/bpf/bpf-next/c/6ce67b5165e6
  - [bpf-next,v2,19/20] selftests: xsk: add tests for invalid xsk descriptors
    https://git.kernel.org/bpf/bpf-next/c/0d1b7f3a00cf
  - [bpf-next,v2,20/20] selftests: xsk: add tests for 2K frame size
    https://git.kernel.org/bpf/bpf-next/c/909f0e28207c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


