Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28B72A5C9B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 03:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgKDCKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 21:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgKDCKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 21:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604455805;
        bh=pJgIQnDj87UKnZXw7EE5POfvUmsG0AIKcBA/5b16XdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YE4479ubBdcPRAL4qwWRD8sUBGw2VU4SWFwV8oNZ3AdQ1G4wlds5a/NfWj/u4xAlI
         Ds+s50Gwa8b/27a1dw3cBOHJeamtABQZ0yoae/HWi9nhUWymTMjX54H0wvAgvq/H6e
         sGlQ2SeP8CnoMMy+QJ1cDaN5sMTZ92RaDzY+7iZU=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [bpf-next PATCH v3 1/5] selftests/bpf: Move test_tcppbf_user into
 test_progs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160445580494.31301.3509278420487105425.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Nov 2020 02:10:04 +0000
References: <160443928881.1086697.17661359319919165370.stgit@localhost.localdomain>
In-Reply-To: <160443928881.1086697.17661359319919165370.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 03 Nov 2020 13:34:48 -0800 you wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Recently a bug was missed due to the fact that test_tcpbpf_user is not a
> part of test_progs. In order to prevent similar issues in the future move
> the test functionality into test_progs. By doing this we can make certain
> that it is a part of standard testing and will not be overlooked.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/5] selftests/bpf: Move test_tcppbf_user into test_progs
    https://git.kernel.org/bpf/bpf-next/c/aaf376bddf68
  - [bpf-next,v3,2/5] selftests/bpf: Drop python client/server in favor of threads
    https://git.kernel.org/bpf/bpf-next/c/247f0ec361b7
  - [bpf-next,v3,3/5] selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
    https://git.kernel.org/bpf/bpf-next/c/d3813ea14b69
  - [bpf-next,v3,4/5] selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton
    https://git.kernel.org/bpf/bpf-next/c/0a099d1429c7
  - [bpf-next,v3,5/5] selftest/bpf: Use global variables instead of maps for test_tcpbpf_kern
    https://git.kernel.org/bpf/bpf-next/c/21b5177e997c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


