Return-Path: <netdev+bounces-11700-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D54733F33
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BADB1C20F6F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16256FDC;
	Sat, 17 Jun 2023 07:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180B06AB6
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 968C2C433CA;
	Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686987020;
	bh=NVzY2kEA8LtvAnyLy52slUxcI32m1xvH5L/vENP1HsY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Vi60ybgjOFbtNleiZAXPhEWMmQ6/dQhRAdpchyMKvXeuoqaviGOY27wemnYUE1YGB
	 SavsQz+BJH4NfC5deaoVQSv11jmmGPKBn2HzLTYBDMewBUoRoY/cfDkbUdHCyQPbdB
	 HhILB4Q+b69eYVfrbfbR7B50zZrn11v6MEQ/6EtV83we+SlVjnY+wp7i0GGljHVDXR
	 ny2kO0RjgZ8uQWI/ioBBBxiXqQCSn2evBxwuSHRo8cfkoBntnzeNgdFavUPuwr9wc+
	 hz4K30NcXuVEkLdVsFSxqdyPSNPxJ9dX5N596ukWujasdRLsIdMCo4zDH0xzM7GJWP
	 0CRS6YmH4lvjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79E5EE49FAA;
	Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] netlink: specs: fixup openvswitch specs for code
 generation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168698702049.21379.16688695827127233598.git-patchwork-notify@kernel.org>
Date: Sat, 17 Jun 2023 07:30:20 +0000
References: <20230615151405.77649-1-donald.hunter@gmail.com>
In-Reply-To: <20230615151405.77649-1-donald.hunter@gmail.com>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, donald.hunter@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 16:14:05 +0100 you wrote:
> Refine the ovs_* specs to align exactly with the ovs netlink UAPI
> definitions to enable code generation.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>  Documentation/netlink/specs/ovs_datapath.yaml | 30 +++++---
>  Documentation/netlink/specs/ovs_flow.yaml     | 68 +++++++++++++++----
>  Documentation/netlink/specs/ovs_vport.yaml    | 13 +++-
>  3 files changed, 87 insertions(+), 24 deletions(-)

Here is the summary with links:
  - [net-next,v1] netlink: specs: fixup openvswitch specs for code generation
    https://git.kernel.org/netdev/net-next/c/6907217a8054

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



