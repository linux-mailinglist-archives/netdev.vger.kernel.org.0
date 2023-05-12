Return-Path: <netdev+bounces-2068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B21A700292
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B1CE1C2112C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D75B8F62;
	Fri, 12 May 2023 08:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815D82597
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21A8DC433EF;
	Fri, 12 May 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683880820;
	bh=2q9UxvogTQinLZup/fVIBVwsRQ10tcY2ScZqjk4A0u0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mmqm7wtc3SAdcI/fcf4MRKsb/YfZw0ZM6fK3iQfQcGc9t3W/l+Wk1FG7o4/1b0hOn
	 mNrp4qwXPHnfIywXs96K3BVsM/C5a9LQ+UUU+PqdtprmGwlggOtX3TCb30jUVtAtv3
	 ucZgnKw8Q4aExfeZsBmQghwDPtZQ1cOMvWRBZRUx6GAL8QjNgFLRkfAuQJL6KxrEP6
	 8XisTBpysUeunQcbqJh1vy176giceUoSttvBJRr2D3Ug6aSAfg+59VIQf0ICpzpx1Y
	 2rHC96OhcUihAwJKFlzq12bYI+F9sMHVWR1nBF/29ZoSLb09++EQuLryUJsPk9Rj/J
	 d1+0jOwA/LiAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7C20E450BB;
	Fri, 12 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] bonding: Always assign be16 value to
 vlan_proto
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388081993.5500.5871554155408487884.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:40:19 +0000
References: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
In-Reply-To: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
 olteanv@gmail.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 17:07:12 +0200 you wrote:
> The type of the vlan_proto field is __be16.
> And most users of the field use it as such.
> 
> In the case of setting or testing the field for the special VLAN_N_VID
> value, host byte order is used. Which seems incorrect.
> 
> It also seems somewhat odd to store a VLAN ID value in a field that is
> otherwise used to store Ether types.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] bonding: Always assign be16 value to vlan_proto
    https://git.kernel.org/netdev/net-next/c/c1bc7d73c964

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



