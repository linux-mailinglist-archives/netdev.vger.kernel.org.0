Return-Path: <netdev+bounces-10012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F269C72BAF0
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B82CD281162
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2109D11CBD;
	Mon, 12 Jun 2023 08:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93BA11C99
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8C0FC433A8;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559222;
	bh=+/tW+1zFZAjlM4xwCwjB6aoFyYf2dRA/nZxHRPGlekw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LgrgnH2s9a55TvWUeg9A0+71yxOaJmC6h/am2cDz84x6aQOZ6tBgON2ial1BAw5/g
	 KsIuZbKE/aoroyU9MO2RxcLa6+o2Qbs5aHe7+lr/rHV4WbUW9R3cb4a6RHWz5tkLQH
	 9g+2ZDYCbb+zO6Ti9w7Thlmv1HlSVDXmpj8AQIpoT3W+uF912ou0r2DtCAzhjMq02G
	 KsgUPqkIVUxq+wxfVWTlCnJujIKKPnxBSgf35IKfwlzIMj+XWlfCNs6FUUcG8yIXyt
	 o20FTk/NOKyTQtWVKpAxds2F32hczfTFoWSa5UDFAyooHAYPPX5h936t6pdTDOor3m
	 Hc+O4IaMvZM3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8383EE29F37;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: Add devlink dev info support for EF10
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922253.2912.16691621536422053820.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:22 +0000
References: <168629745652.2744.6477682091656094391.stgit@palantir17.mph.net>
In-Reply-To: <168629745652.2744.6477682091656094391.stgit@palantir17.mph.net>
To: Martin Habets <habetsm.xilinx@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com,
 linux-net-drivers@amd.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 09 Jun 2023 08:57:36 +0100 you wrote:
> Reuse the work done for EF100 to add devlink support for EF10.
> There is no devlink port support for EF10.
> 
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/efx.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

Here is the summary with links:
  - [net-next] sfc: Add devlink dev info support for EF10
    https://git.kernel.org/netdev/net-next/c/998b85f0468f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



