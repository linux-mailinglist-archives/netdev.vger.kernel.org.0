Return-Path: <netdev+bounces-754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC2A6F98C6
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 16:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1A6C280E96
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 14:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F4F523E;
	Sun,  7 May 2023 14:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF59290A
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 14:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EB36C4339B;
	Sun,  7 May 2023 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683468019;
	bh=1/JF47CTaxbLyrxCk99uwoFWYDlV74iG1o6Q60yoz/g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SNqzXzx7YBrNKh2tx7t3ZOYb6YSlbnlZ1dOr2jdnZfmNNdmGG1N7tJaSK+NaAY37j
	 fkbjMD9akQ2S7daFSxETXeli15j+TpQSWUzAKejMbICKroUjbDBSVoVuUXCqcZCLJ4
	 x+zjzI7GyJoR9bcchYliNP56eG6csAuPCXkOCgXkF1k/61o7f/nqe2lppsMd4DUfzO
	 +I5g7h1//EDbSW1TT/iIav+pooJj6NcmOFJejNAkAb/5DsMTlE3AtbbL9Je3RIexQe
	 tgXja50VMqoRm7LwiGICpKbQfPqm0vFy33Ib8bKHBuQ+HXEnFKE2fYkpiWHyEZnrta
	 dEtifbHM+Z/ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DC9CE5FFCC;
	Sun,  7 May 2023 14:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: skb_partial_csum_set() fix against transport header
 magic value
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168346801918.32578.13844111891609838750.git-patchwork-notify@kernel.org>
Date: Sun, 07 May 2023 14:00:19 +0000
References: <20230505170618.650544-1-edumazet@google.com>
In-Reply-To: <20230505170618.650544-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com,
 willemb@google.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 May 2023 17:06:18 +0000 you wrote:
> skb->transport_header uses the special 0xFFFF value
> to mark if the transport header was set or not.
> 
> We must prevent callers to accidentaly set skb->transport_header
> to 0xFFFF. Note that only fuzzers can possibly do this today.
> 
> syzbot reported:
> 
> [...]

Here is the summary with links:
  - [net] net: skb_partial_csum_set() fix against transport header magic value
    https://git.kernel.org/netdev/net/c/424f8416bb39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



