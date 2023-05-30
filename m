Return-Path: <netdev+bounces-6238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B41177154DD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED4A81C20B6B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4CC63A9;
	Tue, 30 May 2023 05:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218BC4A16
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6F66C4339E;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685424019;
	bh=789DvLenH8SDciB6rqzFnZ2vrTaDsz/+ZPp+0Vf4o7A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KJULkOujoMxUm3y75zsW9VSVIO7vF0v4is8bFIjbBXDe0XlTS2Stau73DtrSHn95z
	 wC8Gcph5apqbEutg5oRRdptZw0i9oqB21IlxKcLi2jTawBHD3iYbdQWZMqQX0JiDTz
	 gjWLFuooHj9CB5wjAoqtUZLJS7LG/Z99nziCcgto4mtWubxIPoO8X6jV/KGdq2c/z3
	 imz+8SQMsFYZvget2TrogyAxB2exSZNYXZzgwXWfuUqrMPxuX7XoH9IejWLMfZAcGa
	 AH7eixk5rqB+BTTVK0SIs+XbyP70TWr7ItT5ON44G7dr7XTYSZbWZp6r7/DGuYMa2t
	 etEwVY2UnJpCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAC5AE52BF4;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: specs: correct types of legacy arrays
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542401969.30709.4870115350727280189.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:20:19 +0000
References: <20230526220653.65538-1-kuba@kernel.org>
In-Reply-To: <20230526220653.65538-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, sdf@google.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 15:06:53 -0700 you wrote:
> ethtool has some attrs which dump multiple scalars into
> an attribute. The spec currently expects one attr per entry.
> 
> Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: sdf@google.com
> 
> [...]

Here is the summary with links:
  - [net] netlink: specs: correct types of legacy arrays
    https://git.kernel.org/netdev/net/c/0684f29a89e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



