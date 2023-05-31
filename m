Return-Path: <netdev+bounces-6737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2467717B5E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C3272812B0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87043D30E;
	Wed, 31 May 2023 09:10:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DFEC152
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AAAFC433A1;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685524226;
	bh=hDJSRecZo0r252vnaXfkiNlfprXIv/b3sJGgFHIpmOU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Y/8TfELj12izLrUG6cYPXcx3VjsH/9dn7D1MEJWMZQZ2PYI3E+OB2GAg/8T9qg9L3
	 UI7UyuLMmWg+bxD2Nh67dxf7lrIdtwxfj2hSUnQ//nKOHt5HjeAoOezshwIydFrTtU
	 0Fc0Lhl4/+3NHE9tPNVORnYgGZJ6GZHopMJIquL3M478UP2fh5YkRwmz5eD7rf2j5i
	 ie24ka7gxn9P56wjAmZBN3PcKOQG0XM2GFRGKJv4MpjOWJWwFtpV7W76CrO/DI7DAj
	 /ZQpZIDCUd+Jn+245YNhFVkQmsqIDwYY4W9Et3stga2mCTy/sBmMmYarH40soN/Ofa
	 dUNb7wVMIKw1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C7C3E4F0A6;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: Switch i2c drivers back to use .probe()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168552422637.12579.10234857160676366229.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 09:10:26 +0000
References: <20230530063936.2160016-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230530063936.2160016-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
 george.mccollister@gmail.com, netdev@vger.kernel.org, kernel@pengutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 May 2023 08:39:36 +0200 you wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter") convert
> back to (the new) .probe() to be able to eventually drop .probe_new() from
> struct i2c_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: Switch i2c drivers back to use .probe()
    https://git.kernel.org/netdev/net-next/c/3ea903e2a523

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



