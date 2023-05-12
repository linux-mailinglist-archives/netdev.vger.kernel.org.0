Return-Path: <netdev+bounces-2058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9663A700212
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52689281A0C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AB4A93A;
	Fri, 12 May 2023 08:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152668F78
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C875AC433A8;
	Fri, 12 May 2023 08:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683878422;
	bh=LDjSMVlk6hEyQz1Jn40BWv7GGnkpja4PLKKXNEDNXE0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LNbt3XqJvMi+P0tcKcY3KO8LD+rsePmKgBFcBQnz6EYV/RxFfWt/dBdLFvZM0YXsG
	 ovkj63JI/Ql8jgTGiZtrWDCRcLymKOtXo36qfW+sIgOjR/RLgfxbEmteBgbxd9atTD
	 3vPFH3bhfxSmUSa2TZWieu7mlef9h2KgW8d83CdSB/VsXliwaxENBl6p3OXLloOS3m
	 98nNWTm2JooGHkfsNldWFUGnEdCSzWMHfrFsj7YYpG/9q1S4xrk3QKysdHO3JJHviS
	 xSRY0BDXxQIMvN53zysAOfDaAWHLUKNvSbGCr/NPwgZRFp7Jh0nv+S+G6mJ3a0mars
	 MgsoWYzdYkHKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE363E501FB;
	Fri, 12 May 2023 08:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: sctp: move Neil to CREDITS
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168387842271.16770.9974713406645074697.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:00:22 +0000
References: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
In-Reply-To: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, lucien.xin@gmail.com, nhorman@tuxdriver.com,
 davem@davemloft.net, pabeni@redhat.com, kuba@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 19:42:43 -0300 you wrote:
> Neil moved away from SCTP related duties.
> Move him to CREDITS then and while at it, update SCTP
> project website.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> I'm not sure about other subsystems, but he hasn't been answering for a
> while.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: sctp: move Neil to CREDITS
    https://git.kernel.org/netdev/net/c/d03a2f17627e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



