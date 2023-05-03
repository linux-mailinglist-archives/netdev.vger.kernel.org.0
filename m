Return-Path: <netdev+bounces-113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1653D6F5304
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5D802810E6
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAC1BA34;
	Wed,  3 May 2023 08:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B32747F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DA92C433A4;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102021;
	bh=9O8c9jGRGCWcWbASdjBPTwA2qljSzJYwQuX0EhVhDGA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q3Uq2+vGQV860X0m90Q3fSB8yTp4bgNL6nFzrNWpQYV1Fo7ffQTc+372iNRd+jjiv
	 hZ4eSt+387FU7VbzISDh2H3u20fTZk2lSYBokBoSSmH9Zkj4si1cCrfmcKyVsJv+Dg
	 PukLTImSihqdgG/2pt0Y+hAEJZzcpWmRXDo8suQ/Oz/6WjPWTaFV7HHLI54v8dn8sP
	 U/AFpiqLrsX1Yfg/6eHoxx4jjH+ySWu8aYYb+Egrxjr0znXKc8aMRcN9Of7/Cn8+0q
	 8BitBfykmEqn13GJReKLGIUXa+fFRreWMNoWfnr0aR6W/aPtX9MyZ5LG0x5MC2D3nt
	 KQPxri9HJQriQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 287CFC73FF3;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] pds_core: add AUXILIARY_BUS and NET_DEVLINK to Kconfig
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310202116.22454.8518697788676439649.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:20:21 +0000
References: <20230502204032.13721-1-shannon.nelson@amd.com>
In-Reply-To: <20230502204032.13721-1-shannon.nelson@amd.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, simon.horman@corigine.com,
 netdev@vger.kernel.org, drivers@pensando.io

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 2 May 2023 13:40:32 -0700 you wrote:
> Add selecting of AUXILIARY_BUS and NET_DEVLINK to the pds_core
> Kconfig.
> 
> Link: https://lore.kernel.org/netdev/ZE%2FduNH3lBLreNkJ@corigine.com/
> Fixes: ddbcb22055d1 ("pds_core: Kconfig and pds_core.rst")
> Suggested-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] pds_core: add AUXILIARY_BUS and NET_DEVLINK to Kconfig
    https://git.kernel.org/netdev/net/c/1eeb807ffd8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



