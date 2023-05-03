Return-Path: <netdev+bounces-114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9486F5308
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DBD51C20C5E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3363747F;
	Wed,  3 May 2023 08:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE778F62
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59A1CC433AA;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102021;
	bh=0GbFjOgH9H1Xze2L84T66m2n/cgMU+RtViwWjALCsss=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FT2/UsXdyDkvDyF/iE1+8ZcjOgbp1Y4cCdOM/BwNzlHE5W5mNuVgE6Ct5kSINyuJq
	 6CCW9Vpo9XaIgmrD0+aZSbZ49oAtg5ha8CQ+eaXnz7AAV7HYI1xW7nc9O087fz1wiP
	 TzCYiWYL47aO+TV7PydZ045CkyKC7pOq8+oQerMKz00O8kEsVkB4f6oAnX2N7xrZ3D
	 D6/qH1wzn0051KzDXQZigyHlWZ7poHml0kJQwoPZJSNybUpTNez+UWf9teGtktKHAj
	 CcMBeG3rU+WXSdEvTDHHw1oD08lbW7KA47QE3KfL3npsHjR8X2/T+0DIUumw62cqLI
	 4tMhAOIK9glLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 323F9E270DB;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] pds_core: remove CONFIG_DEBUG_FS from makefile
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310202120.22454.9454797718165319450.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:20:21 +0000
References: <20230502202752.13350-1-shannon.nelson@amd.com>
In-Reply-To: <20230502202752.13350-1-shannon.nelson@amd.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 drivers@pensando.io

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 2 May 2023 13:27:52 -0700 you wrote:
> This cruft from previous drafts should have been removed when
> the code was updated to not use the old style dummy helpers.
> 
> Fixes: 55435ea7729a ("pds_core: initial framework for pds_core PF driver")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net] pds_core: remove CONFIG_DEBUG_FS from makefile
    https://git.kernel.org/netdev/net/c/ec788f7e96ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



