Return-Path: <netdev+bounces-10014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F229672BAF7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C474D281008
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72868156FC;
	Mon, 12 Jun 2023 08:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA7F11CB4;
	Mon, 12 Jun 2023 08:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9344C433AF;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559222;
	bh=XIyenNciiiJDChhRpT8N9ii7Sgal6DCbgkC2n7EXesM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=So3aY0ySSEkL2cF8EngCzh937wqi3oDmCxAuZXKPamR5jZLSRwqZnjDjbWiNbQzRn
	 Jzra92kJXJKpHIQqBjYV3Yw1UYE/JR87jHGT7ztJ78qKnVbSM9RD20IfDaReyPtVFd
	 8j0gxUliYbxvvMThiuand+cAzCFGXJPCqVODgjSlptvB6S0JoswKPdVsNGd+xyKpml
	 jAkv7yAC1vzJBURRMO5YwszfV/yS+fKsyu7Qzb8EnGZWrcT1XiaU+KrJDVuYMmW634
	 4a22hzp1XhNRnCH9GRfQrlg/ZL6yPg3RwUfLy1Sp8J0VcTLM16dplCEKgJwcahfwX2
	 LsRwk3ekPplsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F233E4F128;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,V2] net: mana: Add support for vlan tagging
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922258.2912.1350478112565336594.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:22 +0000
References: <1686314837-14042-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1686314837-14042-1-git-send-email-haiyangz@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, decui@microsoft.com,
 kys@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
 vkuznets@redhat.com, davem@davemloft.net, wei.liu@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, ssengar@linux.microsoft.com,
 linux-rdma@vger.kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
 bpf@vger.kernel.org, ast@kernel.org, sharmaajay@microsoft.com,
 hawk@kernel.org, tglx@linutronix.de, shradhagupta@linux.microsoft.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 05:47:17 -0700 you wrote:
> To support vlan, use MANA_LONG_PKT_FMT if vlan tag is present in TX
> skb. Then extract the vlan tag from the skb struct, and save it to
> tx_oob for the NIC to transmit. For vlan tags on the payload, they
> are accepted by the NIC too.
> 
> For RX, extract the vlan tag from CQE and put it into skb.
> 
> [...]

Here is the summary with links:
  - [net-next,V2] net: mana: Add support for vlan tagging
    https://git.kernel.org/netdev/net-next/c/b803d1fded40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



