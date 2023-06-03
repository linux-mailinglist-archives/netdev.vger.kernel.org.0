Return-Path: <netdev+bounces-7681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 439F97211EE
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 21:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2F522817EB
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 19:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02F5E571;
	Sat,  3 Jun 2023 19:52:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D05720EB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 19:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFD86C4339B;
	Sat,  3 Jun 2023 19:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685821939;
	bh=S3Vx4FIgPm+iQwsmMrW0FL3Ww8UbMFlWqElAHg9Ap70=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=vB2VZzHwCJy9MBc9PLcTwjrMHxeIs1RQzbmLliruYVaR2MIt9YNyV9X6EX/fIZwgX
	 +e/eAyZvKcI4TgWw+POfvpuH4ZxX5RiKdX5I5YXWuads1/W9XrrEPEzOpz5Yg2jxC+
	 4DfO0pgy552+61v8+S/3CBV3uZWh/offphNNKYse/p58PxblBQCD0BZLX4XIOLGc/w
	 e0nQYQ8KusykkdGq3wI8miGuzPe1EEqnWOQRMfkYuZHKARICTngKpRr+L0foTBYQl/
	 dBXHrMUw7/ePFKINSQy9YLMiFi4r02N4cKYmQPRPkv+On8A+/Hl1n0N26gldxvmEgY
	 FabdPNaMqZMaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6681E29F3E;
	Sat,  3 Jun 2023 19:52:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Fix gitignore for recently added usptream self tests
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168582193974.2686.3376927574243466657.git-patchwork-notify@kernel.org>
Date: Sat, 03 Jun 2023 19:52:19 +0000
References: <20230602195451.2862128-1-weihaogao@google.com>
In-Reply-To: <20230602195451.2862128-1-weihaogao@google.com>
To: Weihao Gao <weihaogao@google.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 trivial@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Jun 2023 19:54:50 +0000 you wrote:
> This resolves the issue that generated binary is showing up as an untracked git file after every build on the kernel.
> 
> Signed-off-by: Weihao Gao <weihaogao@google.com>
> ---
>  tools/testing/selftests/net/.gitignore | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - Fix gitignore for recently added usptream self tests
    https://git.kernel.org/netdev/net/c/02a7eee1ebf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



