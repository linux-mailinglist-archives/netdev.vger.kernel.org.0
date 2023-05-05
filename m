Return-Path: <netdev+bounces-524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DC06F7F45
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC4C280FA6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C7B6FC9;
	Fri,  5 May 2023 08:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085E04C99
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B02C4C433A7;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683276019;
	bh=rqlrfSYz8ONpBuvHAudFA5BlCegRfzz74IUNZbSxbz4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=N9C/mObuUdk/45xsREHf358GutdBQKMl1SG99IcffhCoh/L+ZyVziE9QMO0VTZka7
	 IGyZJwLd8PjXbtfGArVF+69y0BTzaOvAjITi256k+rLCdo7MjXAdnIYxU0j6aMc3N2
	 zec4EL+yBHhxweR5P/rGH3TFY2RmJENh3rdbITFDaWQ70lqlBUp17oQ+zG2p94lfSh
	 U4ALFdukd/2ujkjFJFohoLzL/9S+pgX/DexkVnsgtKudsuALSqOJwSMMWxje47eQlM
	 YtWq0q5vQBhFx6CTf5/l72MqEE0k5gPyp8YBxOIMuog+kLz3eeZZaOz9ix7JtRrrgF
	 QcV6rV4gCEoTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 925BEC73FE7;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: Add back mailing list
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327601959.11276.12517278249391838500.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 08:40:19 +0000
References: <168318528134.31137.11625787711228662726.stgit@palantir17.mph.net>
In-Reply-To: <168318528134.31137.11625787711228662726.stgit@palantir17.mph.net>
To: Martin Habets <habetsm.xilinx@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com,
 linux-net-drivers@amd.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 04 May 2023 08:28:01 +0100 you wrote:
> We used to have a mailing list in the MAINTAINERS file, but removed this
> when we became part of Xilinx as it stopped working.
> Now inside AMD we have the list again. Add it back so patches will be seen
> by all sfc developers.
> 
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc: Add back mailing list
    https://git.kernel.org/netdev/net/c/c00ce5470a8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



