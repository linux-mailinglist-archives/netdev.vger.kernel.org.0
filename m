Return-Path: <netdev+bounces-10013-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D6672BAF4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C2071C20AAE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62418107A8;
	Mon, 12 Jun 2023 08:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6B911CA9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC517C433AE;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559222;
	bh=tEn24xy563Joj7dcAtBeVJ43ayDovSxL7KITQPc8w1Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bH3+mDqxFyW9NOJsYHeriEciAz+qDHG5PX9S5VQm8+G3wmFzeTHMdKzg7vtsbVian
	 45ef0SDe9r2N60wsFz9O6oLoHs7voSURUGiaHptKw19AxDkFxEV3PSgUJm7YRn6Z9+
	 2db9UXJ/MXsGAzsVbhePt17uQnBD7iPjyMmH2IAV2I0FFz6jbCzK9dMuXfH5PVxLSc
	 6CibdHS1lFhH6OARXlihogYA728Unebrt5g0TUxj/tW2+UAxxUIL0UXuTZ4eAj7ckq
	 cLEWRzWTOWnX2MB5O5NUvTxjhZy9yx7UE1g/UFR2QnwcyMTcEjTGCI0dnGrdul30tf
	 Z+j2ndsegnqWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 794C7E33087;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ionic: add support for ethtool extended stat
 link_down_count
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922248.2912.7983126910299949584.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:22 +0000
References: <20230609055016.44008-1-shannon.nelson@amd.com>
In-Reply-To: <20230609055016.44008-1-shannon.nelson@amd.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 brett.creeley@amd.com, drivers@pensando.io, nitya.sunkad@amd.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Jun 2023 22:50:16 -0700 you wrote:
> From: Nitya Sunkad <nitya.sunkad@amd.com>
> 
> Following the example of 'commit 9a0f830f8026 ("ethtool: linkstate:
> add a statistic for PHY down events")', added support for link down
> events.
> 
> Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
> link_down_count, a property of netdev that gets reported exclusively
> on physical link down events.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ionic: add support for ethtool extended stat link_down_count
    https://git.kernel.org/netdev/net-next/c/132b4ebfa090

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



