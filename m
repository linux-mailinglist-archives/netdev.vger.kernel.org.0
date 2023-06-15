Return-Path: <netdev+bounces-10992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F128C730F1C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A701D2816A2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE92420E2;
	Thu, 15 Jun 2023 06:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F450A45
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0CAAC433C8;
	Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686809420;
	bh=gnUkIvKJiucIrNEv5/qOv0Ci+Ouwg5NnNxO1JGGl1XI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=s69JbluQZc95+PhhszXeXrqKKTlRW4sF9nSyRlN0JxBKeLTbWtr6ntjXSFT9C+6i9
	 tfin4Q553R8dlRJzwhDlbxatnqAPnZe+nQ8+vl19AztD3ZAP3xamFM8JAVWM7ZG2Jq
	 1aib0KGXE+oetS7492dKAwCWM4uGO5p2CAT3PSJ1oVm7lSpC+w6mxpmrKrVJMiWUal
	 JvGGtFe9MGaXK3uMg5bndTwE0ZcL3dsuZhbOyvdD5wy+LAHVOuNrLudb+wElVkAd3/
	 31Tq7a1MUlwZvE8glI4WNrld2/KMu098gV4yeKJM6lPdYQ/RgP1WKhZNds8YL+GNa/
	 Ovcbqj3xJomDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93A52E21EEB;
	Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ice: Fix ice module unload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680942059.31160.12036944466498158942.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 06:10:20 +0000
References: <20230612171421.21570-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230612171421.21570-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, jakubx.buchocki@intel.com,
 michal.swiatkowski@linux.intel.com, jiri@resnulli.us,
 przemyslaw.kitszel@intel.com, himasekharx.reddy.pucha@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 10:14:21 -0700 you wrote:
> From: Jakub Buchocki <jakubx.buchocki@intel.com>
> 
> Clearing the interrupt scheme before PFR reset,
> during the removal routine, could cause the hardware
> errors and possibly lead to system reboot, as the PF
> reset can cause the interrupt to be generated.
> 
> [...]

Here is the summary with links:
  - [net,v2] ice: Fix ice module unload
    https://git.kernel.org/netdev/net/c/24b454bc354a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



