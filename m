Return-Path: <netdev+bounces-8777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C17FA725B39
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84F14281297
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69FB35B37;
	Wed,  7 Jun 2023 10:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5247488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D354FC433EF;
	Wed,  7 Jun 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686132020;
	bh=e8rEb4Y4IpZDsTEIqBoS9MGDmD/2w7684+h58/z+msM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=HqC9UcOewXsb0y51UoU70BCq8caDvOtKFMqsFOqnTdqZJ6YaQ80GrW5Qq4cy3D/Hb
	 czC6slc1BlnSMkW4UfmoNBgOCxAw9yk7kj16HuMoyIfPQIP4SEZIS4w5D5rnzDYqjC
	 gqt0IFy0eq8p94/9vcX1A4eThZBI6bj3j0A/XamQYYiSdOcVjiGCgm3gWu65nDS7pA
	 X5JiMmXxD3q4ekhkb1JZ+SuQEl0OK1FbOV/dPqh5h+b6vkY6jF3TgS3JtBqbHa6IwY
	 /PWQY9zGVGnunZRR5BpfhaK/cF6gNtGG1OhVK69vvHiPq6/yxHRbsMKFdUesVOjn2m
	 3wzC+yM7VI6Zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B565FE29F39;
	Wed,  7 Jun 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: make writes to /dev/gnssX synchronous
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613202073.15110.15879558057784606177.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 10:00:20 +0000
References: <20230606171253.2612334-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230606171253.2612334-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, mschmidt@redhat.com,
 karol.kolacinski@intel.com, michal.michalik@intel.com, johan@kernel.org,
 simon.horman@corigine.com, sunithax.d.mekala@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 10:12:53 -0700 you wrote:
> From: Michal Schmidt <mschmidt@redhat.com>
> 
> The current ice driver's GNSS write implementation buffers writes and
> works through them asynchronously in a kthread. That's bad because:
>  - The GNSS write_raw operation is supposed to be synchronous[1][2].
>  - There is no upper bound on the number of pending writes.
>    Userspace can submit writes much faster than the driver can process,
>    consuming unlimited amounts of kernel memory.
> 
> [...]

Here is the summary with links:
  - [net] ice: make writes to /dev/gnssX synchronous
    https://git.kernel.org/netdev/net/c/bf15bb38ec7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



