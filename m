Return-Path: <netdev+bounces-8205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 362367231BF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8271228144E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D52261E3;
	Mon,  5 Jun 2023 20:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7501F323E;
	Mon,  5 Jun 2023 20:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F347DC433EF;
	Mon,  5 Jun 2023 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685998221;
	bh=IxsElEkxhz8alBT8B7X6/KPP61OQIi7ZnpwpL/3RoIs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J2JNHVoLF6GfBD4kfCdxvZLN9xlDUa8VkS2Rl6HD376s4hAJe/LMvtZTxLJCkaIqF
	 sHVdt4x0G+ZI/yJLFrJm8KoqI6cFQ6Hr+/zVkQMg2fBI0ml7rZSh0Bsd8EVICn9A4N
	 yeQwUgNTvmF4bEq8WFfWUhdDxUphdG0MdStbF8y4Q5fPloYm/QRhCDXFAYyEMnvKVK
	 wHGeGzJ+M2fc40tB2IH/xyrPXtNm6BVVtdzgzdLW5Po7haXEzCx1TjKrpdE2cqoX47
	 8DGXUWnOEq5y/3Nh5X86h8tEsvCUCPWIUySJb38qOJDdef27wImLirsljxXCFnnCGA
	 dYCdx0QoNVieA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE4B0E8723D;
	Mon,  5 Jun 2023 20:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V2] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168599822084.31689.5351304208484083209.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 20:50:20 +0000
References: <168563651438.3436004.17735707525651776648.stgit@firesoul>
In-Reply-To: <168563651438.3436004.17735707525651776648.stgit@firesoul>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: ttoukan.linux@gmail.com, borkmann@iogearbox.net, ast@kernel.org,
 andrii.nakryiko@gmail.com, bpf@vger.kernel.org, tariqt@nvidia.com,
 gal@nvidia.com, lorenzo@kernel.org, netdev@vger.kernel.org,
 echaudro@redhat.com, andrew.gospodarek@broadcom.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 01 Jun 2023 18:21:54 +0200 you wrote:
> Currently we observed a significant performance degradation in
> samples/bpf xdp1 and xdp2, due XDP multibuffer "xdp.frags" handling,
> added in commit 772251742262 ("samples/bpf: fixup some tools to be able
> to support xdp multibuffer").
> 
> This patch reduce the overhead by avoiding to read/load shared_info
> (sinfo) memory area, when XDP packet don't have any frags. This improves
> performance because sinfo is located in another cacheline.
> 
> [...]

Here is the summary with links:
  - [bpf-next,V2] bpf/xdp: optimize bpf_xdp_pointer to avoid reading sinfo
    https://git.kernel.org/bpf/bpf-next/c/411486626e57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



