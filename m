Return-Path: <netdev+bounces-1328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D99C56FD618
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A81A1C20CC0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805CD4433;
	Wed, 10 May 2023 05:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77E3D99;
	Wed, 10 May 2023 05:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 247CFC433A4;
	Wed, 10 May 2023 05:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683696023;
	bh=c5KOugkrvtjPfBfW4hsdQ0IyXBGdhYPWrOXgd+8x8+Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=W572G1bfXsDYkUBE985N2AavdaHV4RZbNZKOGcC8nBSKAYiyK7n6v6EDPReClQx5x
	 rWJ/Nrc2NCPxkCauCHwkbj5vqkrNucELID+g5A6A6eCvAUwPESjXnad9l6w0i3F5A9
	 oIzzoHjmDp54cgfvlwZ/15ed/8pQcMYNur32i8ApKVb9A01OIbNPonUuxqxNNyXZwS
	 +LW87cJqkSvRwfvHAumMWosWtNiq/xyRarwZIYSe7xgez2+CCITf9TixKCEHPZNku+
	 7F6tny5D5nBrlVJ+tW1uycbTEHG8j7P3Tu0qF++XNxo1rnmWw+N7lJRcYj5/E2KQ6M
	 zyRyBi3XaC3SQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0BEC9E4D010;
	Wed, 10 May 2023 05:20:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: veth: rely on napi_build_skb in
 veth_convert_skb_to_xdp_buff
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168369602304.9775.17498684545651634317.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 05:20:23 +0000
References: <0f822c0b72f8b71555c11745cb8fb33399d02de9.1683578488.git.lorenzo@kernel.org>
In-Reply-To: <0f822c0b72f8b71555c11745cb8fb33399d02de9.1683578488.git.lorenzo@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, bpf@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 hawk@kernel.org, john.fastabend@gmail.com, linyunsheng@huawei.com,
 ast@kernel.org, daniel@iogearbox.net

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 May 2023 22:45:23 +0200 you wrote:
> Since veth_convert_skb_to_xdp_buff routine runs in veth_poll() NAPI,
> rely on napi_build_skb() instead of build_skb() to reduce skb allocation
> cost.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: veth: rely on napi_build_skb in veth_convert_skb_to_xdp_buff
    https://git.kernel.org/netdev/net-next/c/9d142ed484a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



