Return-Path: <netdev+bounces-9411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24BF3728D6A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 426FE1C21038
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F09EDB;
	Fri,  9 Jun 2023 02:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F333ED7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90641C4339B;
	Fri,  9 Jun 2023 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686276020;
	bh=aUz/MkujVJ+dzMKz/Qiit2ifXy4dyKEji7wQ9poFnT8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=U0oQlgL+iEHkZ1P9klyfXcmEbJElT74E6IbDeAC4pUd5kyOV6NrQskyTGv1Wbzb8+
	 be6ChniWNF5CuBxAc6p/x22PpXCqUA5JNwhN4IO6dki/0tj+x56Xq1wYUz+2SXTFt9
	 oDxDFO1R9/b7cGYepyWKAM4buQLdDAqpTL9sH4zrm1uLbLxBdeUCx0cK+vTKFfLn5Q
	 PugPiUUxevWzVHG1B3REIAy5rrHZFsHGnfODjnbvDxrdOrWOuuR1bNXy2Z17zfqMh5
	 h+5CgMd5eBrVKxKQagBsaxwdlOdfDmAw/KqN72JECJ+YZ+qFqKQFsSG+tPwbZigMkC
	 EROeJ5AY89cOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66FFEE451B4;
	Fri,  9 Jun 2023 02:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: spectrum_nve_vxlan: Fix unsupported flag
 regression
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627602041.23497.16276136341516762015.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:00:20 +0000
References: <5533e63643bf719bbe286fef60f749c9cad35005.1686139716.git.petrm@nvidia.com>
In-Reply-To: <5533e63643bf719bbe286fef60f749c9cad35005.1686139716.git.petrm@nvidia.com>
To: Petr Machata <petrm@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
 vladimir@nikishkin.pw, mlxsw@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 7 Jun 2023 14:19:26 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The recently added 'VXLAN_F_LOCALBYPASS' flag is set by default on VXLAN
> devices and denotes a behavior that is irrelevant for the hardware data
> path. Add it to the lists of IPv4 and IPv6 supported flags to avoid
> rejecting offload of VXLAN devices which have this flag set.
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: spectrum_nve_vxlan: Fix unsupported flag regression
    https://git.kernel.org/netdev/net-next/c/37ff78e977f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



