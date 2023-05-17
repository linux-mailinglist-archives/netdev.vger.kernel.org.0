Return-Path: <netdev+bounces-3230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 657F670625E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 601ED1C20E71
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897ED101E8;
	Wed, 17 May 2023 08:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B686F15497
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62AF8C433A1;
	Wed, 17 May 2023 08:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684311021;
	bh=UM0zA1YBIP4+IAYgXmEblkiffE7+so4l9t3wj+XBmaU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=W6646JcI1eRkw4/Krm2ZBBMxEAxMM5xMGxZKMXP690yEtE6NmArwuY6DZdJx6ddYq
	 CqL4cpe7hrJp55EIVx5EDKjw9f8Q0Cx6KVNAGrQQuPfYU2tGWPVCUOlc0UWwckIlS8
	 3piXniue9z2PqjLF+lO8TAVCIbxNhPR4yg4g/NGEGm1c1XyTt6V5eYqX7jFgWNyhtB
	 7oH5Qo/V5l6Lv/dnfyZRaQck2q8Mc9ZVX/2xzcqlujh1WjTK6c3Vl/f2AQOzAIMV2m
	 poENtMwoPPFCW2A4R161hiWJha2MjQvvpxlDgEBJm8x4K5ndbArrHQljmKF1qjGMGF
	 ICcYJ5C4FFuoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 518F3E5421C;
	Wed, 17 May 2023 08:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] seg6: Cleanup duplicates of skb_dst_drop calls
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431102133.18881.11020774298219110785.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:10:21 +0000
References: <20230515153427.3385392-1-yuya.tajimaa@gmail.com>
In-Reply-To: <20230515153427.3385392-1-yuya.tajimaa@gmail.com>
To: Yuya Tajima <yuya.tajimaa@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 May 2023 15:34:27 +0000 you wrote:
> In processing IPv6 segment routing header (SRH), several functions call
> skb_dst_drop before ip6_route_input. However, ip6_route_input calls
> skb_dst_drop within it, so there is no need to call skb_dst_drop in advance.
> 
> Signed-off-by: Yuya Tajima <yuya.tajimaa@gmail.com>
> ---
>  net/ipv6/exthdrs.c       | 3 ---
>  net/ipv6/seg6_iptunnel.c | 3 +--
>  2 files changed, 1 insertion(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] seg6: Cleanup duplicates of skb_dst_drop calls
    https://git.kernel.org/netdev/net-next/c/fa0583c20243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



