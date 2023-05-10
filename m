Return-Path: <netdev+bounces-1397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7E96FDAF3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1C5D1C20D34
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1919D6AD8;
	Wed, 10 May 2023 09:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4155C20B5A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB241C433A1;
	Wed, 10 May 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683711621;
	bh=U8iI7tKcIOm3UCqTW8LxBW5KbJzdTQietFsp4/zx5l4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aF3r/VK/1PX2NqYwTqNfs3K/K0iRLIEbCMTjcRRD+X2/KzatezwWS3NU9glG77PTe
	 N2xTUIFAkH0aUMmcbJBDA7mQlvW3voNMaWFJh6+b2TEAeO3rREKMaXw01HBsPSRdvH
	 OcomOuSjCHVz6hE1NZwK5eZlKGmWZgJAWo0Xq+gSISDv7z4pm7X98Amhy37e4JGhBp
	 O5Shwla9Bvaas4Pqf25KLnN6SKvMdS2ZPiuRSrbuKn0xz/WLwGrot4WPWqV5awg8uY
	 eWNR9P6XCuyUREk1c7mBhOg70jDafNJn1q84z5ndhBEv9Bv+hdN4dDsH7rq5UtGVyg
	 17WsYgzuFs5DA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0CE6E26D2A;
	Wed, 10 May 2023 09:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Remove the code of clearing PBA bit
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371162178.29703.148372445421684299.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:40:21 +0000
References: <20230509225123.11401-1-ziweixiao@google.com>
In-Reply-To: <20230509225123.11401-1-ziweixiao@google.com>
To: Ziwei Xiao <ziweixiao@google.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 bcf@google.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 15:51:23 -0700 you wrote:
> Clearing the PBA bit from the driver is race prone and it may lead to
> dropped interrupt events. This could potentially lead to the traffic
> being completely halted.
> 
> Fixes: 5e8c5adf95f8 ("gve: DQO: Add core netdev features")
> Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
> Signed-off-by: Bailey Forrest <bcf@google.com>
> 
> [...]

Here is the summary with links:
  - [net] gve: Remove the code of clearing PBA bit
    https://git.kernel.org/netdev/net/c/f4c2e67c1773

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



