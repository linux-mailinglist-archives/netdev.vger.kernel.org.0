Return-Path: <netdev+bounces-7346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAD171FCE7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 443EB2816D5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B6E17737;
	Fri,  2 Jun 2023 09:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3C6174C4
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F8DFC433A8;
	Fri,  2 Jun 2023 09:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685696419;
	bh=ikfIbznFdRzfr16zRMOzhj0poXoVUbhZrc6//gdpOOk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Wq9zZTuVAsDz9V9EqaN1ykyy2D4zWMee8YyUWJCxqoTSKUFSPESjfVUS3Yh2GWctl
	 mxxd0JZAJcVi2X3KHR4aFVaMidwGCFjhHsn8N5w9/dqTyuUDP7cyMyvKOvxy1NOVsh
	 AmnnMyDK2c3YKCiuvoOIh+R0gjYbw7t2dXc3X19AIsHQIZJTSrBw7YgZ/ETbrJ6hR/
	 iMqnDFhauUkz8MSR8mZh7tiyzLlmwzRwOgD5yatwluEwMYkJ5pj4E+7rcL+EM7+ubJ
	 TRr7SnBoMdxaEizGrOq8sNRsdsXUuDfBxTHSXaLwxZqGB94pxOkm2QQy12YQUNj304
	 QQcnP1rjUtbEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 688D5C395E5;
	Fri,  2 Jun 2023 09:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] tls: suppress wakeups unless we have a full
 record
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168569641942.3424.14010250691576226665.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 09:00:19 +0000
References: <20230531153551.187141-1-kuba@kernel.org>
In-Reply-To: <20230531153551.187141-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 31 May 2023 08:35:50 -0700 you wrote:
> TLS does not override .poll() so TLS-enabled socket will generate
> an event whenever data arrives at the TCP socket. This leads to
> unnecessary wakeups on slow connections.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/tls/tls_main.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)

Here is the summary with links:
  - [net-next,1/2] tls: suppress wakeups unless we have a full record
    https://git.kernel.org/netdev/net-next/c/121dca784fc0
  - [net-next,2/2] selftests: tls: add tests for poll behavior
    https://git.kernel.org/netdev/net-next/c/23fcb62bc19c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



