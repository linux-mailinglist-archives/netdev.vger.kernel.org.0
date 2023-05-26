Return-Path: <netdev+bounces-5652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C20671255D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A8812816B2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB91742E7;
	Fri, 26 May 2023 11:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E74F742E0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C44BBC433EF;
	Fri, 26 May 2023 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685100019;
	bh=eFjSLiRY8ppYHMgB/OldFTD85SqORHj1MT2v1Pqux3M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Jl2OIrNe51z0ebv0msvRLFEz+PVV0cVE0TWT+XvS3Y5sL7fDExNr/NHNXVovwFtbb
	 e4NvRrowVbdqM/e47YqoO1fWmyqkZpm1gE8XYlt9kyCQb4giTJlSZrkOAogZ5XT5TX
	 lB2XvPBtFiW0o0vqiRsvTr+ZhTeaB+gF0zs7oj6REtayTOQvSQ4/VMGrl86565rBJF
	 VdCL2qmVYKdnxChI/vQwBjnXSjFLGTam1zvV+wajWDoiH6IjdL3iklmXoQdwJDHEDu
	 Yy8/UR4f7+SCsCb/pfg7fd+BJnEr2ouPKR+kB5RQ+VrghNbTqw8sd41+xbBwuQjsIQ
	 4x5zCS+2V/SkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9F24E4D00E;
	Fri, 26 May 2023 11:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfcsim.c: Fix error checking for debugfs_create_dir
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168510001969.13772.16876923657799508663.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 11:20:19 +0000
References: <20230525172746.17710-1-osmtendev@gmail.com>
In-Reply-To: <20230525172746.17710-1-osmtendev@gmail.com>
To: Osama Muhammad <osmtendev@gmail.com>
Cc: krzysztof.kozlowski@linaro.org, simon.horman@corigine.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 25 May 2023 22:27:46 +0500 you wrote:
> This patch fixes the error checking in nfcsim.c.
> The DebugFS kernel API is developed in
> a way that the caller can safely ignore the errors that
> occur during the creation of DebugFS nodes.
> 
> Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] nfcsim.c: Fix error checking for debugfs_create_dir
    https://git.kernel.org/netdev/net/c/9b9e46aa0727

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



