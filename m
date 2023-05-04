Return-Path: <netdev+bounces-261-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F8D76F6802
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3637280CC8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1704C66;
	Thu,  4 May 2023 09:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB488A2D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8413BC433D2;
	Thu,  4 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683191421;
	bh=joHPPU/3x0qCSXV2ad98zX5PwaX7fzHVNn5m1qSwO6I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SHpxKuI4RXF4fqoSYKRkSPIe9rOVaPTilVmVIlEYlmlp/M+vb6/ySJe9Gfre19Qvf
	 9h9U6AiUBuekMjTw51WBQO8/f1H5v4BgHSEvScT6RaxrgY/zamtE3PXzGaCOfRKVgl
	 Z0P1egB5Qgi+xikHncSro9T7fLc2nVA5H4VGVEVc9sUW0mtAyiTjdRu627D43hRh/8
	 4fjx0G+vHLZg1KG3ctILxu3Ru6kSRJckwoJTa9aEViKN+uWBh4BnYKmDdQyYg9umV3
	 Yg5VkObu3S41tDp02tWOZSMDlrUga8xqUn1ef9pItNtELuIVPMMZpCQ8uRPOyxfe/m
	 R4WaycEJgA2og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6617BC395C8;
	Thu,  4 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: fix ct untracked match breakage
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168319142141.23388.7612293400133775589.git-patchwork-notify@kernel.org>
Date: Thu, 04 May 2023 09:10:21 +0000
References: <20230503201143.12310-2-pablo@netfilter.org>
In-Reply-To: <20230503201143.12310-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  3 May 2023 22:11:43 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> "ct untracked" no longer works properly due to erroneous NFT_BREAK.
> We have to check ctinfo enum first.
> 
> Fixes: d9e789147605 ("netfilter: nf_tables: avoid retpoline overhead for some ct expression calls")
> Reported-by: Rvfg <i@rvf6.com>
> Link: https://marc.info/?l=netfilter&m=168294996212038&w=2
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nf_tables: fix ct untracked match breakage
    https://git.kernel.org/netdev/net/c/f057b63bc11d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



