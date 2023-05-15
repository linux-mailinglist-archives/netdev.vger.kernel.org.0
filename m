Return-Path: <netdev+bounces-2535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3FC70265E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF9EF2810FE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08FD8488;
	Mon, 15 May 2023 07:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4988479;
	Mon, 15 May 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC72CC433D2;
	Mon, 15 May 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684137019;
	bh=Dd5aifMi/5ZMfSVlkdvUkSS+2p4822sumXMwI10wUtU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SFPdRI8YpSEq5cnCj/Spim0NW3RyYMqm6VcuVAxwXha2mT4mojsWL+eHMQ2G0jYZP
	 AYFDzMjH1+M9PUvLaFy+hhTOFz1Rfzut2uiJgqVbxac9HuwtsZ2teF1XbVO/6hYNuo
	 i33kmXaA+Pzwl34UZlTl8qwyfv/rBnVwVPp0VAF2evWeS10+bS1WkhKfkZOV5Bvb+I
	 WG+krB48Zu/0GDU2YCm0yJILTb28SNvbgZPlqwu2UJxVYjt/WB/q02qYZjJszVQa0K
	 o2UMhSvXC9l5eEcmyEv/1hbQv+eHCfRyrON2LhoQCCR/YPNntwwObZ2ypfGVEUycTI
	 uWJ2/Ncf/43Lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B484EE5421D;
	Mon, 15 May 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fec: remove the xdp_return_frame when lack of tx BDs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168413701973.26935.1752695821441304513.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 07:50:19 +0000
References: <20230512133843.1358661-1-shenwei.wang@nxp.com>
In-Reply-To: <20230512133843.1358661-1-shenwei.wang@nxp.com>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, xiaoning.wang@nxp.com, linux-imx@nxp.com,
 ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, alexandr.lobakin@intel.com,
 horatiu.vultur@microchip.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 08:38:43 -0500 you wrote:
> In the implementation, the sent_frame count does not increment when
> transmit errors occur. Therefore, bq_xmit_all() will take care of
> returning the XDP frames.
> 
> Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: fec: remove the xdp_return_frame when lack of tx BDs
    https://git.kernel.org/netdev/net/c/6ead9c98cafc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



