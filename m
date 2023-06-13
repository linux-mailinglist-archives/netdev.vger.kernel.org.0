Return-Path: <netdev+bounces-10484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C451572EB41
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAE3D281251
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F002B1ED43;
	Tue, 13 Jun 2023 18:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A31136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A05F6C433F1;
	Tue, 13 Jun 2023 18:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686682220;
	bh=zD0WG6zrdeaxaCCcFm+S0+uA8bch/+W3WTE5o3NrbT4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fQ9djpr8YpVRLwQbSDPMT10m4VTpFKB0H8MBA30ZQ0B/nWNp9FKRwNKlSrsYsOXH3
	 czQbNT15VVzc88TlpGRaD98OEYlf9SATqy0LJLvTt47eRDEvUbRulhk3XmOWeEDNi8
	 1w2hrcMTHy51eVe5ePAVJN3VLVxx5lHhdvSuP1UfwdLJJXJAFI2khfjTGgua+ogxCM
	 97i4Hr1/7KrcP5Wjkge1wXtu5uRrPqkS3Bn4/B2IYTdAPtNVrinL6fnuN7lRm1Qmlj
	 QGYAT2LDS2xLHD3Zx9Y0So+ODK4DTftT79IJ6ckQwd28KZN4A3ahOu605SPH5bpg/y
	 DxEa4H1hJfRmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6842BC32760;
	Tue, 13 Jun 2023 18:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] tools: ynl-gen: improvements for DPLL
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168668222041.8031.13155368995124852397.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 18:50:20 +0000
References: <20230612155920.1787579-1-kuba@kernel.org>
In-Reply-To: <20230612155920.1787579-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, arkadiusz.kubalewski@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 08:59:18 -0700 you wrote:
> A set of improvements needed to generate the kernel code for DPLL.
> 
> Jakub Kicinski (2):
>   tools: ynl-gen: correct enum policies
>   tools: ynl-gen: inherit policy in multi-attr
> 
>  tools/net/ynl/ynl-gen-c.py | 57 +++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 20 deletions(-)

Here is the summary with links:
  - [net-next,1/2] tools: ynl-gen: correct enum policies
    https://git.kernel.org/netdev/net-next/c/10c4d2a7b88d
  - [net-next,2/2] tools: ynl-gen: inherit policy in multi-attr
    https://git.kernel.org/netdev/net-next/c/be093a80dff0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



