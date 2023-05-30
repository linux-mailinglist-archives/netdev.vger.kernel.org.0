Return-Path: <netdev+bounces-6242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE707154E4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9B87281087
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFEB8F4F;
	Tue, 30 May 2023 05:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF2863A7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAD77C433A8;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685424020;
	bh=w0mOgrWAeAFdZnbLA1XPu9yCI6mqPJ60iZ+YBRAlh4E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BYS+FCdQk74tcsso8EfLNCdAI+3bCdckAqiThkDz4pJwPiqoY6cvnUsAkU0fTz3vb
	 aSyfy8xOIqaWkCtMlIlEEu9eZaNFYRePnA5rPTcAr2fygrLn/0ZWxr2YE6glTbPG4N
	 iTYsK+Ph4Tkiip50jlQgklCRpXx5YAfU9No9UkYoEh+6iIextkTjzF8o6jWodf9JKb
	 IltrmoZBUiWPOF/Xjx73a9PxGyQQ/uhO2Bh/da3SGY8F+Bn7Z9U1/ulgaIZ/y2FXtw
	 /FI5nq+UgLYzvW26WGhqiqsyXEf4fVo9PyTyclMDHEcDqFWX1jo5gv/yOnfMhO0CUH
	 wg7nvGXXuCYPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA3EEE52BFB;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: deny tcp_disconnect() when threads are waiting
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542401982.30709.2030003752677217123.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:20:19 +0000
References: <20230526163458.2880232-1-edumazet@google.com>
In-Reply-To: <20230526163458.2880232-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 16:34:58 +0000 you wrote:
> Historically connect(AF_UNSPEC) has been abused by syzkaller
> and other fuzzers to trigger various bugs.
> 
> A recent one triggers a divide-by-zero [1], and Paolo Abeni
> was able to diagnose the issue.
> 
> tcp_recvmsg_locked() has tests about sk_state being not TCP_LISTEN
> and TCP REPAIR mode being not used.
> 
> [...]

Here is the summary with links:
  - [net] tcp: deny tcp_disconnect() when threads are waiting
    https://git.kernel.org/netdev/net/c/4faeee0cf8a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



