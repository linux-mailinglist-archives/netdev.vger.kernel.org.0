Return-Path: <netdev+bounces-1640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D73346FE9BC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91007281618
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670161F182;
	Thu, 11 May 2023 02:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E421F181
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98B82C433EF;
	Thu, 11 May 2023 02:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683771021;
	bh=TTvsSAvQ43An39bKmI7Q0IxEsHYM3OULrPlsMb/C1uE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GwKnnNvRUZECEIxNFo3TfJiQ2JajXel84SptBtxlCEiNgo1q8JGpnDSxO2NBdHg0Z
	 VTUz9246OkACKPFzh0WqhdC02RgNXSs8nzl5YmB2UIhm7h6HvtlI53UR6Psk0QGFJE
	 V2pb2585RsZAQ704Dnymtq5xdkF8epebkcflya1INbQ/whku4CDub1R+VF1RgrWFOL
	 9Q1I2aFt98tr//nu/8TLzzlRHD6U33w6pYjBxrD61Ozq7aNMqxWwfqi2EhvbzGf49S
	 dw3nhq5jNXeWc+1x+DoPLzV4HNJ+gD/UOn6bEXIGbEi6HaXJbZmnYobrIkXNLGx30f
	 WsndTqYLvX0+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7738BE26D2A;
	Thu, 11 May 2023 02:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/2] af_unix: Fix two data races reported by KCSAN.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168377102148.6855.13901835634101543449.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 02:10:21 +0000
References: <20230510003456.42357-1-kuniyu@amazon.com>
In-Reply-To: <20230510003456.42357-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 9 May 2023 17:34:54 -0700 you wrote:
> KCSAN reported data races around these two fields for AF_UNIX sockets.
> 
>   * sk->sk_receive_queue->qlen
>   * sk->sk_shutdown
> 
> Let's annotate them properly.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/2] af_unix: Fix a data race of sk->sk_receive_queue->qlen.
    https://git.kernel.org/netdev/net/c/679ed006d416
  - [v1,net,2/2] af_unix: Fix data races around sk->sk_shutdown.
    https://git.kernel.org/netdev/net/c/e1d09c2c2f57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



