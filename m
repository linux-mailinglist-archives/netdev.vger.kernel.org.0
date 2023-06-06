Return-Path: <netdev+bounces-8363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AEDD723D0C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44949281568
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7059B29103;
	Tue,  6 Jun 2023 09:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EC6290EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E13E8C433D2;
	Tue,  6 Jun 2023 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686043219;
	bh=/+rylvu8Mz/qtfgKe768sQKUURkl0bCB2iFs3pRfaZs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J1E6mZvL1pymEpHiqB2aSez+t6FwcLaYsYETP/DWKrMwFRdRIl4qRzLTKAKQlsQLP
	 EWlT7QN04qFCv1RlUGY4ilidwo0VI00thK9xO6LhDjx0zGVfhRbo88/lAfpQ4KeH4I
	 THfZv41UYi4CJcTrSU1933XTKifm0Me/ZyHbsnodDm2v9qEGszxIuq1z4sTbxNBAMd
	 411BAmUyNaZ6/k2mdfzDw0rEPmLbbIfzM74qdGvv6LoSg5IRm6iqHAzi9DEEMtF4Aq
	 ikBaUWHR5fV1teN3nG2Hrpe0/PUfHXXxbQSjdsDYuPjp5LgzxYg/6vU2b3MyHFuaPd
	 BXybAh6pk0zDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF420E29F39;
	Tue,  6 Jun 2023 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/1] gro: decrease size of CB
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168604321977.4013.1675491592368400059.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 09:20:19 +0000
References: <20230601160924.GA9194@debian>
In-Reply-To: <20230601160924.GA9194@debian>
To: Richard Gobert <richardbgobert@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, aleksander.lobakin@intel.com, lixiaoyan@google.com,
 lucien.xin@gmail.com, alexanderduyck@fb.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 1 Jun 2023 18:09:28 +0200 you wrote:
> This patch frees up space in the GRO CB, which is currently at its maximum
> size. This patch was submitted and reviewed previously in a patch series,
> but is now reposted as a standalone patch, as suggested by Paolo.
> (https://lore.kernel.org/netdev/889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com/)
> 
> Changelog:
> 
> [...]

Here is the summary with links:
  - [v3,1/1] gro: decrease size of CB
    https://git.kernel.org/netdev/net-next/c/7b355b76e2b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



