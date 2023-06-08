Return-Path: <netdev+bounces-9229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4315A728195
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94F441C20F8B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FB212B82;
	Thu,  8 Jun 2023 13:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CCA947B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AACC1C4339B;
	Thu,  8 Jun 2023 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686231623;
	bh=bCCtO5GAnRN8vuPTl3yHQSzQO24lOgmzrklyKcrCYls=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Gjibf96VfNysk//y1AuyPVxS+sbIqPDhGaMJCDj/TxRAk1hfCQZyD9sxRV8uo0gF9
	 1Rkg6QadOHLy+ohDcHHAieiZTpbPngIdJF4YAB/7Yq+H3hEWxEXgb7/kN60xkpFTOM
	 oiPVjLUgKZQJUH0CIT1moWIZfEI7TrwOsB4sEp4wULUeTRUXynxVi6FvSXbJ1ONmRh
	 KT0fkMfNUHv3SWSLlV/o8HB2u+m7lMoNTzIZd7mA8v0XKmxmn4Z7OI00tZcoOIsdNr
	 eJ5U754Wki5m8iH7hSa0zwhEIZ/p+yFzGXGLoY3cALeRU/jWMmblni2ZuP5yMvhxoy
	 OXw+Z/Kwy5oIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DB35E87232;
	Thu,  8 Jun 2023 13:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/10] crypto, splice,
 net: Make AF_ALG handle sendmsg(MSG_SPLICE_PAGES)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168623162357.14295.11722855983065901274.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 13:40:23 +0000
References: <20230606130856.1970660-1-dhowells@redhat.com>
In-Reply-To: <20230606130856.1970660-1-dhowells@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 willemdebruijn.kernel@gmail.com, dsahern@kernel.org, willy@infradead.org,
 axboe@kernel.dk, linux-crypto@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Jun 2023 14:08:46 +0100 you wrote:
> Here are patches to make AF_ALG handle the MSG_SPLICE_PAGES internal
> sendmsg flag.  MSG_SPLICE_PAGES is an internal hint that tells the protocol
> that it should splice the pages supplied if it can.  The sendpage functions
> are then turned into wrappers around that.
> 
> This set consists of the following parts:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/10] Drop the netfs_ prefix from netfs_extract_iter_to_sg()
    https://git.kernel.org/netdev/net-next/c/0d7aeb68700f
  - [net-next,v3,02/10] Fix a couple of spelling mistakes
    https://git.kernel.org/netdev/net-next/c/3b9e9f72badf
  - [net-next,v3,03/10] Wrap lines at 80
    https://git.kernel.org/netdev/net-next/c/936dc763c52e
  - [net-next,v3,04/10] Move netfs_extract_iter_to_sg() to lib/scatterlist.c
    https://git.kernel.org/netdev/net-next/c/f5f82cd18732
  - [net-next,v3,05/10] crypto: af_alg: Pin pages rather than ref'ing if appropriate
    https://git.kernel.org/netdev/net-next/c/f9e7a5fa51fb
  - [net-next,v3,06/10] crypto: af_alg: Use extract_iter_to_sg() to create scatterlists
    https://git.kernel.org/netdev/net-next/c/c1abe6f570af
  - [net-next,v3,07/10] crypto: af_alg: Indent the loop in af_alg_sendmsg()
    https://git.kernel.org/netdev/net-next/c/73d7409cfdad
  - [net-next,v3,08/10] crypto: af_alg: Support MSG_SPLICE_PAGES
    https://git.kernel.org/netdev/net-next/c/bf63e250c4b1
  - [net-next,v3,09/10] crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
    https://git.kernel.org/netdev/net-next/c/fb800fa4c1f5
  - [net-next,v3,10/10] crypto: af_alg/hash: Support MSG_SPLICE_PAGES
    https://git.kernel.org/netdev/net-next/c/c662b043cdca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



