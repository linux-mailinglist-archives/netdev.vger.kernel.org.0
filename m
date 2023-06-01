Return-Path: <netdev+bounces-7216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF2B71F163
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11E881C20D50
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57A14823F;
	Thu,  1 Jun 2023 18:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA904701B;
	Thu,  1 Jun 2023 18:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FA60C4339B;
	Thu,  1 Jun 2023 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685643019;
	bh=qTadY3CaPJvGosINz+a2ijav8RAh4WpyvhuAH3AUEWI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ahotBD8/OeJ/+cxDdxp/7P/GSBR8BQb9pCxZgfwjhbi4rGjXG0sJQOq9YVgotcrHf
	 dlNX1kdBQWiVVzBqOtDrBtVz48DIyCjGO9cNTvGxP5VQf2fOUrq5qTv4WpcGLxmadi
	 Iz+Wf+fRv/zPwjbUpGNzBDrNtTh+ZUMEhCNByNm+UUOej4CoS1qfxndb7OZ44NE88r
	 Cg+leYBpw4SODVWaVvcGa1Q5b+UbkYCWLuglcTsBgjfWzf/AqUhcoxUFgDK+uA7A3q
	 MIAaJL3SjIeJwoMiiaqI5K74GWiDLHKq7W2w9ULuv4NE9IQA7/ht7vfjeac82edB9z
	 SlqmK87R3YSFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20BD2C395E5;
	Thu,  1 Jun 2023 18:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] bpf: utilize table ID in bpf_fib_lookup helper
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168564301912.9357.10823753179270700264.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 18:10:19 +0000
References: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
To: Louis DeLosSantos <louis.delos.devel@gmail.com>
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@linux.dev,
 sdf@google.com, razor@blackwall.org, john.fastabend@gmail.com, yhs@meta.com

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 31 May 2023 15:38:47 -0400 you wrote:
> This patchset adds the ability to specify a table ID to the
> `bpf_fib_lookup` BPF helper.
> 
> A new `tbid` field is added to `struct fib_bpf_lookup`.
> When the `fib_bpf_lookup` helper is called with the `BPF_FIB_LOOKUP_DIRECT` and
> `BPF_FIB_LOOKUP_TBID' flag the `tbid` field will be interpreted as the table ID
> to use for the fib lookup.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] bpf: add table ID to bpf_fib_lookup BPF helper
    https://git.kernel.org/bpf/bpf-next/c/8ad77e72caae
  - [v2,2/2] selftests/bpf: test table ID fib lookup BPF helper
    https://git.kernel.org/bpf/bpf-next/c/d4ae3e587ece

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



