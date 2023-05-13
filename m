Return-Path: <netdev+bounces-2380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65FB8701996
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 22:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2030D281522
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 20:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE659947F;
	Sat, 13 May 2023 20:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5E9442
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88935C4339B;
	Sat, 13 May 2023 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684008020;
	bh=UyE28kyYzpbG4iF5AiCflZSq+bH+1G5mL1Own0MArM8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kzYqNXpC1JXvXr2/J2Gw1ZK8qpnTGDgJeNeppy3LpfemNagghKIYqxxJFsdYjV/JR
	 hCSQPXW6+H8VH/512OIvwQfukEN/8Gw6l8OIeaAQhoHo+bnFhTwT5uWpi4nQkLKvVB
	 WB2RN27NH9Q286AjKs+ymicaaE/dpttPlBf0pHleP2YzMCR8Fw056v4oGzUVtinACB
	 fYk9KTwczwaPoFIFLXrUZknpNGzfEl0RtR/jqBCGjumgyhnvTT0pDIZ9VyUbeucuRe
	 w05YNhHRnCzedjN57WS4CnmBtZl6jPRHR41WO6A3Ira1M3PHUOjyaKQ6Lz1EOR894R
	 CNVr72A6ovp/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67682E270C2;
	Sat, 13 May 2023 20:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168400802041.779.10634623968966547726.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 20:00:20 +0000
References: <E1pxW6H-002QFs-SG@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pxW6H-002QFs-SG@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 17:58:37 +0100 you wrote:
> Both phylink_create() and phylink_fwnode_phy_connect() do not modify
> the fwnode argument that they are passed, so lets constify these.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 11 ++++++-----
>  include/linux/phylink.h   |  9 +++++----
>  2 files changed, 11 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [net-next] net: phylink: constify fwnode arguments
    https://git.kernel.org/netdev/net-next/c/a0b7955310a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



