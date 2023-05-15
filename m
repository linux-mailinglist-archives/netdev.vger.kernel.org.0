Return-Path: <netdev+bounces-2570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25728702899
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D575A281156
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B190C138;
	Mon, 15 May 2023 09:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C62CA92A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 305FBC433EF;
	Mon, 15 May 2023 09:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684143022;
	bh=wryPxyzuWtRfguvUKnsIPjJkMoSWBBMvMnNY8eD83w0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J6GMwhP0tkFJM/0C+FU/zwcClue9e/o2ulG+gLPYl7sthkID8SGVqEOjHwu8pdfWm
	 JV1m6xMO+b/HHHA8pioFtyRgEHsX5Gw3v18EISX9GkJuBkNfRCqTs3UTj/XeyPRyjz
	 OdmlNoHSrl5SGzLrLlSC1bdDC5aEsOv5ZsLT95AHHb6yPpokh/WHnJ58nvEu15I0Tt
	 fUHEsubl6gQW/YAB7u51IyO+2fpwrjq93Q82k7HLLmaWFjyOb9wKkdnCMa7XcE30rz
	 U8A5BacvqaFlU7vvxUoPcnGsHc/Qd8NjJRbWh0zF1nOe8rO8XnB3RLYdV8FQFzTF4P
	 fYl9N4o+oQpKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E75BC41672;
	Mon, 15 May 2023 09:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net 0/3] tipc: fix the mtu update in link mtu negotiation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168414302205.28617.5540005858466713219.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 09:30:22 +0000
References: <cover.1684093873.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1684093873.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
 davem@davemloft.net, kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
 jmaloy@redhat.com, tung.q.nguyen@dektech.com.au

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 14 May 2023 15:52:26 -0400 you wrote:
> This patchset fixes a crash caused by a too small MTU carried in the
> activate msg. Note that as such malicious packet does not exist in
> the normal env, the fix won't break any application
> 
> The 1st patch introduces a function to calculate the minimum MTU for
> the bearer, and the 2nd patch fixes the crash with this helper. While
> at it, the 3rd patch fixes the udp bearer mtu update by netlink with
> this helper.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net,1/3] tipc: add tipc_bearer_min_mtu to calculate min mtu
    https://git.kernel.org/netdev/net/c/3ae6d66b605b
  - [PATCHv3,net,2/3] tipc: do not update mtu if msg_max is too small in mtu negotiation
    https://git.kernel.org/netdev/net/c/56077b56cd3f
  - [PATCHv3,net,3/3] tipc: check the bearer min mtu properly when setting it by netlink
    https://git.kernel.org/netdev/net/c/35a089b5d793

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



