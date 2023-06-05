Return-Path: <netdev+bounces-8236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF80F72336E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82610281399
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56952770F;
	Mon,  5 Jun 2023 23:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFCD37F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD54DC433D2;
	Mon,  5 Jun 2023 23:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686006024;
	bh=HAu6DMtxeHIm33UU2PNttgMkBm7XEsDzwDUe7Y1WtK8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AixXtNeTxKWGtu9R3//xKOMainJMnBvHsrOBpOo/+gDemRXoGx9rZbTMWbGETgCyn
	 7VBINnzR8y594Hgj911VBnYks37GQLzhBQicaW3cgzvYyFSynHQFMZafBFknmGmsQT
	 UZe0cJL+7fBd2Q/ZzovLPzh9MFCnjuHtMIk51Zjn7eTZ6f6ZEuv0SZC1++CV/wTD0j
	 kdv3lGhB+835SaPz8L6WFMzrJuCJnKofxv5PLQYj7AGIdD/kUb0CscdYSOSiWY1ajX
	 o8xOrCAX7FJS0CNKkLYiTZrXNGsR4CYtILOyfFyy1SNknLM6Y7Q+7+SUdUKjdiqVuC
	 dKyJarYVjBZSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0BBBE4F0A7;
	Mon,  5 Jun 2023 23:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/14] net/mlx5e: en_tc, Extend peer flows to a list
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168600602472.28052.8782299631686773162.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 23:00:24 +0000
References: <20230602191301.47004-2-saeed@kernel.org>
In-Reply-To: <20230602191301.47004-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, roid@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri,  2 Jun 2023 12:12:48 -0700 you wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Currently, mlx5e_flow is holding a pointer to a peer_flow, in case one
> was created. e.g. There is an assumption that mlx5e_flow can have only
> one peer.
> In order to support more than one peer, refactor mlx5e_flow to hold a
> list of peer flows.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/14] net/mlx5e: en_tc, Extend peer flows to a list
    https://git.kernel.org/netdev/net-next/c/953bb24ddc11
  - [net-next,V2,02/14] net/mlx5e: tc, Refactor peer add/del flow
    https://git.kernel.org/netdev/net-next/c/b1661efa4dbb
  - [net-next,V2,03/14] net/mlx5e: rep, store send to vport rules per peer
    https://git.kernel.org/netdev/net-next/c/ed7a8fe71836
  - [net-next,V2,04/14] net/mlx5e: en_tc, re-factor query route port
    https://git.kernel.org/netdev/net-next/c/0af3613ddc91
  - [net-next,V2,05/14] net/mlx5e: Handle offloads flows per peer
    https://git.kernel.org/netdev/net-next/c/9be6c21fdcf8
  - [net-next,V2,06/14] net/mlx5: E-switch, enlarge peer miss group table
    https://git.kernel.org/netdev/net-next/c/18e31d422675
  - [net-next,V2,07/14] net/mlx5: E-switch, refactor FDB miss rule add/remove
    https://git.kernel.org/netdev/net-next/c/9bee385a6e39
  - [net-next,V2,08/14] net/mlx5: E-switch, Handle multiple master egress rules
    https://git.kernel.org/netdev/net-next/c/5e0202eb49ed
  - [net-next,V2,09/14] net/mlx5: E-switch, generalize shared FDB creation
    https://git.kernel.org/netdev/net-next/c/014e4d48eaa3
  - [net-next,V2,10/14] net/mlx5: DR, handle more than one peer domain
    https://git.kernel.org/netdev/net-next/c/6d5b7321d8af
  - [net-next,V2,11/14] net/mlx5: Devcom, Rename paired to ready
    https://git.kernel.org/netdev/net-next/c/e67f928a5204
  - [net-next,V2,12/14] net/mlx5: E-switch, mark devcom as not ready when all eswitches are unpaired
    https://git.kernel.org/netdev/net-next/c/8611df722030
  - [net-next,V2,13/14] net/mlx5: Devcom, introduce devcom_for_each_peer_entry
    https://git.kernel.org/netdev/net-next/c/90ca127c62e9
  - [net-next,V2,14/14] net/mlx5: Devcom, extend mlx5_devcom_send_event to work with more than two devices
    https://git.kernel.org/netdev/net-next/c/e2a82bf8a428

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



