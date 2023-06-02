Return-Path: <netdev+bounces-7578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D41C720AFB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 23:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B700F1C21177
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C608BEC;
	Fri,  2 Jun 2023 21:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934F6539C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 21:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1822DC4339B;
	Fri,  2 Jun 2023 21:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685741421;
	bh=UBEZCTBKNhKuXrHItBnV7qERlfG6xx4hYwgNOkAOCZg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IQ+FoFOVuMwj/aeUQlyoyIqa7mpzj9MA0D42uUgPtl1PQbq1PBQ5pLyuC3qcT/+wM
	 dRNgtuXYDhIfbgSmaQt3jM/duUMRnGhjkKTNCEsEeZSHOrCgHzbmfoqGezi7DEVwTp
	 3DPsesW0cqRDORGZr+sVrjO5lkpSxxIBWhbNL3zV2nnjOM5xb/UCbIAbBCQZVyFHf9
	 1aRaOKYqZVuOWjX163l1ySAhkDRO5dhn+Rgth3dEhYh8Dm3hO63zGtZ9q+HAYkOOUK
	 yCCZK6SQru13LvjL2gQXzs45/sMuGAza6UvpzXBC36ApH0cPO4JBCwavR0HXZrVCE2
	 W+0pADLERjcwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6A3EC395E0;
	Fri,  2 Jun 2023 21:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ipaddress: accept symbolic names
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168574142093.5602.13257939687178906303.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 21:30:20 +0000
References: <20230602155419.8958-1-stephen@networkplumber.org>
In-Reply-To: <20230602155419.8958-1-stephen@networkplumber.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, petrm@nvidia.com

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri,  2 Jun 2023 08:54:19 -0700 you wrote:
> The function rtnl_addproto_a2n() was defined but never used.
> Use it to allow for symbolic names, and fix the function signatures
> so protocol value is consistently __u8.
> 
> Fixes: bdb8d8549ed9 ("ip: Support IP address protocol")
> Cc: petrm@nvidia.com
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> 
> [...]

Here is the summary with links:
  - [iproute2] ipaddress: accept symbolic names
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=709063e8368a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



