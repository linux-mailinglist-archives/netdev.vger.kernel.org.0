Return-Path: <netdev+bounces-9847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A69472AE3E
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 21:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D45821C20AD2
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891882068F;
	Sat, 10 Jun 2023 19:02:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33987200D1
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 19:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8ECF4C4339B;
	Sat, 10 Jun 2023 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686423740;
	bh=UKHPN9ydWII98C0KdgeIdXbjqqmr0bnqBO+zD2g7O84=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jbX8NmU30GUi1CKa9e/FlzO7Ah2wvxb1gRhXOjlMEJGE7VBvi+iZC7pE9Apg3XhpZ
	 1CI5syTza239So6O/rDmSnp/KHf5DUoWgst8iNyvxPlO2KYH6TdKnlsUzCB2N+AdDu
	 H3KY5QWG3+Xor6dshOTpoddg7TYsKWsNEAvdo0vCWZKUA5yZBga4oTL5BWRoy27fqM
	 5w4UNjJ0xm/9vvm+/WSPFyOPRk9giL95+QbXCvUw/WCdJEes5sI07jejMqVXG0vJdB
	 jYQv3Fwi9UHQ7G2D1ZaNgOcifBOEgiFS0Dh9turBO1/qfNN5fBANCRtXKEwkU51mbU
	 K94OxGNW1xTcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B7FDC395F3;
	Sat, 10 Jun 2023 19:02:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH 0/2] RVU NIX AF driver fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168642374043.25242.6626382356488289406.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 19:02:20 +0000
References: <20230608114201.31112-1-naveenm@marvell.com>
In-Reply-To: <20230608114201.31112-1-naveenm@marvell.com>
To: Naveen Mamindlapalli <naveenm@marvell.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sgoutham@marvell.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Jun 2023 17:11:59 +0530 you wrote:
> This patch series contains few fixes to the RVU NIX AF driver.
> 
> The first patch modifies the driver check to validate whether the req count
> for contiguous and non-contiguous arrays is less than the maximum limit.
> 
> The second patch fixes HW lbk interface link credit programming.
> 
> [...]

Here is the summary with links:
  - [net,1/2] octeontx2-af: fixed resource availability check
    https://git.kernel.org/netdev/net/c/4e635f9d8616
  - [net,2/2] octeontx2-af: fix lbk link credits on cn10k
    https://git.kernel.org/netdev/net/c/87e12a17eef4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



