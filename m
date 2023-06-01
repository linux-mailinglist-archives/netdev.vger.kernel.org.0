Return-Path: <netdev+bounces-6988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED80F71926E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7FCD28152C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E308563CE;
	Thu,  1 Jun 2023 05:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D806FAD
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 637D9C433A1;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685598021;
	bh=BSGAfQhQWaZ756Dtcan0xa4gVmkr71bkiJUQtAYPcKw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bqUMGWS2o25dyvmCrtjeRpFpBApEq5Y/e4GKNPTm1WH2R3U40gBL45gEsRYByuh7v
	 LCdWmkuI9+WaZJ69q+AkC7hwqn/ORgZ6i/LzMUL7TrApcUncQy7CtN7iJyDEDl8Esw
	 JYWHl3UA8hHIuR6UJVS9o8zd/x4he7wzZ9XhOO/SoZyW/lFMv1LqGsRLLpX+IuZiJO
	 6gs5nLsmHABGMAc9F3lK7lRuY57vDqKBvlogvT68cReCEBUaUsd6TFqToWVG/b+3is
	 3jsNmzRepk/C2XIL6kvTRBIdcQO9ur/xIXxWRj6wiAxXgRsW/5qHPSo2vLgBLGz1fi
	 W3J0UX+Tv4tww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36F24C395E0;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: don't set sw irq coalescing defaults in case of
 PREEMPT_RT
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168559802121.10778.8924720221819404658.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 05:40:21 +0000
References: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
In-Reply-To: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 28 May 2023 19:39:59 +0200 you wrote:
> If PREEMPT_RT is set, then assume that the user focuses on minimum
> latency. Therefore don't set sw irq coalescing defaults.
> This affects the defaults only, users can override these settings
> via sysfs.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: don't set sw irq coalescing defaults in case of PREEMPT_RT
    https://git.kernel.org/netdev/net-next/c/748b442800e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



