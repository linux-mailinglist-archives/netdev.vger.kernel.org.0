Return-Path: <netdev+bounces-5593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB49F71234A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86FC228173C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D3710957;
	Fri, 26 May 2023 09:20:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE16F5255
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 589CDC433D2;
	Fri, 26 May 2023 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685092819;
	bh=sZL6/qkWe49dZo4vXFAfbunxWqr/MJAEYcAzV7JT9Wk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LeKlX7EVy7Q+3KFfR9Iom/UnsKwze6aAS4BBk8b099Jta3Hs0O+slgjd2GbYvS+BU
	 EBZjAFPmHoosSmpr0lDShBUf3Qb5nzCgBDnczMvXZZ6ucOmGMARFJ2UKO0iTuSmLzl
	 BGsl7Tmt/kPkSKqfAKYiAobrVFKl1u8wvBf7Amo8y0EU90qVMSj6yALuBSjy0ePNoy
	 ZNvG6QECBriVfNgxjFlsXE1ouvP8Jx8cUGuiHEQ4D1Yc8JqjGjTjgEk3qFw9jojclL
	 wltgKful0trrME16FNhsBGFcV6yYvTTKdKwjiNUeipZD76P9iSpMlXoqEtB4++r/Uo
	 MpZverprV86bA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A291E4D00E;
	Fri, 26 May 2023 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting the
 channels
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168509281923.19009.17415665025412453580.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 09:20:19 +0000
References: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 24 May 2023 10:36:38 +0100 you wrote:
> When fewer VIs are allocated than what is allowed we can readjust
> the channels by calling efx_mcdi_alloc_vis() again.
> 
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] sfc: handle VI shortage on ef100 by readjusting the channels
    https://git.kernel.org/netdev/net-next/c/ca7d05007d0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



