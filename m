Return-Path: <netdev+bounces-1388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B15146FDAC5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8918E2811D5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CF520F5;
	Wed, 10 May 2023 09:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FC965D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADC0AC4339B;
	Wed, 10 May 2023 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683711021;
	bh=C2vN4xgXkKzAMKsRA4JnQy/lheXKBqvE60NeNviwLcs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NXpd825tcodjnz09HezNTwYK5GsEA67Rgt/YgEs5DFV83uGXy0pa778zTl27mMt5/
	 3rY0eM32HkcsqNdlOI/REkBaAo0w09AcqWNt7yRkTyKP/UfT/BJSHIHG2cnrdsMvnz
	 mqxaLfPYFvrsMb9oqN8GTY+InmhGzV6SEbAdY2Gffi+aMIyUe/hZICcHhJqkcqXKQw
	 eac/TgGljN6GaNhGEgB35K2F7ieaZYdJjs+SpLWKeSUR0iw0ZTQNnFJHUHcnDPy3E7
	 aEiscjLxNk3PjAe2E5vPM/Xmf8rvV8yQUBr+Bb+GQFPraripKpEvvkP0mhyoy+SHu4
	 dat+eSOuB5oeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 908D1E26D21;
	Wed, 10 May 2023 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: pcs: xpcs: fix incorrect number of interfaces
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371102158.23581.7528890850821211883.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:30:21 +0000
References: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, Jose.Abreu@synopsys.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 michael.wei.hong.sit@intel.com, weifeng.voon@intel.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 09 May 2023 12:50:04 +0100 you wrote:
> In synopsys_xpcs_compat[], the DW_XPCS_2500BASEX entry was setting
> the number of interfaces using the xpcs_2500basex_features array
> rather than xpcs_2500basex_interfaces. This causes us to overflow
> the array of interfaces. Fix this.
> 
> Fixes: f27abde3042a ("net: pcs: add 2500BASEX support for Intel mGbE controller")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net] net: pcs: xpcs: fix incorrect number of interfaces
    https://git.kernel.org/netdev/net/c/43fb622d91a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



