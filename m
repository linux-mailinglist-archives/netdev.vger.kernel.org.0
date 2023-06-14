Return-Path: <netdev+bounces-10725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3715F72FFD6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3001B1C20CC3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A62AD3F;
	Wed, 14 Jun 2023 13:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619F3D99
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11BA6C433C9;
	Wed, 14 Jun 2023 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686748820;
	bh=/ngvFOiYan5Tnw0RHV0gIgYtJAvhF8zGJ7iwfCkaE8I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GD1nbeOEjNz8TyOWxmGE0gPY5G8aivDyb47swD25wZIzrLHz11HQvVeAVc+e3pfjx
	 tgSAkwvkGIcpwhAJqCJJp7HRknLEDmUZ7TJHxfMCyBDNb6FEmcexNyW9pMvYPXUKyq
	 MmtvVraq0EqIkzoAjy+GkvsLA7f2JewUuT4TLFobD2qMj1g2ByptM1WE7YM08HjbP7
	 oPTznlFittIdvBzx/hNN/Reke+wdMoLcj58xFrCh6/u+WfQaGw6ovPmJ7U+M+X5/xI
	 c6yEdXIL7XHH/caWu3Hqzb8fuSg4BmE1RcbD9ZTVChwToop5hv/TqHaZXek4aCOHQ5
	 Tt/wFd2148BKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8D2AC3274B;
	Wed, 14 Jun 2023 13:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168674881994.25775.6277183582641696593.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 13:20:19 +0000
References: <20230611105108.122586-1-gal@nvidia.com>
In-Reply-To: <20230611105108.122586-1-gal@nvidia.com>
To: Gal Pressman <gal@nvidia.com>
Cc: davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
 stephen@networkplumber.org, mkubecek@suse.cz, netdev@vger.kernel.org,
 edwin.peer@broadcom.com, espeer@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 11 Jun 2023 13:51:08 +0300 you wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> This filter already exists for excluding IPv6 SNMP stats. Extend its
> definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.
> 
> This patch constitutes a partial fix for a netlink attribute nesting
> overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
> requester doesn't need them, the truncation of the VF list is avoided.
> 
> [...]

Here is the summary with links:
  - [net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to IFLA_VF_INFO
    https://git.kernel.org/netdev/net-next/c/fa0e21fa4443

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



