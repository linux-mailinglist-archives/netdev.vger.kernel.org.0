Return-Path: <netdev+bounces-11054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA727315C6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB916281730
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4B2A939;
	Thu, 15 Jun 2023 10:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A96253B4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D369EC433D9;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686826220;
	bh=dHluJ+9P71s4Ojb2jURUYqveMI0naQ+dvXjwYh3bN0A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KmhgRLWlbfF6eKE9+GHHA5PnYjQNFVMJBY58kNmtstijBsBG9wDxUFkaO0siowmyR
	 MJxv5xTbulzAjQ+B2BkltozjVzwKlf7AgoYbiX2IWlQDBn6pi8e9IX6G/fC+rak3tt
	 mS947BVGMm8eIJNyH46aHg6KMr4vt6gcZKwp4TrEsbIpn1hZ4lCLF8WUJxnJKR4dR0
	 QCEA6w/v12ezbZ9aqKGxomGuxSaRjk73DvbNlQFbiu/Ci4IcD0TvSHyBaW2mq1krNi
	 +TsKqD97C5yoEVmiGXPXr+AWKXpfqRj6DgwmDDN4k7ShBMSFgiPSRZtvMwKbRlxXlX
	 qI89SCk6ViPQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C02C0C64458;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tools: ynl: work around stale system headers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168682622078.15431.13324891164810442074.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 10:50:20 +0000
References: <20230614002800.2034459-1-kuba@kernel.org>
In-Reply-To: <20230614002800.2034459-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 13 Jun 2023 17:28:00 -0700 you wrote:
> The inability to include the uAPI headers directly in tools/
> is one of the bigger annoyances of compiling user space code.
> Most projects trade the pain for smaller inconvenience of having
> to copy the headers under tools/include.
> 
> In case of netlink headers I think that we can avoid both.
> Netlink family headers are simple and should be self-contained.
> We can try to twiddle the Makefile a little to force-include
> just the family header, and use system headers for the rest.
> 
> [...]

Here is the summary with links:
  - [net-next] tools: ynl: work around stale system headers
    https://git.kernel.org/netdev/net-next/c/f0ec58d557d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



