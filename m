Return-Path: <netdev+bounces-11055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7347315C7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF55D2816B1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611AAD506;
	Thu, 15 Jun 2023 10:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584C253B1
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DED0DC433A9;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686826220;
	bh=LEwkqHixw0z0OGcrNEwNOb/Nt8oETkR9AizJXI9T9WQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=JI2TzUnz5SdfTzjKhtSNRAAyLJQsuOzh6e3wCpGAXEAtA2cx6ttqoTWlmhGsLhSYZ
	 QuAV+0FFdkkCe/fSNIg4FproybbjCMbQ98KF+3350iyyUZnspFq9NDa/6McKJgB9Jq
	 9Mrms2cfPhYtTDYaBHZdiLbtG9SRUmeB+K4dbdf1C0mMG0GyYrMy99l8fAbZ434QBh
	 wtI6GnV3O3adz83slsyCd5JMgdSkQBS7pZd0bO5R8+F//xykCEN/58lHDFJW3aAXLH
	 0TbkHLmCDq1NxDngQS/COh0w+ZIVoDHp7baN86KFsLEIkwewv55Tsty0Krm7BRY/JW
	 YmXnq5rq9JhXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA7FFC395C7;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next resend] leds: trigger: netdev: uninitialized
 variable in netdev_trig_activate()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168682622082.15431.1307423348951437453.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 10:50:20 +0000
References: <ZIlmX/ClDXwxQncL@kadam>
In-Reply-To: <ZIlmX/ClDXwxQncL@kadam>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: ansuelsmth@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, pavel@ucw.cz,
 netdev@vger.kernel.org, lee@kernel.org, andrew@lunn.ch, davem@davemloft.net,
 linux-leds@vger.kernel.org, kernel-janitors@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 14 Jun 2023 10:03:59 +0300 you wrote:
> The qca8k_cled_hw_control_get() function which implements ->hw_control_get
> sets the appropriate bits but does not clear them.  This leads to an
> uninitialized variable bug.  Fix this by setting mode to zero at the
> start.
> 
> Fixes: e0256648c831 ("net: dsa: qca8k: implement hw_control ops")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [v2,net-next,resend] leds: trigger: netdev: uninitialized variable in netdev_trig_activate()
    https://git.kernel.org/netdev/net-next/c/97c5209b3d37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



