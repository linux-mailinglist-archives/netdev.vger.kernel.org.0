Return-Path: <netdev+bounces-9130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7039727671
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67B5A28162D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B354C75;
	Thu,  8 Jun 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D863A54
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BFF8C433EF;
	Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686200423;
	bh=u6gKiDY/HsEUHdRq8tbpupxV7SXGRVcLLZSbJkFwsS8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=I1oRQak/+uFzko5FE0Pmz5GM1pd6Bj2Wbo37WxJr6NhpWcou97N4jHFsdJNuJx9Tz
	 CaeNWZk4GmcQmt7kRirQHZnA7wrY51vTpejJwFDMNyi1W39Ejp+9TF/0v5Ukyl4DzF
	 YV807/eIAa4ZfM/MVdsXsa8+4q44VGPajT8QFumyJNCG/CbKy69sX0JpobQVY1B7t/
	 TKxYAuJ9eHyG/elj38hi1UqJ9rxXoBcFNOekrHYKpvLdKaJyswP/k2OCSk0/cVMtwe
	 hc6QVXe+QcKU/FI4bEFPySoD5pgacnVUt4kR3XlFzcfZCbVCvMSbHUle68NWt/IrAC
	 70AaPClVNjVmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFB12E87232;
	Thu,  8 Jun 2023 05:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed work
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168620042291.23382.13609079860562597568.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 05:00:22 +0000
References: <20230607155515.548120-2-sw@simonwunderlich.de>
In-Reply-To: <20230607155515.548120-2-sw@simonwunderlich.de>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
 b.a.t.m.a.n@lists.open-mesh.org, VEfanov@ispras.ru, stable@kernel.org,
 sven@narfation.org

Hello:

This patch was applied to netdev/net.git (main)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Wed,  7 Jun 2023 17:55:15 +0200 you wrote:
> From: Vladislav Efanov <VEfanov@ispras.ru>
> 
> Syzkaller got a lot of crashes like:
> KASAN: use-after-free Write in *_timers*
> 
> All of these crashes point to the same memory area:
> 
> [...]

Here is the summary with links:
  - [1/1] batman-adv: Broken sync while rescheduling delayed work
    https://git.kernel.org/netdev/net/c/abac3ac97fe8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



