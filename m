Return-Path: <netdev+bounces-6332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0481C715CB1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 984951C20BB0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0545C174FC;
	Tue, 30 May 2023 11:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2C17723
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C382C4339C;
	Tue, 30 May 2023 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685445019;
	bh=ooyqEstCDpnfy3AudKZDgbG8bndnmzjIz/C+/3PODfw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QKvtcKbhic/Ekw82tXjeLyznXnThWH9YMBiOVxx3hdVRw8sY3dD0nIM//grgv/lvd
	 Ji60MhaqNyzYc62Nwkz7MNXOwN8AlRAoXmJxoVJBM68p2g6hGnEJAmEUvL1/4sHIEY
	 jlwCWr1aP1w9Dw0bGmleqjf2Rd6aGXkVaFXGJFNarmXmfE5UDFk1KTt7xbqhrSHyg/
	 ZkJj+YyBRBNjsGusbW56JivUDHrxKVCK+DzkmQLy8DjgrPLOh3AdMz3RtBtg140Ges
	 /oUdJwHPDUxuN0j6AkY8Evxwy8KYcmJqM+B48prUdwXS52sjwxGmwfbinS+3N9Emaj
	 cnO1IJ2fAKYjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70DA5E52BF6;
	Tue, 30 May 2023 11:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] liquidio: Use vzalloc()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168544501945.15349.1447654214399471646.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 11:10:19 +0000
References: <93b010824d9d92376e8d49b9eb396a0fa0c0ac80.1685216322.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <93b010824d9d92376e8d49b9eb396a0fa0c0ac80.1685216322.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 27 May 2023 21:40:08 +0200 you wrote:
> Use vzalloc() instead of hand writing it with vmalloc()+memset().
> This is less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 4 +---
>  drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] liquidio: Use vzalloc()
    https://git.kernel.org/netdev/net-next/c/bb269633f3da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



