Return-Path: <netdev+bounces-12066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 039F6735DC8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 343D41C20B6E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF1814283;
	Mon, 19 Jun 2023 19:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860CE125C3
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F257AC433C9;
	Mon, 19 Jun 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687201821;
	bh=5bhuV6yZFdGFcuUmaqnzwIXLw1cOxVdeYoZMRr1ohQY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iTx7Sbv7DjIPZ49JcbdNmaXwrX2SrAn4SiRr7Q4f6OcQQWYHIQ09WCubGlRabe5O7
	 YEbxqgU3heLLMdz/c5fUwCerHMa4igjF7UDBTVlubNG7R5+T+bxZnc5t2ZR5VIuhZm
	 ia2HUek3c13pdl9hDiT6OD79fqnqp52iKTMqUD5pGQhf+/dMuyrq5BG02Fse/h07+i
	 gSmUDEqGzkhH9eMfMTP55vJUHPYPDiBwrofnYerll+ivo3k0tKrEReJZcJtOtBYZ4z
	 0N4wywYwQCM8DBet0nL2pGazc+bqxnxL76wy0CaypugZzjj01HPjvQ1k3Iohk7L0aU
	 WtN9C9tT7Sa1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3C72C395C7;
	Mon, 19 Jun 2023 19:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 0/5] ipv6: Random cleanup for Extension Header.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168720182086.16040.10593739902009735285.git-patchwork-notify@kernel.org>
Date: Mon, 19 Jun 2023 19:10:20 +0000
References: <20230614230107.22301-1-kuniyu@amazon.com>
In-Reply-To: <20230614230107.22301-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
 netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 16:01:02 -0700 you wrote:
> This series (1) cleans up pskb_may_pull() in some functions, where needed
> data are already pulled by their caller, (2) removes redundant multicast
> test, and (3) optimises reload timing of the header.
> 
> 
> Kuniyuki Iwashima (5):
>   ipv6: rpl: Remove pskb(_may)?_pull() in ipv6_rpl_srh_rcv().
>   ipv6: rpl: Remove redundant multicast tests in ipv6_rpl_srh_rcv().
>   ipv6: exthdrs: Replace pskb_pull() with skb_pull() in ipv6_srh_rcv().
>   ipv6: exthdrs: Reload hdr only when needed in ipv6_srh_rcv().
>   ipv6: exthdrs: Remove redundant skb_headlen() check in
>     ip6_parse_tlv().
> 
> [...]

Here is the summary with links:
  - [v1,net-next,1/5] ipv6: rpl: Remove pskb(_may)?_pull() in ipv6_rpl_srh_rcv().
    https://git.kernel.org/netdev/net-next/c/ac9d8a66e41d
  - [v1,net-next,2/5] ipv6: rpl: Remove redundant multicast tests in ipv6_rpl_srh_rcv().
    https://git.kernel.org/netdev/net-next/c/6facbca52da2
  - [v1,net-next,3/5] ipv6: exthdrs: Replace pskb_pull() with skb_pull() in ipv6_srh_rcv().
    https://git.kernel.org/netdev/net-next/c/0d2e27b85850
  - [v1,net-next,4/5] ipv6: exthdrs: Reload hdr only when needed in ipv6_srh_rcv().
    https://git.kernel.org/netdev/net-next/c/b83d50f43165
  - [v1,net-next,5/5] ipv6: exthdrs: Remove redundant skb_headlen() check in ip6_parse_tlv().
    https://git.kernel.org/netdev/net-next/c/6db5dd2bf481

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



