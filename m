Return-Path: <netdev+bounces-4883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D5F70EF69
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE5A01C20B46
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFF2846F;
	Wed, 24 May 2023 07:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911201FA2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E4D2C4339B;
	Wed, 24 May 2023 07:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684913421;
	bh=7PtXez7icPQvrSNIbipn2ip+z6GYpRYYADaG8KzoGu4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Lv7u6tjSvKP3LFojwslF/wvyRefruxSAZ2Qc9mgGcLyzpbT9DnOW9NM0SS5H1XRY7
	 h1Fp6YluVlkiHGvbzCo4SLQ1VYcmc2FYDmwufHi8uNAlzNtA6IvU9July5ao6KaKcm
	 5HWvRP6xwjVTv5POva+RbT4mc78oNOJ9ePSBRtitCDRsb6SkO+wXOOvBHqeUVprIji
	 ZQ4W14h5Zy8BoAaCSIBasVG27JjJJenyniA2xggWPbvQ1fXmcUIvj1rqhNBtWtzpY7
	 54Fjd+7N3e+sk8p7BoJDQIQsLbMUACidh5DyDTHNk7SIHAk4GptShYDG81ETZXucbW
	 pZ+95Ivv0W3lQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B696E22AE9;
	Wed, 24 May 2023 07:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] ipv4: Remove RTO_ONLINK from udp, ping and raw
 sockets.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168491342110.25320.5576599970370486815.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 07:30:21 +0000
References: <cover.1684764727.git.gnault@redhat.com>
In-Reply-To: <cover.1684764727.git.gnault@redhat.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
 willemdebruijn.kernel@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 May 2023 16:37:50 +0200 you wrote:
> udp_sendmsg(), ping_v4_sendmsg() and raw_sendmsg() use similar patterns
> for restricting their route lookup to on-link hosts. Although they use
> slightly different code, they all use RTO_ONLINK to override the least
> significant bit of their tos value.
> 
> RTO_ONLINK is used to restrict the route scope even when the scope is
> set to RT_SCOPE_UNIVERSE. Therefore it isn't necessary: we can properly
> set the scope to RT_SCOPE_LINK instead.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ping: Stop using RTO_ONLINK.
    https://git.kernel.org/netdev/net-next/c/726de790f660
  - [net-next,2/3] raw: Stop using RTO_ONLINK.
    https://git.kernel.org/netdev/net-next/c/c85be08fc4fa
  - [net-next,3/3] udp: Stop using RTO_ONLINK.
    https://git.kernel.org/netdev/net-next/c/0e26371db548

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



