Return-Path: <netdev+bounces-4702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E51970DF3A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08E661C20D91
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A29200CA;
	Tue, 23 May 2023 14:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3653A1F947;
	Tue, 23 May 2023 14:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7BC4C433EF;
	Tue, 23 May 2023 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684852220;
	bh=vXFdN959RvQ01QCvlVjdEiC3BdOulxgNIUJnLoiE/LI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=K9CI3eRNX876tqBz809GxGrGW2pqpWzZRFwZXP55OSS8dKIINOeztPCp/lq0ijptN
	 FmRfcCsqFhmtm+D0UlmcxeeLeNU2lW2g1qYGRPUfA7rWgON3lJX7OqDgfCXsyNmf56
	 jNP4BpYR6pLPlXl1dxcg+jM4TQJyOVBAYd8Sc2noH0/WRwRf5rWh3uXVrppfAKQxKz
	 SVjHKInziSvMLKFh1yDmFJMi1oHyNbnEvBduMnXizdH1ogzNTwtMMRsdizLwOn8Q57
	 pYYAVTQXJ9/SDKPOroxQ6B7SC+deKSmFFb0b7S8mMtOTo9HHbFxiPr/1C3M2D3pA6/
	 VSPbt9BiX5+3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB645C04E32;
	Tue, 23 May 2023 14:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: add xdp_feature selftest for bond
 device
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168485222076.20577.8992171669768953308.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 14:30:20 +0000
References: <64cb8f20e6491f5b971f8d3129335093c359aad7.1684329998.git.lorenzo@kernel.org>
In-Reply-To: <64cb8f20e6491f5b971f8d3129335093c359aad7.1684329998.git.lorenzo@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: bpf@vger.kernel.org, lorenzo.bianconi@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 17 May 2023 15:41:33 +0200 you wrote:
> Introduce selftests to check xdp_feature support for bond driver.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 121 ++++++++++++++++++
>  1 file changed, 121 insertions(+)

Here is the summary with links:
  - [bpf-next] selftests/bpf: add xdp_feature selftest for bond device
    https://git.kernel.org/bpf/bpf-next/c/6cc385d2cdb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



