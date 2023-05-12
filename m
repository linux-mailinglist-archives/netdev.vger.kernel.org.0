Return-Path: <netdev+bounces-2079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A6670036E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C812281861
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E3FBE48;
	Fri, 12 May 2023 09:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E36AD4D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 853ABC433EF;
	Fri, 12 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683882621;
	bh=Lu0jBq/bUhyLos5IknY0AQsl8TNRmFse5jBDJVi/JBk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=szUqd3iPiLV+hbTUfK1UrKErJapXcuG1P96CKYc0CTLNoiQK+gWVttBcq7vNLzFR1
	 aXkZMWgSM4CqC3w+82YeMiGMJIA5olm/HipM2yDbzNtOvRqlXZPnfEksCk9Tr7HCdF
	 QmWyfyhLZF+lDbtTE2DOA8eQhf0+nFxn3L1SkpRIo44WHwJ8pWQ6ZGmfAQuh8az/Ng
	 YEoNCbdfUYAwRear+/dl+iCKIFq05tVdC4idZMVnA5k8aP8hpa15jDviG9vj93Ynx9
	 uy888HWVcArJXRZKqVm4pWDF6Wh0tmDPV8rAcMa3yPFdzUHYrGaBuHuDBhraSBad+B
	 4WN68nM0Iy4Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B976E26D2A;
	Fri, 12 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: disable RXFCS and RXALL features by default
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388262143.3920.13399596189249945637.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 09:10:21 +0000
References: <20230511094333.38645-1-pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <20230511094333.38645-1-pieter.jansen-van-vuuren@amd.com>
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 10:43:33 +0100 you wrote:
> By default we would not want RXFCS and RXALL features enabled as they are
> mainly intended for debugging purposes. This does not stop users from
> enabling them later on as needed.
> 
> Fixes: 8e57daf70671 ("sfc_ef100: RX path for EF100")
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Co-developed-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc: disable RXFCS and RXALL features by default
    https://git.kernel.org/netdev/net/c/134120b06604

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



