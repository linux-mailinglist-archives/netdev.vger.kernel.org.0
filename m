Return-Path: <netdev+bounces-9984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F68772B913
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3677F28107C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841CAD53C;
	Mon, 12 Jun 2023 07:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6D1FA5
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 900E6C4339C;
	Mon, 12 Jun 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686556219;
	bh=nlVwwwx+2+YvwPo/OfOFeq28gAN7YWuKrvoupNI53G4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nY+ZwPCwUwMVLHME9N5mtQmC0/U8reXtxT/cxsnYdNjnsvHC/sDt8WVV4D+bx2cHt
	 mDzzkyLzR2Yz4av9o51qR7uJ7Y/VRwk5mPWBklWLy4iJTnx/rACPSfMAIPH4cdVmqn
	 QX/lIUuDjVgazsziRvJ7NHw086y+d/9SWRRGN0y4BflTqZqqY+qilkGNFW0++ICBQ8
	 wM1H6ec3jJW5vcPNjsVo+cZ1xpfLn0DRtwnk0LMI80ngftSCHwVT/a7r2AkmX0e1fC
	 YrdBXPkliRU4P2VRd2kT6QXTwrGsGB9xa6K8PQ3PETGNnMZesgxrE+IWzMJ3q0MT6k
	 jrKXogA3itcHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71BA1E21EC0;
	Mon, 12 Jun 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V8] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655621946.6480.12343747716640389819.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 07:50:19 +0000
References: <20230608082458.280208-1-sarath.babu.naidu.gaddam@amd.com>
In-Reply-To: <20230608082458.280208-1-sarath.babu.naidu.gaddam@amd.com>
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 michal.simek@amd.com, radhey.shyam.pandey@amd.com, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, anirudha.sarangi@amd.com,
 harini.katakam@amd.com, git@amd.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Jun 2023 13:54:58 +0530 you wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V8] dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml
    https://git.kernel.org/netdev/net-next/c/cbb1ca6d5f9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



