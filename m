Return-Path: <netdev+bounces-8767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59A87259FF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81A762812AD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02FB89445;
	Wed,  7 Jun 2023 09:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B1F8F6D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71D9EC433A1;
	Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686129620;
	bh=fdJJE28eu0CCgITk3WkkOxo2hdgrxL1EQHGX+EmMb+I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qq3+HFis5KHmfofA7TFebdkBfa3OrquqRx2anpYe+f4Y5L8YD/KF+7ENkdnEL5I4x
	 N8e71uYYc41KeAmabNneVT65PrgKuxUad4d9KG93DGrY/P5/DM+RRRXPb6PhGL3at7
	 etm65bpuQ3ueDd7pMul00zMqQWe5CRKMIyNPbAOhAoLn+qneKx0WnoM1MIL/vYpKJM
	 rInS8DMfPg/E+bNGnCoSI1Ml9u6E3w8tfpqKjpPlR7+jocByJYgZa1BXvXKL13B6Eb
	 2N6itU2fbhxTZ1tzaXne+KBQelmUV4P8gfPQ5xoFLnv8nMzyo3ATe71Vnw9vyj71RJ
	 pQj055ken3F2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A76CE29F39;
	Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: ocelot: unlock on error in
 vsc9959_qos_port_tas_set()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168612962036.23613.5611394372342298176.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 09:20:20 +0000
References: <ZH7tRX2weHlhV4hm@moroto>
In-Reply-To: <ZH7tRX2weHlhV4hm@moroto>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
 alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com, andrew@lunn.ch,
 f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, muhammad.husaini.zulkifli@intel.com,
 kurt@linutronix.de, gerhard@engleder-embedded.com, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 6 Jun 2023 11:24:37 +0300 you wrote:
> This error path needs call mutex_unlock(&ocelot->tas_lock) before
> returning.
> 
> Fixes: 2d800bc500fb ("net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a "cmd" enum")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: ocelot: unlock on error in vsc9959_qos_port_tas_set()
    https://git.kernel.org/netdev/net-next/c/cad7526f33ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



