Return-Path: <netdev+bounces-7081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA5A719B61
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92F0B1C20E4C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201A223433;
	Thu,  1 Jun 2023 12:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00732341F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 12:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75A6BC4339B;
	Thu,  1 Jun 2023 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685620820;
	bh=D5LVIK3I++w9C6mFrD26n1XnwE05g6mZbXYRzyUPNrs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OQeBOR2o6wAw/vcZj0s/hpA1ucoDAkOaCX7RIMgGh1mycAoQ1zAU6tH4xxEyjr9Cz
	 U74ISrcNvXDsigo84dLtdsbBXIlRbQRYNHZuIA7jY54Vz+g/T1FBMUWmZYEtVmotFI
	 omNt7NQLMnIk2F+pWdQxFqwMR5wkC5BbWRMCj9zg2AnnQm3n8PcIE6gdFZfmB7dyuV
	 T5mI89xR7a0qY8D8jKtmVg4NUVFdhY+xgo8chTVmFyfFFtUrPGiDj5ba1Sf9nWV6wa
	 yR3siiOet7s8EXot3XSKvb81kYhZ3UMNQ0Z/fSc+r4YqtrWVZ3lEZmbMQwukHzmYyF
	 4FWFTEYHF7TEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B04EC395E5;
	Thu,  1 Jun 2023 12:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] splice,
 net: Handle MSG_SPLICE_PAGES in Chelsio-TLS
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168562082029.29159.8707546224300597535.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 12:00:20 +0000
References: <20230531110008.642903-1-dhowells@redhat.com>
In-Reply-To: <20230531110008.642903-1-dhowells@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, ayush.sawal@chelsio.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 willemdebruijn.kernel@gmail.com, dsahern@kernel.org, willy@infradead.org,
 axboe@kernel.dk, simon.horman@corigine.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 31 May 2023 12:00:06 +0100 you wrote:
> Here are patches to make Chelsio-TLS handle the MSG_SPLICE_PAGES internal
> sendmsg flag.  MSG_SPLICE_PAGES is an internal hint that tells the protocol
> that it should splice the pages supplied if it can.  Its sendpage
> implementation is then turned into a wrapper around that.
> 
> I've pushed the patches here also:
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] chelsio: Support MSG_SPLICE_PAGES
    https://git.kernel.org/netdev/net-next/c/116f7b361ebb
  - [net-next,v2,2/2] chelsio: Convert chtls_sendpage() to use MSG_SPLICE_PAGES
    https://git.kernel.org/netdev/net-next/c/26acc982c1c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



