Return-Path: <netdev+bounces-6336-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4306A715CEE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0EE4281135
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18FE17AB2;
	Tue, 30 May 2023 11:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D1217739
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 879A1C4339B;
	Tue, 30 May 2023 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685445619;
	bh=Kw0B/8XhmUXLGTGp3Rfh/cNTYSmZ/+xircdISkXbw3w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uO4YoI90/CH58X+9SNu3TMI/CKp6tI/zRpkyYgkdUyYhFcDlwx/Q/GDDS3UGBGIRt
	 2nXqiBF0Om9WzebGX5cM5j0qFLmdVd3138IFAuTbvO2ZqIO/a+GpGhmzUn7C1CPoyI
	 BvvOl7EgAchv7mCS43nb5rcHGi/uC7ESyg1i4jtaVhDqDGkUzyfMhOIKwS5RHhZdgn
	 sYj3hERjaMr50NbYGWASfDVslc90Zj5FjSNKZp/e2UUo0LaRgNZnff6ktEA+mXkZlN
	 r6ZVup8QHoAYQBCNOytnJGlTeus38ZC5voxblZ7ME/gsQaMzG6ltvwBIVTnj2klWH6
	 5Vn3x2OgpY/1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69969E21EC5;
	Tue, 30 May 2023 11:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] dsa: lan9303: Remove stray gpiod_unexport()
 call
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168544561942.20232.5098259559740699879.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 11:20:19 +0000
References: <20230528142531.38602-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230528142531.38602-1-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: jerry.ray@microchip.com, davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
 olteanv@gmail.com, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 28 May 2023 17:25:31 +0300 you wrote:
> There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> GPIO sysfs is deprecated. That said, simply drop the stray call.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next,v1,1/1] dsa: lan9303: Remove stray gpiod_unexport() call
    https://git.kernel.org/netdev/net-next/c/3ea3c9cff7f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



