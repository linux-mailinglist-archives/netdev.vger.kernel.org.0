Return-Path: <netdev+bounces-3208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71F9705F7E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B1E281482
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BC253A0;
	Wed, 17 May 2023 05:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66902CA9;
	Wed, 17 May 2023 05:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69D89C4339B;
	Wed, 17 May 2023 05:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684302022;
	bh=tyFfSx1nIRsAYCX0Zo6ZsUDNiAKFhHFkRvdU9ITemaQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=c2ImrhkIRz01E46fz0N+bo0Mb6ffWofvdHNomjVKA02tbhqJphFVyeceze3WeG8/e
	 mLuVxNwJDzOzraekZfOvGbH4dT6YLvFX+0VcsZGWXBMBa0lpnQg6YH8mNwV2m7Hz/p
	 cayRiHPl3GH2G1kduir3siIPFWvGjD7CGn6CVZlhPp02Od1sF3VXe4gxxtdndMrp9D
	 E/lHsSxSj80FgEpUFbpvd6TWZp2Z5Ni0RZrvHKt9glaCGUn0frN2W2pr5+bcAAyAOQ
	 A7c/K/tNh4yhXR7kH8KHf5/7ULty+ODuQAetDbM+g95d/AeWgUXfaRS79HSW1xaYo4
	 oNSNhlkORIVKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50E4BE5421C;
	Wed, 17 May 2023 05:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 00/10] seltests/xsk: prepare for AF_XDP
 multi-buffer testing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168430202232.4983.3593592236821672726.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 05:40:22 +0000
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230516103109.3066-1-magnus.karlsson@gmail.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
 daniel@iogearbox.net, netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
 bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org, martin.lau@linux.dev,
 song@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@google.com, haoluo@google.com, jolsa@kernel.org,
 tirthendu.sarkar@intel.com

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 16 May 2023 12:30:59 +0200 you wrote:
> Prepare the AF_XDP selftests test framework code for the upcoming
> multi-buffer support in AF_XDP. This so that the multi-buffer patch
> set does not become way too large. In that upcoming patch set, we are
> only including the multi-buffer tests together with any framework
> code that depends on the new options bit introduced in the AF_XDP
> multi-buffer implementation itself.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,01/10] selftests/xsk: do not change XDP program when not necessary
    https://git.kernel.org/bpf/bpf-next/c/d2e541494935
  - [bpf-next,v2,02/10] selftests/xsk: generate simpler packets with variable length
    https://git.kernel.org/bpf/bpf-next/c/df82d2e89c41
  - [bpf-next,v2,03/10] selftests/xsk: add varying payload pattern within packet
    https://git.kernel.org/bpf/bpf-next/c/feb973a9094f
  - [bpf-next,v2,04/10] selftests/xsk: dump packet at error
    https://git.kernel.org/bpf/bpf-next/c/7a8a6762822a
  - [bpf-next,v2,05/10] selftests/xsk: add packet iterator for tx to packet stream
    https://git.kernel.org/bpf/bpf-next/c/69fc03d220a3
  - [bpf-next,v2,06/10] selftests/xsk: store offset in pkt instead of addr
    https://git.kernel.org/bpf/bpf-next/c/d9f6d9709f87
  - [bpf-next,v2,07/10] selftests/xsx: test for huge pages only once
    https://git.kernel.org/bpf/bpf-next/c/041b68f688a3
  - [bpf-next,v2,08/10] selftests/xsk: populate fill ring based on frags needed
    https://git.kernel.org/bpf/bpf-next/c/86e41755b432
  - [bpf-next,v2,09/10] selftests/xsk: generate data for multi-buffer packets
    https://git.kernel.org/bpf/bpf-next/c/2f6eae0df1a8
  - [bpf-next,v2,10/10] selftests/xsk: adjust packet pacing for multi-buffer support
    https://git.kernel.org/bpf/bpf-next/c/7cd6df4f5ec2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



