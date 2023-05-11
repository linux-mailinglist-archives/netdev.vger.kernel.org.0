Return-Path: <netdev+bounces-1963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 068496FFBC6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 236FD1C21069
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1253A174D8;
	Thu, 11 May 2023 21:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19E3BA27
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D08AC4339B;
	Thu, 11 May 2023 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683840021;
	bh=tyhWs0Gzg/ruv0B2RVXNKEGY2zh56J5wMS6MADDxp8A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rRXMJAcZAbTxuI5QsqniVTJNM3Xp4Paqv+haK0wZ1WCr5kh3Qze09Ps/m1/1vb/pv
	 r0/rWOHYwNbSHLLNmoqKV56tKLNLawf9oOTyhw5M+sLygdKSt7mCH+aD4ycLDA7mUk
	 FLOfPxQlJ28CRdAUd+7xCMk2mimAScwP0UyKOZ3bKOJeowrvavy9+oa06IPfL4Gw21
	 2Tq6bkW0jua5z+PxyXltIgAPeFfWm/6bLNfg7c42+llZPZ1nbCSRn4ibclx9HsquAn
	 xmluorT9Yd2aT3ogh9gQ3XC2P7ivf2VGUr0emgMJPLUDHeQjUBMhkWwkmlpCJuc/l+
	 mJtDOIzMv1DdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29993E26D4C;
	Thu, 11 May 2023 21:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipruote2: optimize code and fix some mem-leak risk
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168384002116.32472.12709356000117399209.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 21:20:21 +0000
References: <20230510133616.7717-1-izhaoshuang@163.com>
In-Reply-To: <20230510133616.7717-1-izhaoshuang@163.com>
To: zhaoshuang <izhaoshuang@163.com>
Cc: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 10 May 2023 21:36:16 +0800 you wrote:
> From: zhaoshuang <zhaoshuang@uniontech.com>
> 
> Signed-off-by: zhaoshuang <zhaoshuang@uniontech.com>
> Signed-off-by: zhaoshuang <izhaoshuang@163.com>
> ---
>  bridge/mdb.c      |  4 ++++
>  devlink/devlink.c | 21 +++++++++------------
>  ip/ipaddrlabel.c  |  1 +
>  ip/ipfou.c        |  1 +
>  ip/ipila.c        |  1 +
>  ip/ipnetconf.c    |  1 +
>  ip/ipnexthop.c    |  4 ++++
>  ip/iproute.c      |  6 ++++++
>  ip/iprule.c       |  1 +
>  ip/iptuntap.c     |  1 +
>  ip/tunnel.c       |  2 ++
>  tc/tc_class.c     |  1 +
>  tc/tc_filter.c    |  1 +
>  tc/tc_qdisc.c     |  1 +
>  14 files changed, 34 insertions(+), 12 deletions(-)

Here is the summary with links:
  - ipruote2: optimize code and fix some mem-leak risk
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=7e8cdfa2eac5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



