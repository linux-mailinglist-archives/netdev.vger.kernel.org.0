Return-Path: <netdev+bounces-10838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E1473079D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E98F71C20D8F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD7B5C8D3;
	Wed, 14 Jun 2023 18:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAD67F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF69CC433C9;
	Wed, 14 Jun 2023 18:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686768620;
	bh=7Ajkch+VMJuMOYKh4UV/Iskdj7DdMUTNCIuSwn/fyno=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rNPPewTZhd4GfP7enVlblLWpNBauHHPETTv+rlCyV1ovuXlWHm7gbDpJ8Ry9uLq58
	 VmRxGNrxlWoNEOrC4tSHurmpUx6e/cNHlpPPAUlIJV3EukvDNsoXzIkbiIB8mD0gCQ
	 Uz7g53UAbzneVcvlfRYGlrhH+eb2CPkSGDGs20kxAr2lfmxJLJT+81qxg+0P+qL0B+
	 KFQanTpmK2varbc7rYDf4ZznaQhGXY4uPrFWur8Lqm11euiWS6MuCZcbSA7D2WfD3d
	 zAb52dlT1jxlJyZwv/ZjXoE799Rp9l3L3sRBAvPb7lOtF3GvvI6dHIYsrADZWTIiVI
	 x2Zr6n3nj8+4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B02A8C1614E;
	Wed, 14 Jun 2023 18:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next v2 1/2] sff-8636: report LOL / LOS / Tx Fault
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168676862071.31288.12745905338021497702.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 18:50:20 +0000
References: <20230613050507.1899596-1-kuba@kernel.org>
In-Reply-To: <20230613050507.1899596-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: mkubecek@suse.cz, idosch@nvidia.com, danieller@nvidia.com,
 netdev@vger.kernel.org, vladyslavt@nvidia.com, linux@armlinux.org.uk,
 andrew@lunn.ch

Hello:

This series was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon, 12 Jun 2023 22:05:06 -0700 you wrote:
> Report whether Loss of Lock, of Signal and Tx Faults were detected.
> Print "None" in case no lane has the problem, and per-lane "Yes" /
> "No" if at least one of the lanes reports true.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: fix Rx / Tx for the "implemented" bit
> v1: https://lore.kernel.org/all/20230609004400.1276734-1-kuba@kernel.org/
> 
> [...]

Here is the summary with links:
  - [ethtool-next,v2,1/2] sff-8636: report LOL / LOS / Tx Fault
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=045d8dbe4c52
  - [ethtool-next,v2,2/2] cmis: report LOL / LOS / Tx Fault
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=b3e341c1a81b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



