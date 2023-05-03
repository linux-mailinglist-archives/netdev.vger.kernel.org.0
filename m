Return-Path: <netdev+bounces-107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 100F56F52CC
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B5EA280FB7
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FC67473;
	Wed,  3 May 2023 08:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0BB63AD
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 704A5C4339B;
	Wed,  3 May 2023 08:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683101424;
	bh=dDBGMIb0cA/OPFcK8yGnbi5V569W5wJAGPtqZIFxd2o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=CCK1KfBlimxK1vFn1kAyJdJoxu5YELsPZxFu2vfDNYHqSRI57Olei8PCaTC7/1vRd
	 sMhu/SUPng7kH7k9kkprbY8lDGGnWh1zTGWxTGSqAlmM/fNGaIp+reLzqZduN9CBZ7
	 zJWMOaGqZzd/R+qgvGugCpEFiyaDKOZwHCO96Iom0g8QSqpiyhpnbuLw09EKBlKmyW
	 IWm6yLtKKw8lJlJXtCA9Zv3Fh7+oZ8CZIIrmCi+VRYmp0Pp/ck2KT9Tre4ty1/E2Ly
	 vrsdyAFaG0ajfssYdnjh+U1FGoFaoH11zzOJsXYweoU/b4LLFDNqGKKUBRAxcFoCMO
	 rrFaAXbFzoB6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BC77C73FF3;
	Wed,  3 May 2023 08:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: remove noise from ethtool rxnfc error msg
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310142430.16336.11709594294289853145.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:10:24 +0000
References: <20230502184740.22722-1-shannon.nelson@amd.com>
In-Reply-To: <20230502184740.22722-1-shannon.nelson@amd.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 drivers@pensando.io

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 2 May 2023 11:47:40 -0700 you wrote:
> It seems that ethtool is calling into .get_rxnfc more often with
> ETHTOOL_GRXCLSRLCNT which ionic doesn't know about.  We don't
> need to log a message about it, just return not supported.
> 
> Fixes: aa3198819bea6 ("ionic: Add RSS support")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] ionic: remove noise from ethtool rxnfc error msg
    https://git.kernel.org/netdev/net/c/3711d44fac1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



