Return-Path: <netdev+bounces-11784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F29373472C
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6DF41C20955
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BF963C9;
	Sun, 18 Jun 2023 17:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9CB1386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 17:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CA15C433C9;
	Sun, 18 Jun 2023 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687108219;
	bh=xuqAbC9/Y0WfDYipAEUmBP+MnJMUXUustqdX+mxovb4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RkqoyoMLhBYX65rWZU86g9Vrt6QHeoU3l2xLgzOKtaHDNLm2d0AQEyvIW7WMXuyfk
	 cOTqA4mOBvng7nI3JjAIin/U8Y4QGqxmmjTIpPvxiq1UnJpJQa5BybOEr0OgTDs1/N
	 txcJ6XVmrP5x2rckgxHloxTpDZUdx6yPC964KXIrZR8jAdHUMiwPdLD+udKLx1m6Zi
	 Qo+9DPFwubo3qye+BTpEQHlybuRJUvzptNRtP3Eog/V/LTb/6IhIljtQWApFVS8b7s
	 gk0S9bIa7Ck3Y1012q6vIIHOToN9i3x7NlfTeoSdfpm4px2OiclsIrYL3GTUnWyBhn
	 DQimP9HJ+Ig7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22435C395C7;
	Sun, 18 Jun 2023 17:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] gro: move the tc_ext comparison to a helper
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168710821913.20126.8388470376052359358.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 17:10:19 +0000
References: <20230616204939.2373785-1-kuba@kernel.org>
In-Reply-To: <20230616204939.2373785-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, linyunsheng@huawei.com, simon.horman@corigine.com,
 richardbgobert@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 13:49:39 -0700 you wrote:
> The double ifdefs (one for the variable declaration and
> one around the code) are quite aesthetically displeasing.
> Factor this code out into a helper for easier wrapping.
> 
> This will become even more ugly when another skb ext
> comparison is added in the future.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] gro: move the tc_ext comparison to a helper
    https://git.kernel.org/netdev/net-next/c/2dc6af8be002

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



