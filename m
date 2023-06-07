Return-Path: <netdev+bounces-9032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6688B726A47
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 128562813EC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CF234D8D;
	Wed,  7 Jun 2023 20:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DCC107A1
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29900C4339C;
	Wed,  7 Jun 2023 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686168022;
	bh=kvTcG7uCeC1qSv4dTE0JK1KGiAQboo/EL1MeVKPDA1I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PBrbki7+J50bhDUPveRFfrpeBepRwTfqDmBqqQCm1dUdsgR4wab9HXcdFJYVjupLk
	 Q1nPHdNqOoSMfQMhsmC9eFM4DuXHwqsiueBfWi8BZU+/cMn61IDPxHnOvrmDmL6b4e
	 UBntg18SPmt0vImUE+dTTIbA1IP1Ip1wRg/fp+BPDBO4yjYvLGU6DgF4LCyFiAVHvd
	 oy1/5CHjSPFxxqJ7eGhz8/U/PTx+G2YSgHHeAwh3jF6WQAzIi5wVCykx9htWcBNj63
	 RVPPmYNwSUlQgVjB4VeFSHcgupINjzpv4myBHJ+zVjgZj0LTq7OTKNU5cXjSxgFA5+
	 zq1AD5Xlq4CVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09BDCE29F39;
	Wed,  7 Jun 2023 20:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] tools: ynl: generate code for the handshake
 family
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168616802203.21879.18230905703022473404.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 20:00:22 +0000
References: <20230606194302.919343-1-kuba@kernel.org>
In-Reply-To: <20230606194302.919343-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, sdf@google.com, willemdebruijn.kernel@gmail.com,
 chuck.lever@oracle.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Jun 2023 12:42:59 -0700 you wrote:
> Add necessary features and generate user space C code for serializing
> / deserializing messages of the handshake family.
> 
> In addition to basics already present in netdev and fou, handshake
> has nested attrs and multi-attr u32.
> 
> Jakub Kicinski (3):
>   tools: ynl-gen: fill in support for MultiAttr scalars
>   tools: ynl-gen: improve unwind on parsing errors
>   tools: ynl: generate code for the handshake family
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] tools: ynl-gen: fill in support for MultiAttr scalars
    https://git.kernel.org/netdev/net-next/c/2cc9671a82e3
  - [net-next,2/3] tools: ynl-gen: improve unwind on parsing errors
    https://git.kernel.org/netdev/net-next/c/58da455b31ba
  - [net-next,3/3] tools: ynl: generate code for the handshake family
    https://git.kernel.org/netdev/net-next/c/7a11f70ce882

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



