Return-Path: <netdev+bounces-2363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8DA70181C
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21C701C20C11
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 16:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F8A63CA;
	Sat, 13 May 2023 16:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559E022638
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 16:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7FB8C433EF;
	Sat, 13 May 2023 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683993620;
	bh=OBQXYjnzvBCz//QVw5U96LbFG3kePuK0YewAYoaJY/w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uxxidJ0zyXa7TTz0zBpf2p7wJyFOiAq/Ch/9WQ0yivV0ewE5OfDwL2r/KfVx3/BX/
	 qdZcf4gYJsXHhQT+aLrX6j8ayKlFIElismKbxMDaU/30fc3Gr31i+fdI7hylO5LEGZ
	 NB4OwXtj7TQwFcE2pTaCjum5YjnSwfyw3xOKLdKbEiiOSaKaqkTvQRKINl0Ss+ppxQ
	 k92PYo6bsmwbJ+sM/fm2k031NKIMvN3Hpvz7DSvaX+PEmwRNSkUowBH0rqd+VbmGZb
	 7pbVz//spvlJaVPX0hk0kNkoWviXM1VjcYrbAm/F9pxbD1ngVc1gjwnFz6dzFchryS
	 r7ybP8Rpp49Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC63DE49F61;
	Sat, 13 May 2023 16:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] erspan: get the proto with the md version for collect_md
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168399361982.27018.2771399044997158171.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 16:00:19 +0000
References: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
In-Reply-To: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com, u9012063@gmail.com,
 ktraynor@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 19:22:11 -0400 you wrote:
> In commit 20704bd1633d ("erspan: build the header with the right proto
> according to erspan_ver"), it gets the proto with t->parms.erspan_ver,
> but t->parms.erspan_ver is not used by collect_md branch, and instead
> it should get the proto with md->version for collect_md.
> 
> Thanks to Kevin for pointing this out.
> 
> [...]

Here is the summary with links:
  - [net] erspan: get the proto with the md version for collect_md
    https://git.kernel.org/netdev/net/c/d80fc101d2eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



