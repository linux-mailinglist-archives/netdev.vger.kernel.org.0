Return-Path: <netdev+bounces-1096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5936FC297
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA1B628118A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5228C01;
	Tue,  9 May 2023 09:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728588BF3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C4F0C433D2;
	Tue,  9 May 2023 09:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683624021;
	bh=q+zzx59V7sYAAa3SJdpVpIhmQSecuIksyTjzjeayP/g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dtElA7KwfNXbOzBp/WwEIikVzmOYzcrKyRH5wsBC9mdNXFha5JtaDRooPLM1PqKTq
	 WmEsIqJMPp5sm6AfgVMFV/pKlV0MIgw1F10kAoGQFPLYbYrrviqgtuDHV+Pstd9joJ
	 HywxnkPHmcv64XeOfdvZiys3/E6HUdyREsWAEsHEqTgc9FQGWck9Cj+PrmwgZwXq8P
	 z9/gtmSpJftt9PD4xP5FPBZQd7uJ1wfQrcFUQDnkrkLe6qtPrwWhcwzpwIclBazUlq
	 WHZQhVJGIyUw0WSa6b5RRUjqpOmqYDuprblE2noeS3/Gb+LPOKFyU1J/FINQ32Q2lX
	 QAs9GUrTQTBow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F33BBE26D23;
	Tue,  9 May 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] linux/dim: Do nothing if no time delta between samples
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168362402099.5178.2587927505400570071.git-patchwork-notify@kernel.org>
Date: Tue, 09 May 2023 09:20:20 +0000
References: <20230507135743.138993-1-tariqt@nvidia.com>
In-Reply-To: <20230507135743.138993-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 john.fastabend@gmail.com, kuba@kernel.org, edumazet@google.com,
 pabeni@redhat.com, saeedm@nvidia.com, gal@nvidia.com, talgi@nvidia.com,
 leonro@nvidia.com, royno@nvidia.com, ayal@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 7 May 2023 16:57:43 +0300 you wrote:
> From: Roy Novich <royno@nvidia.com>
> 
> Add return value for dim_calc_stats. This is an indication for the
> caller if curr_stats was assigned by the function. Avoid using
> curr_stats uninitialized over {rdma/net}_dim, when no time delta between
> samples. Coverity reported this potential use of an uninitialized
> variable.
> 
> [...]

Here is the summary with links:
  - [net] linux/dim: Do nothing if no time delta between samples
    https://git.kernel.org/netdev/net/c/162bd18eb55a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



