Return-Path: <netdev+bounces-9502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBAC729779
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32F1B2818FF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72ED3DDA8;
	Fri,  9 Jun 2023 10:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B86E377
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BF27C4339B;
	Fri,  9 Jun 2023 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686307822;
	bh=l85ItVcFL5/r/0pp/ddXy/ZBIkYXxeHiyfXqVdsAj7s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GqPbooHKd3N6NXIrHzgoM96EYVML7u4qnsmC2oeJXSR5Qncuej2Ya1hGBrF2aw8FM
	 hwt6PedgFXN72fUzM4QGaNLDrIEVzk7eFJFwRrgPDqeaoVyTQLv0Z3FYvOX2rrSvyK
	 tta/QZUxn6lj+4162bsvlVrYkejXFmkAfnNp+IE33cSM7YnDq52h6JRApBTtPTT3MF
	 aJEuwG5zR5dvn+Gw+h/6NavTE5KXJbX3H09fXqsGbgOkXI012arjf175ApnSlkBLmQ
	 X+JCFIlI977oAIv16yTQkoouuVe0Vo/d4Ol+bCkxYWo4eckDqhKweeAUoXjuV4M09W
	 +QycmnqDPqaBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C6D9C43157;
	Fri,  9 Jun 2023 10:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] net/sched: cls_u32: Fix reference counter leak leading
 to overflow
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630782237.20473.1733377791755125144.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 10:50:22 +0000
References: <20230608072903.3404438-1-lee@kernel.org>
In-Reply-To: <20230608072903.3404438-1-lee@kernel.org>
To: Lee Jones <lee@kernel.org>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 08:29:03 +0100 you wrote:
> In the event of a failure in tcf_change_indev(), u32_set_parms() will
> immediately return without decrementing the recently incremented
> reference counter.  If this happens enough times, the counter will
> rollover and the reference freed, leading to a double free which can be
> used to do 'bad things'.
> 
> In order to prevent this, move the point of possible failure above the
> point where the reference counter is incremented.  Also save any
> meaningful return values to be applied to the return data at the
> appropriate point in time.
> 
> [...]

Here is the summary with links:
  - [v2,1/1] net/sched: cls_u32: Fix reference counter leak leading to overflow
    https://git.kernel.org/netdev/net/c/04c55383fa56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



