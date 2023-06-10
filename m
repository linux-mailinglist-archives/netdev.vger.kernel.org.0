Return-Path: <netdev+bounces-9792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50BAF72A9BD
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 853801C21123
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC9579E3;
	Sat, 10 Jun 2023 07:12:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189BC1878
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D083C433EF;
	Sat, 10 Jun 2023 07:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381133;
	bh=jeg7h+LomgBxNHeFhJ5nIU+VcoQJnfEESv6WDiba+yY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=amcQ1jfIZJ/F8Sv+vro2QF+/i/pHLQ/RSyeN3G+EAtpLRO7NzhcP13iSikQlEYGXc
	 nJ42JVrEzyNz4Up0+u4Cw4xMaFxq/ppV4O5+n9DxLP0RCuk4pH3ayBn9OvQah8eKk1
	 e0ZXWpCArBO0/cYklZDe2JefhXF8lKt4QMzMYCId1ue1Bzrp2bI2pW9gPPvC+P/+h5
	 vLtSUOfo2hZ0I2muPFjdIyhE+Wf/eROnM3UhweUPvc4PHC1NljTBSsowyXbV9innb+
	 YmnOGG9Y+9Lp6vSYQxLALOrRNkHg0ldjVemSJzDcPNtxNuPqdfXszquK23P/Uyswo4
	 iGUUxVIx/+uwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E2E8E87232;
	Sat, 10 Jun 2023 07:12:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] iavf: remove mask from iavf_irq_enable_queues()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168638113344.4960.9211750172078230923.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 07:12:13 +0000
References: <20230608200226.451861-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230608200226.451861-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, ahmed.zaki@intel.com,
 rafal.romanowski@intel.com, simon.horman@corigine.com,
 maciej.fijalkowski@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Jun 2023 13:02:26 -0700 you wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> Enable more than 32 IRQs by removing the u32 bit mask in
> iavf_irq_enable_queues(). There is no need for the mask as there are no
> callers that select individual IRQs through the bitmask. Also, if the PF
> allocates more than 32 IRQs, this mask will prevent us from using all of
> them.
> 
> [...]

Here is the summary with links:
  - [net] iavf: remove mask from iavf_irq_enable_queues()
    https://git.kernel.org/netdev/net/c/c37cf54c12cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



