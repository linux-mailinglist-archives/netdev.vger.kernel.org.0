Return-Path: <netdev+bounces-6241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7553C7154E3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31A7D281067
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70807479;
	Tue, 30 May 2023 05:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2CE63A5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D759AC433A1;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685424019;
	bh=NnQHZLuhsv6fhMvWlAxudMLQd5/YTw+cAZOpa9nxE9E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mVM7JszOzecVqhhv/Pn/K3goExFpHK0HNR7RZG2bHRM45TOmppSCca5JurHulG7+B
	 ZR3XfQ/VLHnAfwBV8RZ4We7fVydZYZ2kM0041puNYwRPZYe8FRsfS7exaDr4Ckdwhw
	 38CMg7mvaCETKsz7Bz2RWOKDFqlQ/3oBCbXjaEB+7eGPB2foRQeaFRdYJ71SuIKusi
	 JusWSvaoWXedSaKb8kJUquP+uS238PVwURsDm6cbB0atBFZ0HtaTZemlO1GICFhxqs
	 xRWvmGPY+aHX32vjNZDuUcfzZwbtzG92ZlY7q7DJSLMeRzdTI1pfD1vAXsK3KeLiy8
	 EvbwPFPFU86dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4C55E52BF9;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_packet: do not use READ_ONCE() in packet_bind()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542401973.30709.17193286061562512197.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:20:19 +0000
References: <20230526154342.2533026-1-edumazet@google.com>
In-Reply-To: <20230526154342.2533026-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, kuniyu@amazon.com,
 willemb@google.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 15:43:42 +0000 you wrote:
> A recent patch added READ_ONCE() in packet_bind() and packet_bind_spkt()
> 
> This is better handled by reading pkt_sk(sk)->num later
> in packet_do_bind() while appropriate lock is held.
> 
> READ_ONCE() in writers are often an evidence of something being wrong.
> 
> [...]

Here is the summary with links:
  - [net] af_packet: do not use READ_ONCE() in packet_bind()
    https://git.kernel.org/netdev/net/c/6ffc57ea0042

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



