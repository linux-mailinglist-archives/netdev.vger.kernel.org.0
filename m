Return-Path: <netdev+bounces-7819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C62D8721AFE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 01:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E889F1C2094A
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 23:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926A811CBF;
	Sun,  4 Jun 2023 23:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D5717F4
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2484C4339B;
	Sun,  4 Jun 2023 23:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685920219;
	bh=8xtkpQ18G46b7jMXKesdIMv9fuQkHSFurx0vrr/MJxQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E1H/pQxaStkj3QbnjbPLtV7NyyRPndIci5tmSYmgZoKYgjkew45zq+MNw2Gc/KdI8
	 wASTjn7cE9RiFoqsr638NIVDlk6edn40VNHDHy61tmqolntpTTjinJLsHHvMr+esBm
	 LIao/wj6/7IhRwriNM/vkc1we/SotC15+avH3xpWzXfBvPkAZvKplNupF2311bGB4v
	 KNlR7x4UeMGOnQ2aCDuWYKyi3XNrq/hx6yy8untO5iIkYzdm4tsfAAuxr97n8vAv4r
	 eif9zRZaAQ+vKSrHFc+HxkNyUbdbNqNq7HKKuwRiY2V/vd7BQUHAYgAHiMcAogAeV0
	 CLsxEG3mlCW1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 976CAC41622;
	Sun,  4 Jun 2023 23:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool v2] Require a compiler with support for C11 features
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168592021961.17482.9229533087230173069.git-patchwork-notify@kernel.org>
Date: Sun, 04 Jun 2023 23:10:19 +0000
References: <20230524110349.2983588-1-dario.binacchi@amarulasolutions.com>
In-Reply-To: <20230524110349.2983588-1-dario.binacchi@amarulasolutions.com>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: netdev@vger.kernel.org, mkubecek@suse.cz

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed, 24 May 2023 13:03:49 +0200 you wrote:
> Just like the kernel, which has been using -std=gnu11 for about a year,
> we also require a C11 compiler for ethtool.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
> Changes in v2:
> -  Enable support to C11 compiler instead of C++11
> 
> [...]

Here is the summary with links:
  - [ethtool,v2] Require a compiler with support for C11 features
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=31b7b5ec7edd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



