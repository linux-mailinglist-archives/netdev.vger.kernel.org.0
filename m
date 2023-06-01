Return-Path: <netdev+bounces-7181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D80571F054
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB626281858
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC9042538;
	Thu,  1 Jun 2023 17:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E5413AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68C62C4339C;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685639424;
	bh=ghqiZ+HYy8UNlbefiSaC+wTE8McmzQfnL6LRswEDqjY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Sbo9/n1uqZToAA2yieuB+h88KD9ZrS804cGIDtoSURGO6MmaSbkj25kGCUIYA7xRQ
	 sew0UEcIlUiUbrk21if8H31MEfPC4gZjt7yi5CB1gzju5TIeO1+aoIMh/eeiI08fV+
	 0Alo/x3o80cJI+XZR14eoEFOX2FDpJHSVhzNFVqNsHwX08xLzbWTfGzHen4ICAusTg
	 9ZpzwkOJxYak30MLgvn1JatjjS78jfmqxZZvpiQQgpRj/aE2GQkeYTzYshy2tmObU0
	 UJ70iqxO+9K0VPdFwiFdEtYNDuc6LCXNWNWuS091YoDojmIPX1ENZn79ArE3NwCdHc
	 wrF+u3WmITpag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43C41C395F0;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: mxl-gpy: extend interrupt fix to all impacted
 variants
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168563942427.9709.16771098196662270912.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 17:10:24 +0000
References: <20230531074822.39136-1-lxu@maxlinear.com>
In-Reply-To: <20230531074822.39136-1-lxu@maxlinear.com>
To: Xu Liang <lxu@maxlinear.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
 hmehrtens@maxlinear.com, tmohren@maxlinear.com, rtanwar@maxlinear.com,
 mohammad.athari.ismail@intel.com, edumazet@google.com, michael@walle.cc,
 pabeni@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 15:48:22 +0800 you wrote:
> The interrupt fix in commit 97a89ed101bb should be applied on all variants
> of GPY2xx PHY and GPY115C.
> 
> Fixes: 97a89ed101bb ("net: phy: mxl-gpy: disable interrupts on GPY215 by default")
> Signed-off-by: Xu Liang <lxu@maxlinear.com>
> ---
>  drivers/net/phy/mxl-gpy.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)

Here is the summary with links:
  - [net] net: phy: mxl-gpy: extend interrupt fix to all impacted variants
    https://git.kernel.org/netdev/net/c/519d64876408

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



