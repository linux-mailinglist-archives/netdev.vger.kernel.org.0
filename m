Return-Path: <netdev+bounces-10010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF6F72BAE5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2FD1C20A55
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5316B8828;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4AC539D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FB48C4339B;
	Mon, 12 Jun 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559220;
	bh=+SIuCsT1QsoL21e0sWwqZKdFzjvYxiuPp1tiwDDsWcg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jEgp6V6GU9AUyPKe8ZACAxLBNiFkEWbalsQY9GKgWx76UJPJrdxZ3q/leIMOVeDm8
	 OLfzzf4cJILOADxnZBGN76D6hVmvdrVO23s6aG4v++0AFlhOa5VR6taJrUs5oUXOb6
	 geiqBsmVn4YmwJ9Pe8tCSFahFUkaoa9QkIW0Rbg3gGiDdDqnyU4YDXe+b2m49qOFjz
	 CQDYQbCrRJQpROQ8+g73BNdo9jRnCYDLTuUFDFeUeaabqS9cx85fYvD3uuY1SscAtW
	 lgByLpQmD8qOn0UNOgbvz1jtYi/jqmaFLoG56kPz5GvuR608WZ6CpPAP5srSuDoVEt
	 ncWB5p5EgDrsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43D13C395EC;
	Mon, 12 Jun 2023 08:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] ipvlan: fix bound dev checking for IPv6 l3s mode
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922027.2912.10628050658415758343.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:20 +0000
References: <20230609091502.3048339-1-liuhangbin@gmail.com>
In-Reply-To: <20230609091502.3048339-1-liuhangbin@gmail.com>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, daniel@iogearbox.net,
 maheshb@google.com, pabeni@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 17:15:02 +0800 you wrote:
> The commit 59a0b022aa24 ("ipvlan: Make skb->skb_iif track skb->dev for l3s
> mode") fixed ipvlan bonded dev checking by updating skb skb_iif. This fix
> works for IPv4, as in raw_v4_input() the dif is from inet_iif(skb), which
> is skb->skb_iif when there is no route.
> 
> But for IPv6, the fix is not enough, because in ipv6_raw_deliver() ->
> raw_v6_match(), the dif is inet6_iif(skb), which is returns IP6CB(skb)->iif
> instead of skb->skb_iif if it's not a l3_slave. To fix the IPv6 part
> issue. Let's set IP6CB(skb)->iif to correct ifindex.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] ipvlan: fix bound dev checking for IPv6 l3s mode
    https://git.kernel.org/netdev/net/c/ce57adc222ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



