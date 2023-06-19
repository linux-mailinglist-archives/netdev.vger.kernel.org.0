Return-Path: <netdev+bounces-11900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6E7735089
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 898821C209D3
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E41C13A;
	Mon, 19 Jun 2023 09:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171FBE6D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ED38C433CA;
	Mon, 19 Jun 2023 09:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687167622;
	bh=e6anRoP/m4JM1xqj4xAMdwJFi3KtWjvxKND+PERkRgA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qhAUYBn2vEEKon2YnnFBa+VC9VkOcFob7TnOjC3cf8eFaFTIrWJbYc5fPzY5JG99q
	 bqssoc6FQ9ahKLaYayk8GjKCKJx3XlnpxlQrTqoZMIY0MuOv2bdb9xiJF+U6RXLRcX
	 d7LjdI/Jepf+FVWnfqVDIFaMzdwIaDp0+AkNuwV2/F+YkMd/RnvYD+sryyCNRfL2vj
	 FNM6YFiwRLg3pvKA9esmTXjlQjGgq2aB9rJtgcczlxPjLYb1YDok9xuuUPXasIUkse
	 m65Miv+NdqCn7IKESStJxoKsAX8Sm2zIZ2LF3CWWt0qaKqG4sjwmPMR0ObhKdYk1hu
	 2krLqXzQdGC7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52446C43169;
	Mon, 19 Jun 2023 09:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168716762233.17662.6686641236588648870.git-patchwork-notify@kernel.org>
Date: Mon, 19 Jun 2023 09:40:22 +0000
References: <20230616200119.44163-2-saeed@kernel.org>
In-Reply-To: <20230616200119.44163-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, leonro@nvidia.com, maxtram95@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 16 Jun 2023 13:01:08 -0700 you wrote:
> From: Maxim Mikityanskiy <maxtram95@gmail.com>
> 
> The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
> is required by bpf_xdp_adjust_tail to support growing the tail pointer
> in fragmented packets. Pass the missing parameter when the current RQ
> mode allows XDP multi buffer.
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
    https://git.kernel.org/netdev/net/c/4e7401fc8c8d
  - [net,02/12] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
    https://git.kernel.org/netdev/net/c/62a522d3354d
  - [net,03/12] net/mlx5: Fix driver load with single msix vector
    https://git.kernel.org/netdev/net/c/0ab999d4a1bf
  - [net,04/12] net/mlx5e: TC, Add null pointer check for hardware miss support
    https://git.kernel.org/netdev/net/c/b100573ab76e
  - [net,05/12] net/mlx5e: TC, Cleanup ct resources for nic flow
    https://git.kernel.org/netdev/net/c/fb7be476ab7e
  - [net,06/12] net/mlx5: DR, Support SW created encap actions for FW table
    https://git.kernel.org/netdev/net/c/87cd0649176c
  - [net,07/12] net/mlx5: DR, Fix wrong action data allocation in decap action
    https://git.kernel.org/netdev/net/c/ef4c5afc783d
  - [net,08/12] net/mlx5: Free IRQ rmap and notifier on kernel shutdown
    https://git.kernel.org/netdev/net/c/314ded538e5f
  - [net,09/12] net/mlx5e: Don't delay release of hardware objects
    https://git.kernel.org/netdev/net/c/cf5bb02320d4
  - [net,10/12] net/mlx5e: Fix ESN update kernel panic
    https://git.kernel.org/netdev/net/c/fef06678931f
  - [net,11/12] net/mlx5e: Drop XFRM state lock when modifying flow steering
    https://git.kernel.org/netdev/net/c/c75b94255aaa
  - [net,12/12] net/mlx5e: Fix scheduling of IPsec ASO query while in atomic
    https://git.kernel.org/netdev/net/c/a128f9d4c122

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



