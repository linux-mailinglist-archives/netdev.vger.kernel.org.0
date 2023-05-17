Return-Path: <netdev+bounces-3173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DDB705DE6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4171C20C2F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6744F17F2;
	Wed, 17 May 2023 03:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DFD17E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C930C433EF;
	Wed, 17 May 2023 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684293619;
	bh=QCmQ4jCsCP3TbJ16hG7rtD9te/vFnMoMkdnHWPSxSgk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iAGndOWzCcEm0/KXW8wGkuCEiwpHMl8Ht5KmLWiqBelZ/GKprMFjHb9tg/Qtd+Xu7
	 Zil4nicHWQDnoY4lcg3dcqy5ClMVQpjxOEeeexvK5Rtg7j6JbWXo87ELcfVaYI7Uol
	 +UVg/MpqmW1LkS3acSVnHsy4tbIcNhLvxW/uYK5xjJQQJPyT917dswYQhA9w+Jca00
	 q961CuohRsCpA23llZ/K87tkbTxrlzH11d0YMBeKrnNeAV8wk0oHkLpqQ7FqEt/5Y5
	 wIk9WOw9mdBt1zVhyg9Q3Ej4eCdTcwwmRjEmVKbDkB7miDPavz1+ZjtWMPCz4cpntp
	 rG5dX6Z7hjiLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01E8EC59A4C;
	Wed, 17 May 2023 03:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: Fix crash with CONFIG_NET_NS=n
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168429361900.31276.11894370225184808220.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 03:20:19 +0000
References: <20230515162925.1144416-1-idosch@nvidia.com>
In-Reply-To: <20230515162925.1144416-1-idosch@nvidia.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, jiri@resnulli.us,
 simon.horman@corigine.com, m.szyprowski@samsung.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 May 2023 19:29:25 +0300 you wrote:
> '__net_initdata' becomes a no-op with CONFIG_NET_NS=y, but when this
> option is disabled it becomes '__initdata', which means the data can be
> freed after the initialization phase. This annotation is obviously
> incorrect for the devlink net device notifier block which is still
> registered after the initialization phase [1].
> 
> Fix this crash by removing the '__net_initdata' annotation.
> 
> [...]

Here is the summary with links:
  - [net] devlink: Fix crash with CONFIG_NET_NS=n
    https://git.kernel.org/netdev/net/c/d6352dae0903

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



