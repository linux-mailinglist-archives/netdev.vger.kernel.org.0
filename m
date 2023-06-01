Return-Path: <netdev+bounces-7018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D45971933B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C90001C21022
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6039F1C3F;
	Thu,  1 Jun 2023 06:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EA17737
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46AD3C4339B;
	Thu,  1 Jun 2023 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685601022;
	bh=4MrsBRwQ6mcU/8AAd7w1Xs1CY7+GvgBP0F+o1NjntyA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gCaTld7YILzI1zAFtiktm/UxLKm/K6pSYilYAKPXr7h9UqgD7pYBxkazYItB5pRgN
	 WLwu8W6nsIPbz4YUAUht5ep6oZucSgCUAr5FtQ7v18OZxzt9qFcijFheanesD8l+f1
	 vILIxrfUjG+zER/v4Iy9ApZD98OGScfbCTU+LDCHcZAQRtY5qYSpEucFA6EfMSzV7M
	 xoxlYTz0kMDprcPBe7nzOPbEhvYqil0uiNsCrmlwP1P6wINCuSHQc5gKpre6fY4rst
	 wpWbPWJZ+pFB73fNhJUarwwU9liZ/hFV9ywa8oHs4vDIZKqrnNAph4DTWlyjNDYUUL
	 7DOZ9Rn5jJ2ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25A15C395E5;
	Thu,  1 Jun 2023 06:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND,PATCH net-next v7 0/8] Wangxun netdev features support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168560102214.566.9800726865491589058.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 06:30:22 +0000
References: <20230530022632.17938-1-mengyuanlou@net-swift.com>
In-Reply-To: <20230530022632.17938-1-mengyuanlou@net-swift.com>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 May 2023 10:26:24 +0800 you wrote:
> Implement tx_csum and rx_csum to support hardware checksum offload.
> Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
> Implement ndo_set_features.
> Enable macros in netdev features which wangxun can support.
> 
> changes v7:
> - Remove fragmented packets parsing.
> - Jakub Kicinski:
> https://lore.kernel.org/netdev/20230523210454.12963d67@kernel.org/
> changes v6:
> - Fix some code spelling errors.
> changes v5:
> - Add ndo_set_features support.
> - Move wx_decode_ptype() and wx_ptype_lookup to C file.
> - Remove wx_fwd_adapter.
> changes v4:
> - Yunsheng Lin:
> https://lore.kernel.org/netdev/c4b9765d-7213-2718-5de3-5e8231753b95@huawei.com/
> changes v3:
> - Yunsheng Lin: Tidy up logic for wx_encode_tx_desc_ptype.
> changes v2:
> - Andrew Lunn:
> Add ETH_P_CNM Congestion Notification Message to if_ether.h.
> Remove lro support.
> - Yunsheng Lin:
> https://lore.kernel.org/netdev/eb75ae23-8c19-bbc5-e99a-9b853511affa@huawei.com/
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,v7,1/8] net: wangxun: libwx add tx offload functions
    https://git.kernel.org/netdev/net-next/c/3403960cdf86
  - [RESEND,net-next,v7,2/8] net: wangxun: libwx add rx offload functions
    https://git.kernel.org/netdev/net-next/c/ef4f3c19f912
  - [RESEND,net-next,v7,3/8] net: wangxun: Implement vlan add and kill functions
    https://git.kernel.org/netdev/net-next/c/f3b03c655f67
  - [RESEND,net-next,v7,4/8] net: libwx: Implement xx_set_features ops
    https://git.kernel.org/netdev/net-next/c/6dbedcffcf54
  - [RESEND,net-next,v7,5/8] net: ngbe: Add netdev features support
    https://git.kernel.org/netdev/net-next/c/50a908a0bd8b
  - [RESEND,net-next,v7,6/8] net: ngbe: Implement vlan add and remove ops
    https://git.kernel.org/netdev/net-next/c/361bf4f47cee
  - [RESEND,net-next,v7,7/8] net: txgbe: Add netdev features support
    https://git.kernel.org/netdev/net-next/c/6670f1ece2c8
  - [RESEND,net-next,v7,8/8] net: txgbe: Implement vlan add and remove ops
    https://git.kernel.org/netdev/net-next/c/7df4af51deb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



