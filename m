Return-Path: <netdev+bounces-11767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0747E7345D0
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 12:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 374681C20A5F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CADA1854;
	Sun, 18 Jun 2023 10:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AEE17E5
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B60DC433C9;
	Sun, 18 Jun 2023 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687083619;
	bh=l6Xo8X/qXpyCuetv0nWpu2k2NybFKErZPdAP74m9f44=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DGaDPtwcMFP68PIH2clT8HBixCjnps/XnWPQbhY7vXLsbxuQDPtVkoqCm1wbAwOWm
	 wYL72EGWm//l4dyxFErujSiinqDYHmLI62lA3W1jPBL3qstSayUkJAv4tBM9slcGah
	 6lOQ3M0K/dIIGk465jAIZpxMA+3H16jJW6ySJ5dWBQMlQGhBukn/0BkmBK8qqELnF9
	 qsTzdulUVM84BTvm6EvjliFGAAl961tWnkDs1MWEgjH8pkggq12aixNngAECOBsMFs
	 B1RZo4Gh2X5GfGUwTlN9JKZB4aOCA6/mK0zbZ5MKQtIHw4zc4aziB8h5ASAUdugjdM
	 0iCGlRuVVTFFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3037BC395C7;
	Sun, 18 Jun 2023 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ieee802154/adf7242: Add MODULE_FIRMWARE macro
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168708361919.30416.7304884252982729819.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 10:20:19 +0000
References: <20230616121807.1034050-1-juerg.haefliger@canonical.com>
In-Reply-To: <20230616121807.1034050-1-juerg.haefliger@canonical.com>
To: Juerg Haefliger <juerg.haefliger@canonical.com>
Cc: michael.hennerich@analog.com, alex.aring@gmail.com,
 stefan@datenfreihafen.org, miquel.raynal@bootlin.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 14:18:07 +0200 you wrote:
> The module loads firmware so add a MODULE_FIRMWARE macro to provide that
> information via modinfo.
> 
> Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
> ---
>  drivers/net/ieee802154/adf7242.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - ieee802154/adf7242: Add MODULE_FIRMWARE macro
    https://git.kernel.org/netdev/net/c/f593a94b530a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



