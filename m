Return-Path: <netdev+bounces-525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13DBA6F7F46
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B86D1C21775
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D706FCC;
	Fri,  5 May 2023 08:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C994C97
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4AC2C4339E;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683276019;
	bh=s//jhL1QL9HBWOF95GECV05CZMiyv1ggxb0bVCpm1ps=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rck/zvnVqPoUSJIUpRWgIggMZNp8kSl4VQ51jhJBeE0rtlunACVirJ2T9iPMht89X
	 UBuxGMN8nDjKmdhZlMs3n+rOklckcdVWtQkz7Wyr+7aWWPHOZOOSPqnyLhIKKa2lB3
	 OTazGhgOI7YtObfODZZr/XO9sYeiOFl5ZFRbkevxV9TSbEXU8TLSpt1+LN2xgegVSY
	 eI34KLTuLAXMxr/WtvQTxvaOGp/+HXiib1/9kB+qaAAkENxdwvoCPY05u2nFRXNkaK
	 PcZHhoxZnAbLVoa1rpiCsfceosvMg/DLJF4+JbBZ4kEcCtRv4eK5mhY+WUQ9oIAc4U
	 OAFhhpE91fSpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88919E5FFC4;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: check the index of the SFI rather than the
 handle
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327601955.11276.10504111383601482585.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 08:40:19 +0000
References: <20230504080400.3036266-1-wei.fang@nxp.com>
In-Reply-To: <20230504080400.3036266-1-wei.fang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 May 2023 16:03:59 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> We should check whether the current SFI (Stream Filter Instance) table
> is full before creating a new SFI entry. However, the previous logic
> checks the handle by mistake and might lead to unpredictable behavior.
> 
> Fixes: 888ae5a3952b ("net: enetc: add tc flower psfp offload driver")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: check the index of the SFI rather than the handle
    https://git.kernel.org/netdev/net/c/299efdc2380a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



