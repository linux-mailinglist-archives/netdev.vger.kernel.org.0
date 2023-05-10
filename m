Return-Path: <netdev+bounces-1425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57D516FDBCE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B87C2813E1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02786AB3;
	Wed, 10 May 2023 10:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BD6569E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7852CC4339B;
	Wed, 10 May 2023 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683715221;
	bh=fW1xLmtdrZBKMWpp9lZiW/FNzhXNUKxL1AVyFS5czhg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OpbU+jo5QpZMJERO18zvrU2X/Hr79LUMqZpuba+1Iqdf97854b+jAnmmOUeAejqfu
	 GmkrQf0LxDexhOTiP4/kX74Vw3wakH2hAKAZO/O7le8mzTDmmgIx2z6WW20oepWMo6
	 yvdlVBLIqGJMvjDnsfPwRoJIKPTQBO5PC+tcBELh5y/5neyjZa/UqppzSKP/naux7e
	 WuFZhuvOn42dC5cjOHeotoUtu8CBCQ8syytGsGZTPd2iYyczcumLJd2qIxTUijqPVi
	 w2EFf5cWjB0rcBGeLvIydliq/Yp0cQzVbgWo5VKjelg6QMVIBAJ5Dy7PYpva/r8+cR
	 HTbRC289yRIfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 582E5E26D21;
	Wed, 10 May 2023 10:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] macsec: Use helper macsec_netdev_priv for offload
 drivers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371522135.27469.13839487111704280429.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 10:40:21 +0000
References: <1683707289-2854-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1683707289-2854-1-git-send-email-sbhatta@marvell.com>
To: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, saeedm@nvidia.com,
 tariqt@nvidia.com, roid@nvidia.com, leon@kernel.org, maxtram95@gmail.com,
 kliteyn@nvidia.com, irusskikh@marvell.com, liorna@nvidia.com,
 ehakim@nvidia.com, dbogdanov@marvell.com, sd@queasysnail.net,
 sgoutham@marvell.com, gakula@marvell.com, naveenm@marvell.com,
 hkelam@marvell.com, lcherian@marvell.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 13:58:09 +0530 you wrote:
> Now macsec on top of vlan can be offloaded to macsec offloading
> devices so that VLAN tag is sent in clear text on wire i.e,
> packet structure is DMAC|SMAC|VLAN|SECTAG. Offloading devices can
> simply enable NETIF_F_HW_MACSEC feature in netdev->vlan_features for
> this to work. But the logic in offloading drivers to retrieve the
> private structure from netdev needs to be changed to check whether
> the netdev received is real device or a vlan device and get private
> structure accordingly. This patch changes the offloading drivers to
> use helper macsec_netdev_priv instead of netdev_priv.
> 
> [...]

Here is the summary with links:
  - [net-next] macsec: Use helper macsec_netdev_priv for offload drivers
    https://git.kernel.org/netdev/net-next/c/bd9424efc482

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



