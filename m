Return-Path: <netdev+bounces-3834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 837F37090FD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D487281B2A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E45120F7;
	Fri, 19 May 2023 07:50:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D706C17F8
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E420C4339C;
	Fri, 19 May 2023 07:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684482633;
	bh=eZ0b0lnAue+o0nlpcb20dRJGNVvF4y4g+hHjurplHi4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LK2dXXVQMRCnJrEmOb6rFRIsSs7bbuknd31baxKchSHWMQLT7Ru4LoRuk+dRGgxZs
	 SwcYWJ0VjxnXU43PcCkxbgLnsuPUmGkzqmA3v/kuQBX833zN0ZffUTb7Xgxa+CMzKa
	 9iD7ciFXe0mCxlSyxIBYWac6D78k8CZ1M5n08ffQzKydVcrl9DiNYNRZ8MyXXx202E
	 FvoAEyAuKZHHFbsSlCjWv5O0q5t0Iw7GkYvezY37OOr1pnPEmBL7gCVTG+UXdbjwkh
	 vYhsxpYsFuuzpbJgb77klR8hayHofUoJNSMcGqR6vO5QAiPqYMLgZ0JYW/T458tw2E
	 7ACVJ34qwC0qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 610CAC73FE2;
	Fri, 19 May 2023 07:50:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] tls: rx: strp: fix inline crypto offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448263339.27405.11276578123661889710.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 07:50:33 +0000
References: <20230517015042.1243644-1-kuba@kernel.org>
In-Reply-To: <20230517015042.1243644-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
 tariqt@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 18:50:35 -0700 you wrote:
> The local strparser version I added to TLS does not preserve
> decryption status, which breaks inline crypto (NIC offload).
> 
> Jakub Kicinski (7):
>   tls: rx: device: fix checking decryption status
>   tls: rx: strp: set the skb->len of detached / CoW'ed skbs
>   tls: rx: strp: force mixed decrypted records into copy mode
>   tls: rx: strp: fix determining record length in copy mode
>   tls: rx: strp: factor out copying skb data
>   tls: rx: strp: preserve decryption status of skbs when needed
>   tls: rx: strp: don't use GFP_KERNEL in softirq context
> 
> [...]

Here is the summary with links:
  - [net,1/7] tls: rx: device: fix checking decryption status
    https://git.kernel.org/netdev/net/c/b3a03b540e3c
  - [net,2/7] tls: rx: strp: set the skb->len of detached / CoW'ed skbs
    https://git.kernel.org/netdev/net/c/210620ae44a8
  - [net,3/7] tls: rx: strp: force mixed decrypted records into copy mode
    https://git.kernel.org/netdev/net/c/14c4be92ebb3
  - [net,4/7] tls: rx: strp: fix determining record length in copy mode
    https://git.kernel.org/netdev/net/c/8b0c0dc9fbbd
  - [net,5/7] tls: rx: strp: factor out copying skb data
    https://git.kernel.org/netdev/net/c/c1c607b1e5d5
  - [net,6/7] tls: rx: strp: preserve decryption status of skbs when needed
    https://git.kernel.org/netdev/net/c/eca9bfafee3a
  - [net,7/7] tls: rx: strp: don't use GFP_KERNEL in softirq context
    https://git.kernel.org/netdev/net/c/74836ec828fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



