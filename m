Return-Path: <netdev+bounces-6232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 205BB7154BB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A295A281041
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E4F4A11;
	Tue, 30 May 2023 05:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4933B7E9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA3DAC4339B;
	Tue, 30 May 2023 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685423421;
	bh=qi8/JqAqjaTLTCxS3RsyXt1xlnLa4VYLm8txfKfTDCQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=o4D60n0dIJIGIHTB8dqKquY/PsCFvXK7gJpo7NEE6VULyB2eNT3wESN/fMbIoaadn
	 1mjoqvExtHw2nwbY55+XFrp0D2ChY+KdJj+WlzLqYMufo73ctFkVGaDYjSpQidPB9L
	 d6ERd+E9DhtsNpjeSqiCT/oBL4AvSb7UaJry2SVTElztB/rV72t2mRT3thBK+ZaLNe
	 rxmc101LWuI/gDTfEhx3PEtDkGDCl0d7SOcNRzZKiLhU1RTxCF1X8elAPqsYc/VN0O
	 i4P5ZbXnfCmMNQx28HHzQESqM5lvfUyLkqI9tejoPZox29CKNHFkrWzp7tBACrVbEe
	 h5mrr8bql1krQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCC75E52BF4;
	Tue, 30 May 2023 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] netlink: specs: add ynl spec for ovs_flow
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542342083.26777.11973834461536613804.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:10:20 +0000
References: <20230527133107.68161-1-donald.hunter@gmail.com>
In-Reply-To: <20230527133107.68161-1-donald.hunter@gmail.com>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, donald.hunter@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 27 May 2023 14:31:03 +0100 you wrote:
> Add a ynl specification for ovs_flow. The spec is sufficient to dump ovs
> flows but some attrs have been left as binary blobs because ynl doesn't
> support C arrays in struct definitions yet.
> 
> Patches 1-3 add features for genetlink-legacy specs
> Patch 4 is the ovs_flow netlink spec
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] doc: ynl: Add doc attr to struct members in genetlink-legacy spec
    https://git.kernel.org/netdev/net-next/c/6d6bae63053d
  - [net-next,v2,2/4] tools: ynl: Initialise fixed headers to 0 in genetlink-legacy
    https://git.kernel.org/netdev/net-next/c/5ac18889bde0
  - [net-next,v2,3/4] tools: ynl: Support enums in struct members in genetlink-legacy
    https://git.kernel.org/netdev/net-next/c/313a7a808ca8
  - [net-next,v2,4/4] netlink: specs: add ynl spec for ovs_flow
    https://git.kernel.org/netdev/net-next/c/93b230b549bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



