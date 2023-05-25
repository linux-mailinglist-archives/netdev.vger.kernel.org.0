Return-Path: <netdev+bounces-5227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E804D71053F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAB5C1C20E94
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D1E79E0;
	Thu, 25 May 2023 05:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC425C9C;
	Thu, 25 May 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7613EC4339B;
	Thu, 25 May 2023 05:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684992021;
	bh=CYI7lFf8A+60XJDss+kj6fM+B7gkXxw8naBl6NkXIFw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FHa9hNUaGvZtB2EMUURBUvmkJaHQ8db57t0FNHbvXGMs3zk5sH/N2DMGWVKgr5XXN
	 t775ct9ZcqadwgiuBBVsDsCeefsSbUpDJcldbIOSgJ9W9FvI6ZTV5DWCdI17NAk10Q
	 cGBCzRq0Gx+FfkkZxKPUDHBPL42WrEvkspCZyIB5WMO3ZW9Rp2gtHQ9iLfmf2RUsZi
	 trMYwIq0vB0RDYy5/S6/5WAWydbou0h2Gm/GwfpTr18FPxncQkifbBgonOZhx23oz3
	 +K0v1mw2q7QYHTvrmdpM4jYpSrjFdC6trBRJY7UmD0uBcFace3dL3nHSeX9MnJBgft
	 P1VRqe3QuhzqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44653E4F133;
	Thu, 25 May 2023 05:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/6] Bug fixes for net/handshake
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168499202127.9034.1385623929748922621.git-patchwork-notify@kernel.org>
Date: Thu, 25 May 2023 05:20:21 +0000
References: <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
To: Chuck Lever <cel@kernel.org>
Cc: netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
 dan.carpenter@linaro.org, chuck.lever@oracle.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 May 2023 11:46:39 -0400 you wrote:
> Please consider these for merge via net-next.
> 
> Paolo observed that there is a possible leak of sock->file. I
> haven't looked into that yet, but it seems to be separate from
> the fixes in this series, so no need to hold these up.
> 
> Changes since v2:
> - Address Paolo comment regarding handshake_dup()
> 
> [...]

Here is the summary with links:
  - [v3,1/6] net/handshake: Remove unneeded check from handshake_dup()
    https://git.kernel.org/netdev/net/c/a095326e2c0f
  - [v3,2/6] net/handshake: Fix handshake_dup() ref counting
    https://git.kernel.org/netdev/net/c/7ea9c1ec66bc
  - [v3,3/6] net/handshake: Fix uninitialized local variable
    https://git.kernel.org/netdev/net/c/7afc6d0a107f
  - [v3,4/6] net/handshake: handshake_genl_notify() shouldn't ignore @flags
    https://git.kernel.org/netdev/net/c/fc490880e39d
  - [v3,5/6] net/handshake: Unpin sock->file if a handshake is cancelled
    https://git.kernel.org/netdev/net/c/1ce77c998f04
  - [v3,6/6] net/handshake: Enable the SNI extension to work properly
    https://git.kernel.org/netdev/net/c/26fb5480a27d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



