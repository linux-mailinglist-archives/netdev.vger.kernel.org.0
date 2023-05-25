Return-Path: <netdev+bounces-5280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BB57108B3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAB1B28143D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58A6D539;
	Thu, 25 May 2023 09:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4BA1FCC
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5368C4339B;
	Thu, 25 May 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685006421;
	bh=Ue6ZGRjbx0TiX+0KLrNoGx8KRmk2/pbu2LdCfUNEwrU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=G/dOpK5GJyAJ1gpTJMVEy/glxn9inVsFk/KX35XD5sjQDMGyMeijob0u5rjj+CRAX
	 +BKCXMOgytAaCTwVRJCmJv8/GR6/l8MmQUTSESKZNwHMaf64lsBpFRwLmh1/jJa+fn
	 zI7RV6tOYxEDlCBBMXNdM8CANff6PWSzvkboy2wmEDA+Cb2YyJbO7e4zcQA2nLIINp
	 R5Jy1RxekWMnHpKdY9mmub8fXJ19zQO5pdIjrXxpkQtmaXM0YDOsYz1E7rQ3g6lnbK
	 bKiWUas9Zvh4XOu798ZiHdbMYBIRn1rzS5M8Lh4/USbWnFz0dhwI5G5kCNsfgbSOMq
	 xR/k+W4sUv3IQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB24BE4D023;
	Thu, 25 May 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] udplite: Fix NULL pointer dereference in
 __sk_mem_raise_allocated().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168500642082.5673.17391735214772212214.git-patchwork-notify@kernel.org>
Date: Thu, 25 May 2023 09:20:20 +0000
References: <20230523163305.66466-1-kuniyu@amazon.com>
In-Reply-To: <20230523163305.66466-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org,
 syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 23 May 2023 09:33:05 -0700 you wrote:
> syzbot reported [0] a null-ptr-deref in sk_get_rmem0() while using
> IPPROTO_UDPLITE (0x88):
> 
>   14:25:52 executing program 1:
>   r0 = socket$inet6(0xa, 0x80002, 0x88)
> 
> We had a similar report [1] for probably sk_memory_allocated_add()
> in __sk_mem_raise_allocated(), and commit c915fe13cbaa ("udplite: fix
> NULL pointer dereference") fixed it by setting .memory_allocated for
> udplite_prot and udplitev6_prot.
> 
> [...]

Here is the summary with links:
  - [v1,net] udplite: Fix NULL pointer dereference in __sk_mem_raise_allocated().
    https://git.kernel.org/netdev/net/c/ad42a35bdfc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



