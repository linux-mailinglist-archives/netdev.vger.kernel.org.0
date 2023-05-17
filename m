Return-Path: <netdev+bounces-3242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D5E7062E6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20A41C20E69
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F4F156D5;
	Wed, 17 May 2023 08:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9501171A7
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E1F0C4339C;
	Wed, 17 May 2023 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684312220;
	bh=4fsvr+MhVxDQigB2kp60r16yPrtisySM6uTYTOIYs6k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=snL7iqnJIxtzTuUnjWLayhsHuvY2EdULIpgv5qme+YBPodhS+7aCwe9YQvLiQ8MH9
	 a3wVrXwZ69ZphR000rgXtOGWBFdLcGe/g8N1L2jVeoTiQtM1a+J2WnzeV1wiUKq5Dx
	 V6X2Dz6xI5jkGI5LCsaMJCm0jupVo864wGhLjb7kT99QV8Lv1DFpL5eoyRLfpSj3O6
	 XAp5Yfq7cA+P/G5i7pwHZOiuUC/utPvstkSOKaTdlC1rjtaej7PLhdZ6SanwG8+xgo
	 MAO0frb5obkkOHzHhcT6fWsiyRF6TuXEkCwrtG++Hlj+1Xd0waHT+IXaOjoPnfrzwM
	 jCm0ysOKwryPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FA5BE21EEC;
	Wed, 17 May 2023 08:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] igb: fix bit_shift to be in [1..8] range
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431222051.29655.1253004493609518704.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:30:20 +0000
References: <20230516174146.2707152-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230516174146.2707152-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, aleksandr.loktionov@intel.com,
 jgarzik@redhat.com, himasekharx.reddy.pucha@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 10:41:46 -0700 you wrote:
> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> 
> In igb_hash_mc_addr() the expression:
>         "mc_addr[4] >> 8 - bit_shift", right shifting "mc_addr[4]"
> shift by more than 7 bits always yields zero, so hash becomes not so different.
> Add initialization with bit_shift = 1 and add a loop condition to ensure
> bit_shift will be always in [1..8] range.
> 
> [...]

Here is the summary with links:
  - [net] igb: fix bit_shift to be in [1..8] range
    https://git.kernel.org/netdev/net/c/60d758659f1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



