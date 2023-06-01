Return-Path: <netdev+bounces-7175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95BE671EFF2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC0F128186E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4BDA42520;
	Thu,  1 Jun 2023 17:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E0613AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95D0CC433EF;
	Thu,  1 Jun 2023 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685638820;
	bh=jEfoI3+DVV2+wS2pl8Bx6NvJ/ExNdYR+G5rMm+luVMw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cHdZ4f6ohbnmYu9iieP5SSqyJKJBjvi15CkLgHcui9GrIZ/+ADTormi3UtqEuqk79
	 VCiVXNa3roMLiBZVcGBbPiStbXBxds4CSx9UhWEJ2tCvDIEDK51pHTWp73wQoi0jU1
	 MuoWizVHigN8SEu39dV8q4JQFlHoAA2NfuE8Dypo3U1r0VR0YcESdkAFvq6hhjJQ4p
	 RD0/XD89fiSDXKvXEdHvaEoEWYB3U7LteywKSzLZOczX6JEr1+8lwm3diKp/UsxOew
	 pJ+vIfIElRY/qaJ1Gvxib2j9xv+GZQ2cvBAHiTRS8zbyutuckPlePV2BmB1mLIxx4g
	 h6ifqsSJIfcbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74E42C395E5;
	Thu,  1 Jun 2023 17:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: renesas: rswitch: Fix return value in error path of
 xmit
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168563882047.3073.5991587821781552018.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 17:00:20 +0000
References: <20230529073817.1145208-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230529073817.1145208-1-yoshihiro.shimoda.uh@renesas.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-renesas-soc@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 May 2023 16:38:17 +0900 you wrote:
> Fix return value in the error path of rswitch_start_xmit(). If TX
> queues are full, this function should return NETDEV_TX_BUSY.
> 
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/rswitch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: renesas: rswitch: Fix return value in error path of xmit
    https://git.kernel.org/netdev/net/c/a60caf039e96

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



