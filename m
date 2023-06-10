Return-Path: <netdev+bounces-9845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D7672AE32
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 20:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B9D1281420
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED3E200CC;
	Sat, 10 Jun 2023 18:53:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D31D539
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 18:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A225C4339B;
	Sat, 10 Jun 2023 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686423226;
	bh=0kXLR6N19QJarrOM9L2An/IXYJpG+uaknAMpiddQX0k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=u3rEUtAW9Oz5d3L9s7DJzvMxazzAZJ0gKbBElMO1pnkjOHQ4b0+Rfl3VA5TMEy4sG
	 CuFrSjZHWj8M5Alpp+J4akWEnNizgH5tGiUp7XoeYc5fT2dsf/fAuh1TCKfngNL5I9
	 N2cve5CpVQYBdAg/dCBJYO1Ijxx5KxDX/27qsejRs3cf5KYspq5beqToKQvwOlymqg
	 rfaAFTdhaBYWZo9CAtUaSAUSDkT9xoXU6zRSFjljDva6Z2Eh9S+Ih0MvqcTUlppHm8
	 zFhYGbQ2pW9jhw9xktygzgKoklE1jQVtP1IIIWP6ug7jIEUwhN3VmwmtdSLUG2ao/7
	 Fp7R7GoiyKJhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 373C8E87232;
	Sat, 10 Jun 2023 18:53:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] net: renesas: rswitch: Improve perfromance of
 TX/RX
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168642322622.21298.7526575301146103242.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 18:53:46 +0000
References: <20230608022007.1866372-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230608022007.1866372-1-yoshihiro.shimoda.uh@renesas.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, maciej.fijalkowski@intel.com,
 simon.horman@corigine.com, netdev@vger.kernel.org,
 linux-renesas-soc@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 11:20:05 +0900 you wrote:
> This patch series is based on net-next.git / main branch [1]. This patch
> series can improve perfromance of TX in a specific condition. The previous code
> used "global rate limiter" feature so that this is possible to cause
> performance down if we use multiple ports at the same time. To resolve this
> issue, use "hardware pause" features of GWCA and COMA. Note that this is not
> related to the ethernet PAUSE frames.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] net: renesas: rswitch: Use napi_gro_receive() in RX
    https://git.kernel.org/netdev/net-next/c/dc510c6d2ecf
  - [net-next,v4,2/2] net: renesas: rswitch: Use hardware pause features
    https://git.kernel.org/netdev/net-next/c/c87bd91e34e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



