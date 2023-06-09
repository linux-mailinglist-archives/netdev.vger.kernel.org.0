Return-Path: <netdev+bounces-9738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A95B72A595
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C875B1C211F1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5571023C79;
	Fri,  9 Jun 2023 21:50:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AB421069
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BD49C4339B;
	Fri,  9 Jun 2023 21:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347424;
	bh=u0v+6Tzwd4r8nRJeJz6qhnO/zkWaP5iuiyF6rq4MSLs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=JdLeVJeZb8Efr5mHaceugpT4jpA6JhP+yd8vr0q8hhUcdgsateuVQUI1Hx0GuwueQ
	 meZ+mh/sDNrxqiXxBZ8fXDqpwBgR3lWTogGh+BOcuYI3NqP1quNwc4f4gZn7znbfpL
	 OC3G2Fy28Dg8oP1WBkxU9dj3pHUPW9CSZ1tBcY5IIDBXcbZ1FlYACOIF8ltQ0JOQnE
	 kGwy/LLZAWVoDVKwO41vkz8wMduewDM4rN0B/XYjm3IDam2UidXyuR3J7kVluanC9i
	 B8C0jbXUMIgBL2XtlbC415QVqu5wcXhD8IoM8t6hLXj/+aEyospioStPlLr4M9/Uj5
	 0SjweT2YaMabw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2567BC395F3;
	Fri,  9 Jun 2023 21:50:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] tools: ynl-gen: code gen improvements before
 ethtool
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168634742414.21323.9316483397365131162.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 21:50:24 +0000
References: <20230608211200.1247213-1-kuba@kernel.org>
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Jun 2023 14:11:48 -0700 you wrote:
> I was going to post ethtool but I couldn't stand the ugliness
> of the if conditions which were previously generated.
> So I cleaned that up and improved a number of other things
> ethtool will benefit from.
> 
> Jakub Kicinski (12):
>   tools: ynl-gen: cleanup user space header includes
>   tools: ynl: regen: cleanup user space header includes
>   tools: ynl-gen: complete the C keyword list
>   tools: ynl-gen: combine else with closing bracket
>   tools: ynl-gen: get attr type outside of if()
>   tools: ynl: regen: regenerate the if ladders
>   tools: ynl-gen: stop generating common notification handlers
>   tools: ynl: regen: stop generating common notification handlers
>   tools: ynl-gen: sanitize notification tracking
>   tools: ynl-gen: support code gen for events
>   tools: ynl-gen: don't pass op_name to RenderInfo
>   tools: ynl-gen: support / skip pads on the way to kernel
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] tools: ynl-gen: cleanup user space header includes
    https://git.kernel.org/netdev/net-next/c/30b5c720e1a9
  - [net-next,02/12] tools: ynl: regen: cleanup user space header includes
    https://git.kernel.org/netdev/net-next/c/9b52fd4b6305
  - [net-next,03/12] tools: ynl-gen: complete the C keyword list
    https://git.kernel.org/netdev/net-next/c/820343ccbb2e
  - [net-next,04/12] tools: ynl-gen: combine else with closing bracket
    https://git.kernel.org/netdev/net-next/c/2c0f1466867c
  - [net-next,05/12] tools: ynl-gen: get attr type outside of if()
    https://git.kernel.org/netdev/net-next/c/e4ea3cc68472
  - [net-next,06/12] tools: ynl: regen: regenerate the if ladders
    https://git.kernel.org/netdev/net-next/c/7234415b8f86
  - [net-next,07/12] tools: ynl-gen: stop generating common notification handlers
    https://git.kernel.org/netdev/net-next/c/f2ba1e5e2208
  - [net-next,08/12] tools: ynl: regen: stop generating common notification handlers
    https://git.kernel.org/netdev/net-next/c/d0915d64c3a6
  - [net-next,09/12] tools: ynl-gen: sanitize notification tracking
    https://git.kernel.org/netdev/net-next/c/ced1568862bd
  - [net-next,10/12] tools: ynl-gen: support code gen for events
    https://git.kernel.org/netdev/net-next/c/6da3424fd629
  - [net-next,11/12] tools: ynl-gen: don't pass op_name to RenderInfo
    https://git.kernel.org/netdev/net-next/c/6f96ec73cb5a
  - [net-next,12/12] tools: ynl-gen: support / skip pads on the way to kernel
    https://git.kernel.org/netdev/net-next/c/76abff37f0d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



