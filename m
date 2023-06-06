Return-Path: <netdev+bounces-8442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0699724128
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7705D2815A2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C833215AF6;
	Tue,  6 Jun 2023 11:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD2615AD2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33BA7C4339B;
	Tue,  6 Jun 2023 11:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686051620;
	bh=F96W65/kp0pYuxxub3VzJI+MDAnRLbTnnznxvpKHbnQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IEaSL9UXuY+op75LnSh73czdwfJgcmNpzWjRo4mwvEQ8QZi53N4sYyQRTi1Ifih7R
	 58dtQnjfS9jKjOvvl61yclRbQDz78AEKRlVXI7jODvYzPAHvV0wyUp5jdy3tTn/jHX
	 rnKYXgFbny/uY+jev89RaLvEy/nlfEyaaNq+I9eD9MQNYwyWccTZfxa9zf8IlA2Go8
	 qTact6BV/DNFJlpwSuPkkTa2EJxCzVz0ez+f10KssV9Bq6lgSE+BoLQUNzNGRkl5Sg
	 fIy2wo78bgxS5XfQnjHFtFgHdCrnuvd+8sFNrV27hP2/76W8H3BYDe5gBvh5sB51Ku
	 I0E4qRvHAF+LQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15F68C4166F;
	Tue,  6 Jun 2023 11:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/pppoe: fix a typo for the PPPOE_HASH_BITS_1 definition
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168605162008.20364.14177645531084252768.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 11:40:20 +0000
References: <20230605072743.11247-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230605072743.11247-1-lukas.bulwahn@gmail.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: jaco@uls.co.za, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  5 Jun 2023 09:27:43 +0200 you wrote:
> Instead of its intention to define PPPOE_HASH_BITS_1, commit 96ba44c637b0
> ("net/pppoe: make number of hash bits configurable") actually defined
> config PPPOE_HASH_BITS_2 twice in the ppp's Kconfig file due to a quick
> typo with the numbers.
> 
> Fix the typo and define PPPOE_HASH_BITS_1.
> 
> [...]

Here is the summary with links:
  - net/pppoe: fix a typo for the PPPOE_HASH_BITS_1 definition
    https://git.kernel.org/netdev/net-next/c/ae91f7e436f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



