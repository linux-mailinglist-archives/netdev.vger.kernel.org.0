Return-Path: <netdev+bounces-9480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2587295D7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6679828175B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F0E1428C;
	Fri,  9 Jun 2023 09:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B9C1427E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FF65C4339E;
	Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686304221;
	bh=B4ehf1qx10BkGmaVu5ZrrQtzlbv/nf43IPDZstS9ck0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=e6j7UGYjfedho/hu4QQ2c8ISalWGjz0fFZLtl1mUgZxQW/fwwPI/B+HOJLOhrkLEj
	 PI4KdrTSXG3R3/MMuiek8OFf59FtifawVs5LonhiMp8HpIanMvKxZ0jUnH+9i/cjnS
	 h0t0UQieAReq+ZcM9RPzAzYHhak0rk01QIeCFStRq+IDyw0K6SURTf9gMqPhLaUmS0
	 mao2CxMt790DbE0vMmFaDT+lvlXCTAtwXH5toim8DfxAYqwL8CxjVX52zt/InnPJ7g
	 njLl7N38cpl4k8G85wLD7xOaw4jMzeFuDYSp29lWhHET/gUHbVvhuJVmMFR0SZ/3Ik
	 jsnhG3F6bZY2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61A2AE29F36;
	Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: renesas: rswitch: Fix timestamp feature after all
 descriptors are used
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630422139.21394.17316227658031207308.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 09:50:21 +0000
References: <20230608015727.1862917-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230608015727.1862917-1-yoshihiro.shimoda.uh@renesas.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, lanhao@huawei.com,
 simon.horman@corigine.com, netdev@vger.kernel.org,
 linux-renesas-soc@vger.kernel.org, phong.hoang.wz@renesas.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 10:57:27 +0900 you wrote:
> The timestamp descriptors were intended to act cyclically. Descriptors
> from index 0 through gq->ring_size - 1 contain actual information, and
> the last index (gq->ring_size) should have LINKFIX to indicate
> the first index 0 descriptor. However, the LINKFIX value is missing,
> causing the timestamp feature to stop after all descriptors are used.
> To resolve this issue, set the LINKFIX to the timestamp descritors.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: renesas: rswitch: Fix timestamp feature after all descriptors are used
    https://git.kernel.org/netdev/net/c/0ad4982c520e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



