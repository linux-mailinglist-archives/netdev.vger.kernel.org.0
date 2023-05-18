Return-Path: <netdev+bounces-3676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E23870852C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29E7B1C2108C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B3A2107C;
	Thu, 18 May 2023 15:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C769121069
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D344C433D2;
	Thu, 18 May 2023 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684424419;
	bh=6UsXwIqhbmrBk1QtCMkYsBkeYqZarf/rNR/p6nAdrrw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XWM+RmVe4h4BKmKKlrggubu/t6v9qgJcJir2WZIcAr2mUxCfL45BQfpqZW49rFE+1
	 hCFks44SCNuiL3KJK/7WCfHRmMwSJ3XmC2UV9BcYncJsTzcE3a7NGj35dTMyCTPlDO
	 BmkJIQ5R66Zxt5cwn4/9iA/mDm0CxFgcs6/AxctQvkLn8M/JUKUntbFMYbKmVwixxI
	 v16OBrJFAxk2i7Ghyg0B1/ilthRYVo7I4cK7FPifqw0Wf4vn3WNTtHWTlMFYTkH87l
	 efjG6Ay1Zhxqdw3/Yiex+aQipO1FBWzDeETp6EPmatEG8cpMyF+mtc7PYEdstgrpus
	 xF12IO35yQyqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51231E54223;
	Thu, 18 May 2023 15:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] mptcp: add support for implicit flag
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168442441932.24963.14278314825736614994.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 15:40:19 +0000
References: <ff2f39fddd59cbeec87dc534e73f70a188649fe8.1684230221.git.aclaudi@redhat.com>
In-Reply-To: <ff2f39fddd59cbeec87dc534e73f70a188649fe8.1684230221.git.aclaudi@redhat.com>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 16 May 2023 11:48:04 +0200 you wrote:
> Kernel supports implicit flag since commit d045b9eb95a9 ("mptcp:
> introduce implicit endpoints"), included in v5.18.
> 
> Let's add support for displaying it to iproute2.
> 
> Before this change:
> $ ip mptcp endpoint show
> 10.0.2.2 id 1 rawflags 10
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] mptcp: add support for implicit flag
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=3a2535a41854

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



