Return-Path: <netdev+bounces-7180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BBB71F053
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A0331C210C7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B1042532;
	Thu,  1 Jun 2023 17:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2927B4252A
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73745C4339B;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685639424;
	bh=SW4gSeRN3rTT47KKNsamE8VVJ7Pdfw5Um7IX3XCChJg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NvWsufnWUYQkuK2M+GnEM+vt+5Kj0r9l6w2vC46po6BE1wRS7HQLcT6YCRFWn3Fhf
	 o4U/Emz4sw3g67tQ3Xf6rqRrpC2ysq5AxSntOseQKfUUC5J/ln3/Kcj6VkOC53TGYR
	 6OFPM6jjV65tvEYdesF2k+ydblNP63bGc7fhVASYC2cDAj7yvLNzpwIgU+RRnf/DG5
	 msgU7lmMYjXkUQ6fPUalKnribXqk6vM48I27Y2yKMhOYWHpVuVZuVOblHBLcCb5a/u
	 yM4dHqpFaH4efgwjlSX+Dqbzlu20kq0QJt5T9xB0adsjGnGuuwCawNJO4eMHB/FIFR
	 rhL4a+g4bexBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50EDBC395E5;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/3] rtnetlink: a couple of fixes in linkmsg validation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168563942432.9709.15748951411425299009.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 17:10:24 +0000
References: <cover.1685548598.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1685548598.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com, stephen@networkplumber.org,
 kaber@trash.net, tgraf@infradead.org, alexanderduyck@fb.com,
 simon.horman@corigine.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 12:01:41 -0400 you wrote:
> validate_linkmsg() was introduced to do linkmsg validation for existing
> links. However, the new created links also need this linkmsg validation.
> 
> Add validate_linkmsg() check for link creating in Patch 1, and add more
> tb checks into validate_linkmsg() in Patch 2 and 3.
> 
> v2:
> - not improve the multiple times validating in patch 1, and will do it
>   in net-next, as Jakub suggested.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/3] rtnetlink: call validate_linkmsg in rtnl_create_link
    https://git.kernel.org/netdev/net/c/b0ad3c179059
  - [PATCHv2,net,2/3] rtnetlink: move IFLA_GSO_ tb check to validate_linkmsg
    https://git.kernel.org/netdev/net/c/fef5b228dd38
  - [PATCHv2,net,3/3] rtnetlink: add the missing IFLA_GRO_ tb check in validate_linkmsg
    https://git.kernel.org/netdev/net/c/65d6914e253f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



