Return-Path: <netdev+bounces-1308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 063246FD3E9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DA571C20CB5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03310361;
	Wed, 10 May 2023 02:50:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73C63E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C122C4339B;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683687026;
	bh=iFbUCLr3ipveDeIECGrbN46J5l0zyfHrxJqvZBiJ2PU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IBfA0nscbPSvWt6n5Jy0K7xC+dcGR37iksTxV67G3XihXpedKE5RwzSFxkPCGgFHz
	 pNa0NWRaiCU0q8EG5l1UaZ+5v8A65KHvIMb0vmXFl38UNsfTvpCWrM/cHgq1gASlif
	 RFdLYTjWJ4Vx41inSYCQf3UTEh+3ZRNa9bzUhtqoMkWlDBn2FSp9F8cBMo9LQcH/Us
	 phIuVnEbfvweREVOoBvhgifFQs8+xE7nYSA1RIu2mkxlMK+FIa+XkgDOVIAUvbTYor
	 mus0KBy43GmugKfSD4HE6K4C45HGUoSz0Bvw69IkkXBwMQXdtYzQOyd6kJzrGBEkT/
	 ZDMalqe4EKegg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F689E26D20;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: improve link modes reading process
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168368702618.23144.3048175947408525868.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 02:50:26 +0000
References: <20230509075817.10566-1-louis.peens@corigine.com>
In-Reply-To: <20230509075817.10566-1-louis.peens@corigine.com>
To: Louis Peens <louis.peens@corigine.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, netdev@vger.kernel.org, oss-drivers@corigine.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 May 2023 09:58:17 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Avoid reading link modes from management firmware every time when
> `ethtool_get_link_ksettings` is called, only communicate with
> management firmware when necessary like we do for eth_table info.
> 
> This change can ease the situation that when large number of vlan
> sub-interfaces are created and their information is requested by
> some monitoring process like PCP [1] through ethool ioctl frequently.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: improve link modes reading process
    https://git.kernel.org/netdev/net-next/c/a731a43e8669

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



