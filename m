Return-Path: <netdev+bounces-8513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A52724675
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB8361C2099A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AE615AEA;
	Tue,  6 Jun 2023 14:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AA711C9B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 104E1C4339B;
	Tue,  6 Jun 2023 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686062421;
	bh=tcOiLaQhmOTjfPDfHctR1Ih4KOpyaa8dENh5FOvCs5s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UIj8P3d4YxQZeqF+C04F3RcHe8iD7I67fkXFNkVWBpWziwNr4GZZmEQ8Yqph8xXMb
	 Cazu8rta9/D9as4pLmrPDAhJt183cD0mxy4IgP40EJoYTHWRsZizh8fcP0GmSM9WGA
	 ieUFC+mpqHQBRjRfOLlSDu1XuBz8H4HQLezm4u+t/U/ZFParcuKL3tAn9+bLNtng0r
	 sipKC1N8KM7MoZJ2lJl4t1dzwETmQJ0A+DmbQZqGjDX2IQWjOWLYT6pX27SE7MpgSJ
	 k5TkzAve3rGgJdFB8rocI94FE+Cabp/k4LQw4eCZCEC1zDzI2PBsyv9uYLevKpwatM
	 09V/DGD4hddfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9D91C4166F;
	Tue,  6 Jun 2023 14:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v8] ip-link: add support for nolocalbypass in
 vxlan
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168606242088.26269.8007962643596225433.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 14:40:20 +0000
References: <20230606023202.22454-1-vladimir@nikishkin.pw>
In-Reply-To: <20230606023202.22454-1-vladimir@nikishkin.pw>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
 dsahern@gmail.com

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue,  6 Jun 2023 10:32:02 +0800 you wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> userspace nework stack. With nolocalbypass the packets are always
> forwarded to the userspace network stack, so userspace programs,
> such as tcpdump have a chance to process them.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v8] ip-link: add support for nolocalbypass in vxlan
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=98b0b0cb67ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



