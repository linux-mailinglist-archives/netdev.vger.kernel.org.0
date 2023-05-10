Return-Path: <netdev+bounces-1358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE376FD958
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97FD1C20D0E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A6512B83;
	Wed, 10 May 2023 08:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BE714AA7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1629DC433D2;
	Wed, 10 May 2023 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683707423;
	bh=P7HU3QFCbKSNU/H/YHkyMx7ep5b9/fo9tC+vAkvIU7U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GJKEWTz2B2j6xn9QVevefKiAhpBX9dxwBuFeEGhiWfdkcwYfihbjfUdnSb5tX7HhG
	 vJzNpintsa8Co+/ONRiWiW+CoZel0csg7a3oiUGXPhIeoJNm96B8d0EaX2nOd2Pb7g
	 R0jo9USxnavR3bXhC2FsrpqK+IGAa/373RHxP54SsU04vt5kwMdNm/shbT3VnHdi3Q
	 8/X7CspcQN0EiAUUi8ENiBciHcP5JH2LNMdYjl+2jpl+mIL+bfUqTxAP5q9VU46jIi
	 8srz4OK+S8CtHbGteW1uTMjlpXIQBXa0vcd5etFZk8Mxe16XOhsRr5LpvuUjYHx9/M
	 NXUkbYhgnU1QA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFB34E501FE;
	Wed, 10 May 2023 08:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: annotate accesses to nlk->cb_running
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370742297.8895.15681416041937249294.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 08:30:22 +0000
References: <20230509165634.3154266-1-edumazet@google.com>
In-Reply-To: <20230509165634.3154266-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 16:56:34 +0000 you wrote:
> Both netlink_recvmsg() and netlink_native_seq_show() read
> nlk->cb_running locklessly. Use READ_ONCE() there.
> 
> Add corresponding WRITE_ONCE() to netlink_dump() and
> __netlink_dump_start()
> 
> syzbot reported:
> BUG: KCSAN: data-race in __netlink_dump_start / netlink_recvmsg
> 
> [...]

Here is the summary with links:
  - [net] netlink: annotate accesses to nlk->cb_running
    https://git.kernel.org/netdev/net/c/a939d14919b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



