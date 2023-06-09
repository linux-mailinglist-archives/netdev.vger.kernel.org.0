Return-Path: <netdev+bounces-9421-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9237728E1E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2315428159C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008AFEA6;
	Fri,  9 Jun 2023 02:40:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505C2EC4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA560C4339E;
	Fri,  9 Jun 2023 02:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686278423;
	bh=aQxAb+e9gYOVhXXuT7TjvBQwdK7aidWI/FxtI5+cVI4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=vEoz5Ub3ob+EDWMqtK8bIZjN7eJ5tkSSeodDmGhbFyWa8Xh/qnOuu7pV47+b6JL3U
	 7WdjjF8S/vcO9kI3s+S6GLgnVBNc88FCpbQSJfcg0/wwhIDroVnePbCHw4gE3uCQx8
	 2od/HbFxVJ+WfkB2kvxJ4XCsTd2LSNiDnpuMu+gGTvvSUsuRmZW3YnTB4PA/Yrohlq
	 485BMBPkKGDb1CiS/4G1Rz3BGNzmdgXOu6Smu+VUSZGtgAzbbkAFpww8tWgpR7oo60
	 F7E+82l6lZY/tldwVMqk0V6XHX8vf9OeVS0Q8wtFMIhGyNHOpywS+pzOoHPr3Izrsq
	 LDTLSZpM15Edg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84EE0E4D03D;
	Fri,  9 Jun 2023 02:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: let tcp_mtu_probe() build headless packets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627842354.12774.16007888225015926556.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:40:23 +0000
References: <20230607214113.1992947-1-edumazet@google.com>
In-Reply-To: <20230607214113.1992947-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, netdev@vger.kernel.org, eric.dumazet@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Jun 2023 21:41:13 +0000 you wrote:
> tcp_mtu_probe() is still copying payload from skbs in the write queue,
> using skb_copy_bits(), ignoring potential errors.
> 
> Modern TCP stack wants to only deal with payload found in page frags,
> as this is a prereq for TCPDirect (host stack might not have access
> to the payload)
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: let tcp_mtu_probe() build headless packets
    https://git.kernel.org/netdev/net-next/c/736013292e3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



