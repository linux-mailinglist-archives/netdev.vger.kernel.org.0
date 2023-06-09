Return-Path: <netdev+bounces-9412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA41C728DA0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0EB81C2106C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E381100;
	Fri,  9 Jun 2023 02:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621F810F9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D89DDC433D2;
	Fri,  9 Jun 2023 02:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686276620;
	bh=J8gQty/mo9bQSexp/ySEnHjaP4gVAtHFCbatv31Uvlg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UYJKaYjV4IkUIz3VdedfgM8hu6uF9HzQqQaIXzE9dkAmsWoJKtOevVLhbVvTGkMEL
	 honpe+f3xQ5+OmWtBJCtHxlW9YTzC2TwKa39b5CVMAuJIagvH1MT0Ob0EWJQB2BLCf
	 vGkht+dst8V9/p5HZ0mkbVUuVYKVMfbDOP4mvyxFEvzYPzGh445F6e0dd9AsxZzm1l
	 SOlSkilp8SGhMEA3MNn74n4axRQert0ZJweBHR9r+17QjV29fU4rBSoMyGuk8yY7Wn
	 RU/k6jaT+mQjkjT19HxMkZrpIlq6OTHAvhky5Q2U9s82mRCduqt/zBF3Kij718alT5
	 h+/0znXkXigww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C09F9E87232;
	Fri,  9 Jun 2023 02:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ping6: Fix send to link-local addresses with VRF.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627662078.28781.13366253249320555841.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:10:20 +0000
References: <6c8b53108816a8d0d5705ae37bdc5a8322b5e3d9.1686153846.git.gnault@redhat.com>
In-Reply-To: <6c8b53108816a8d0d5705ae37bdc5a8322b5e3d9.1686153846.git.gnault@redhat.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
 lorenzo@google.com, mirsad.todorovac@alu.unizg.hr

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 7 Jun 2023 18:05:02 +0200 you wrote:
> Ping sockets can't send packets when they're bound to a VRF master
> device and the output interface is set to a slave device.
> 
> For example, when net.ipv4.ping_group_range is properly set, so that
> ping6 can use ping sockets, the following kind of commands fails:
>   $ ip vrf exec red ping6 fe80::854:e7ff:fe88:4bf1%eth1
> 
> [...]

Here is the summary with links:
  - [net] ping6: Fix send to link-local addresses with VRF.
    https://git.kernel.org/netdev/net/c/91ffd1bae1da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



