Return-Path: <netdev+bounces-6409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C87F471633F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 834832811D9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C613D2107D;
	Tue, 30 May 2023 14:10:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796D52106F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24C75C433A0;
	Tue, 30 May 2023 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685455819;
	bh=qcLv/FgVD7AAf3cdMqQEQgmO2VyqLadH10kDSL+4bNw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kavKj+0cftaMaesUSYZEqRiqpAoR5ezFC747j5prkqtYXR5OnXI9JNQMS1mRGeGLM
	 x6/2w5WX6Ri98bMeWS1EKtd/xSqGfMbJXkCa2ibpQ0VYGBzro67SLgXITgiSI/z5nM
	 wi1oUdZqJRhGzGFs8J3SzqB0llDfDJ5uYMp9whRlAy6zM5HJ9oeI08AHeUIZs1L5qZ
	 nFJWFY3LB40SgmL0Zrzbz+RTBRD7qBKalebeLvSCq1r1hH9+Zm5U/+ZKTDBM985BY8
	 pcgEc5rf+Z/5dwhwrbu/UMfQC2Wu95R9Ef1uIOHMkVM4Gi4oaPXildrWbsjLl11vF9
	 62DT5rbaybeCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DE4EE52C0F;
	Tue, 30 May 2023 14:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: fec: remove last_bdp from
 fec_enet_txq_xmit_frame()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168545581905.24863.4673558963981900636.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 14:10:19 +0000
References: <20230529022615.669589-1-wei.fang@nxp.com>
In-Reply-To: <20230529022615.669589-1-wei.fang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
 simon.horman@corigine.com, netdev@vger.kernel.org, linux-imx@nxp.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 29 May 2023 10:26:15 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The last_bdp is initialized to bdp, and both last_bdp and bdp are
> not changed. That is to say that last_bdp and bdp are always equal.
> So bdp can be used directly.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: fec: remove last_bdp from fec_enet_txq_xmit_frame()
    https://git.kernel.org/netdev/net-next/c/bc638eabfed9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



