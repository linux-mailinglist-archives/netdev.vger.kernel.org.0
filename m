Return-Path: <netdev+bounces-3228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3D870624B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54DB9281205
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC6615499;
	Wed, 17 May 2023 08:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111FAD27
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFF46C433EF;
	Wed, 17 May 2023 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684311020;
	bh=EacTFV3aLR7vTof0FI3pduiKvEeTrK96jsFJrQ45l24=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YCqTP5ndTSWjRmYrFq/AEalgZbw5wjhjkV1RooII96IiqupB/GmlTVsQ/8PkQhNZX
	 rx4dF/dxOd93e8t6HANIe350AbUBX7e30YP8biIqoS7yHuVHwDbJ1RmaJwgiIfn3cN
	 DRqEbMt0s/MKBvlC7r3Jf6J1Jr19NfktQhWsawwBGprqnQLsutdicOE6tMODvg/bJS
	 9AXDdhWHeGqDt/UqUHdJMUGxmwSz+n5QerZyH8OwrDpdwtXAi6JRiP6u8EbvDo0iUT
	 dR81bJtq+j7woSPmS+J7i7lx3smoTLz14EOWGMvhe+lgan+3orwHQ5wVtJnjMikoyj
	 KlwukcffdN7fQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95A21E5421C;
	Wed, 17 May 2023 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cassini: Fix a memory leak in the error handling path of
 cas_init_one()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431102060.18881.14691386988847658015.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:10:20 +0000
References: <de2bb89d2c9c49198353c3d66fa9b67ce6c0f191.1684177731.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <de2bb89d2c9c49198353c3d66fa9b67ce6c0f191.1684177731.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, jaswinder@infradead.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 May 2023 21:09:11 +0200 you wrote:
> cas_saturn_firmware_init() allocates some memory using vmalloc(). This
> memory is freed in the .remove() function but not it the error handling
> path of the probe.
> 
> Add the missing vfree() to avoid a memory leak, should an error occur.
> 
> Fixes: fcaa40669cd7 ("cassini: use request_firmware")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - cassini: Fix a memory leak in the error handling path of cas_init_one()
    https://git.kernel.org/netdev/net/c/412cd77a2c24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



