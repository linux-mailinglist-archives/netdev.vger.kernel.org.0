Return-Path: <netdev+bounces-4208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6848570BA54
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BAD0280F2B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0F4AD5A;
	Mon, 22 May 2023 10:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD3D6FAB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CEF2C433D2;
	Mon, 22 May 2023 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684752619;
	bh=UCobQvYIE79kQVjvtCone5vqVpl56SNrRtjbnJtKG3c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b045kMdg0IaXtB2+nKNODhieRQfPhrM4U0p4fWO2NRD4jXc2oIjYbcmC+5ydGqmU0
	 ICccyi4s+ErN1R8kkGpCKKCCBuaZb0k8G0KJ4+rDwaRjxViB6szS6S51MIxtXC/ZZ6
	 68HrAfWdwDzkI4xOnRAZlTYstH465niwIyzL5oBiXm3EQ8GIZJDTtHzAo73vY861Vt
	 QCd3G+v3PLij+TXTkidYv6/IpRm4iLmpzcwShQWD067eqIozXw1D2wPUsGf2oYusBx
	 VXeDi6pKmg1IUeT7lZQfVa2cWPcbYDc7LBFFnW6ENyJLEbp5AovOPSCZic3QOcIT8o
	 j8ko8u1HK1t4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 286F8C395F8;
	Mon, 22 May 2023 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfc: Switch i2c drivers back to use .probe()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475261915.26454.10682472274215281908.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 10:50:19 +0000
References: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: krzysztof.kozlowski@linaro.org, olteanv@gmail.com,
 andriy.shevchenko@linux.intel.com, cminyard@mvista.com,
 peter.senna@gmail.com, void0red@gmail.com, davem@davemloft.net,
 kuba@kernel.org, shangxiaojing@huawei.com, robh@kernel.org, michael@walle.cc,
 benjamin.mugnier@foss.st.com, kabel@kernel.org, petrm@nvidia.com,
 hverkuil-cisco@xs4all.nl, luca.ceresoli@bootlin.com,
 Jonathan.Cameron@huawei.com, jdelvare@suse.de, gregkh@linuxfoundation.org,
 jk@codeconstruct.com.au, sebastian.reichel@collabora.com,
 adrien.grassein@gmail.com, javierm@redhat.com, netdev@vger.kernel.org,
 kernel@pengutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 20 May 2023 19:21:04 +0200 you wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> convert back to (the new) .probe() to be able to eventually drop
> .probe_new() from struct i2c_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] nfc: Switch i2c drivers back to use .probe()
    https://git.kernel.org/netdev/net-next/c/efc3001f8b44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



