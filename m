Return-Path: <netdev+bounces-9107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E47CD727468
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D73AC1C20F3B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A00A5B;
	Thu,  8 Jun 2023 01:40:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152D17F6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55DA2C4339B;
	Thu,  8 Jun 2023 01:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686188442;
	bh=w4Yhc8M1+Sc8DjZUGZIi2kCQFDisbNyApA598RkfTG0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mIDG58M5qW+HMcu8/gdP/bgayCb0xultvhml5OOGNiUY82lqfNJD5mOTfumNtwxdu
	 BLS5K4sr+aR03tfO0Fycd9utBc+13ftr0J23hI3qzUhSDcS9GF6nwXaPam0h73cMFT
	 ysS4jd535N3tpXSCDDooDY7dUEDZMqKf7W4UtXreK4P3Jv+/pwahwS7dQ02+DAmfsV
	 zq1f5PiAemhTEuizAOVkXm82C+bnfNjW64uKYaK14ldn5IvSXiVx65Vx46tBg6Vzvd
	 b2DgdLBsCSE+yJImF1GinDhplxf4XUxWykyRjky2OXqh/xPYpL56cL7sG6wUrXVOr0
	 k2L2DnHcmIMQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34E73E4D016;
	Thu,  8 Jun 2023 01:40:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] rt_names: check for malloc() failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168618844221.21217.15238674475026423841.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 01:40:42 +0000
References: <20230608013454.15813-1-stephen@networkplumber.org>
In-Reply-To: <20230608013454.15813-1-stephen@networkplumber.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed,  7 Jun 2023 18:34:54 -0700 you wrote:
> Fixes issue reported by Gcc 13 analayzer.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  lib/rt_names.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [iproute2] rt_names: check for malloc() failure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=507fe042181c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



