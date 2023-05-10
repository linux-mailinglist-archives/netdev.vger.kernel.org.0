Return-Path: <netdev+bounces-1381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 200196FDA6D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459C81C20AB4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684CD814;
	Wed, 10 May 2023 09:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4221D63E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE934C433D2;
	Wed, 10 May 2023 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683709821;
	bh=3cTWnsHN3p9/ww44MiPanUTDasdwb9LfTqr+hcVKyx8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eJwkC2D0mMU0zlJciAhuomReg8a7v5Y6XyOuVOzhXndOhqcnu+8B4/aN2vpIM5RDe
	 8z/Gq+BfKhuxhB+tEp9oNpOBLq05JQ1wDm5Bjmb8paRdj4xLRY/gZqZc957wunu6kp
	 arYOu56w9379Q85NIzLrJNCvJJl/HkgoiIn0UwZbDbBTPxcZxDEDhLDBLgB/+ZCLZs
	 2JLk3WQxpQZ3T92mvy9eh0un6EmTmi5HmABF7GO1lh+Oz5ohztqB1wsRsz/nq/kW1i
	 Orz9p/YL2dYCg2W7HpUqrWeMUIefBATRicZHooH6rlGfgvVohgvlb6LW+bXqPWYETG
	 veh+zGqHH1gJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF59EE270C4;
	Wed, 10 May 2023 09:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: deal with most data-races in sk_wait_event()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370982084.14294.6614472111493280299.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:10:20 +0000
References: <20230509182948.3793097-1-edumazet@google.com>
In-Reply-To: <20230509182948.3793097-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 18:29:48 +0000 you wrote:
> __condition is evaluated twice in sk_wait_event() macro.
> 
> First invocation is lockless, and reads can race with writes,
> as spotted by syzbot.
> 
> BUG: KCSAN: data-race in sk_stream_wait_connect / tcp_disconnect
> 
> [...]

Here is the summary with links:
  - [net] net: deal with most data-races in sk_wait_event()
    https://git.kernel.org/netdev/net/c/d0ac89f6f987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



