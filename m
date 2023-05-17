Return-Path: <netdev+bounces-3332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973AC7067A4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81E831C20D05
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E3531112;
	Wed, 17 May 2023 12:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D302C756
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8985C433EF;
	Wed, 17 May 2023 12:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684325422;
	bh=rTEeRjre8uXSMoFKQkAKOghTLaXoLcZUibAQw67VgPU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RfWKoqxLQK2mbyL+uTpHfi5JLiBt3vMHbeDJnAFh7aMQF4TkKNHqMD1vLTIoU+D4p
	 VZq5h0l/6m7Q4xPmvDGE1zgE63rQfekA4+X+e4kbuFs9mvCWM8io2jt0++GQGgOaDj
	 j2AyqtqfN2uUF4OCnC6jkUI2uWNVknwnnA3RUgr9Xdo5MGDGbOounjlU9/ST947JEe
	 MqFOVJF97MlYWcZlq6USr9i1fTHkhS9x49BDNdrIcAlzttLPf4AHMh0ReZfUkXhu9Y
	 IP8UbXlJs7BGT5yiq74r1L6i+RykCmePCtFh3iu93R8NL0KEEqxFIgldpd2MNpiHy6
	 VaVarxpYGKt9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0339E5421C;
	Wed, 17 May 2023 12:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/pppoe: make number of hash bits configurable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168432542271.5953.3107796853932406707.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 12:10:22 +0000
References: <E1pzFCV-0005Ly-U7@plastiekpoot>
In-Reply-To: <E1pzFCV-0005Ly-U7@plastiekpoot>
To: Jaco Kroon <jaco@uls.co.za>
Cc: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 May 2023 10:00:03 +0200 you wrote:
> When running large numbers of pppoe connections, a bucket size of 16 may
> be too small and 256 may be more appropriate.  This sacrifices some RAM
> but should result in faster processing of incoming PPPoE frames.
> 
> On our systems we run upwards of 150 PPPoE connections at any point in
> time, and we suspect we're starting to see the effects of this small
> number of buckets.
> 
> [...]

Here is the summary with links:
  - net/pppoe: make number of hash bits configurable
    https://git.kernel.org/netdev/net-next/c/96ba44c637b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



