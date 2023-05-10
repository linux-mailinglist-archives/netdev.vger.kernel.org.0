Return-Path: <netdev+bounces-1426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B72EF6FDBD1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDC411C20D38
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120C7746E;
	Wed, 10 May 2023 10:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7007A5D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67E41C433EF;
	Wed, 10 May 2023 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683715221;
	bh=hXXfTYfIfdfbstZ9WJjnJFY6BKlXJ+cnTyT35FzKEPk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AAQkYRfb8vh6wAkda5fpGUHKX4QLCJWdEybteuE07R3k/FC5t+ye7nlBWQChvwGLu
	 mq078viMR9ylZ/bi4BRaooFy0oClEq24/xv0Ca99IX1nWMTyRTZc5F/29CdoAm/YoT
	 SBM3eX46L6XO4FlYEpL0V0ZQLg4ebVFXbgMtnRA8Z9DNWLQIsDoYsB379MHrzO4RSa
	 4Ds1F0zEDCO+WHok9sTnfWUYjBlUvqEKwXcNokmTsHcaR8B9oHHhxYfDfNM6j1W206
	 OUcPsdZyMWhr2Vyfe8cX6eVs7ehU86DUrNcWM/pxr/r27jkJ21cABIr9JoiShjxUiq
	 9nZmvXzMJWyng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BC87E270C4;
	Wed, 10 May 2023 10:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: liquidio: lio_vf_main: Remove unnecessary
 (void*) conversions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371522130.27469.6976975356086997885.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 10:40:21 +0000
References: <20230510060649.210238-1-yunchuan@nfschina.com>
In-Reply-To: <20230510060649.210238-1-yunchuan@nfschina.com>
To: wuych <yunchuan@nfschina.com>
Cc: dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 14:06:49 +0800 you wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  .../net/ethernet/cavium/liquidio/lio_vf_main.c    | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] net: liquidio: lio_vf_main: Remove unnecessary (void*) conversions
    https://git.kernel.org/netdev/net-next/c/6096bc055572

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



