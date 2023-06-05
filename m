Return-Path: <netdev+bounces-8040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8CD7228A7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEE66281272
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79AB1DDE3;
	Mon,  5 Jun 2023 14:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DA21548E;
	Mon,  5 Jun 2023 14:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0138BC4339B;
	Mon,  5 Jun 2023 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685974821;
	bh=I1+oJjUANT/Go9zAX7BnObBZrLAw1r0c46VWOubGrDI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bG6HNIbsIjbaQ358M+LHCDYy47TG36629a0zzGZaeFLKHEXhu4MyKzpXTJ54w4Aea
	 N5qPFaCXQI1vTj6YMiAIz3oMmZCVegokRsyjRTKteeU4xH8Wo7Rube6ebpO5rvHKXB
	 iGn6rH3iTD0wdd+GIKZ34Tca1qocrx8N5RsB8yRbgjNoxceLgSnPNzK1Mh0xceJnCc
	 2kvyhHHD54CV0a0lXWsoC68M6fAcbry3mAQOJinjbatzv2DstaAwYrZpk30zwB4WYI
	 GbFjyDLRMGdhVF9gRGm4dJymuBkZdRO9TAv2h6GD4gV/E5gsRcFfCs3K3g7/gBz5bR
	 PMAaztZ5Jim/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4DE9E87231;
	Mon,  5 Jun 2023 14:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] mptcp: Fixes for address advertisement
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168597482086.20055.17589676099574037923.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 14:20:20 +0000
References: <20230602-send-net-20230602-v1-0-fe011dfa859d@kernel.org>
In-Reply-To: <20230602-send-net-20230602-v1-0-fe011dfa859d@kernel.org>
To: Mat Martineau <martineau@kernel.org>
Cc: matthieu.baerts@tessares.net, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, kishen.maloor@intel.com,
 geliang.tang@suse.com, fw@strlen.de, netdev@vger.kernel.org,
 mptcp@lists.linux.dev, stable@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 04 Jun 2023 20:25:16 -0700 you wrote:
> Patches 1 and 2 allow address advertisements to be removed without
> affecting current connected subflows, and updates associated self tests.
> 
> Patches 3 and 4 correctly track (and allow removal of) addresses that
> were implicitly announced as part of subflow creation. Also updates
> associated self tests.
> 
> [...]

Here is the summary with links:
  - [net,1/5] mptcp: only send RM_ADDR in nl_cmd_remove
    https://git.kernel.org/netdev/net/c/8b1c94da1e48
  - [net,2/5] selftests: mptcp: update userspace pm addr tests
    https://git.kernel.org/netdev/net/c/48d73f609dcc
  - [net,3/5] mptcp: add address into userspace pm list
    https://git.kernel.org/netdev/net/c/24430f8bf516
  - [net,4/5] selftests: mptcp: update userspace pm subflow tests
    https://git.kernel.org/netdev/net/c/6c160b636c91
  - [net,5/5] mptcp: update userspace pm infos
    https://git.kernel.org/netdev/net/c/77e4b94a3de6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



