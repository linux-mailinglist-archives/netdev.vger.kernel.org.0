Return-Path: <netdev+bounces-765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 931076F9C87
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 00:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D26CF1C20994
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 22:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF3C10960;
	Sun,  7 May 2023 22:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771CDAD4E
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 22:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EA07C4339C;
	Sun,  7 May 2023 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683499220;
	bh=mnC48Bnc0RT20ryfNIQqgcqd8F4XS8lOCfGVodF8Ejs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Tyz/d50VxJA/YBw70pt2tDoeePIJEkbD7z0x56YrIAeakqSNrfEWMobVy6gVPmiz6
	 Y/NJGs5/a8MkeOZhIfzXUs24OSCNbQN6jbud3VnFs++OT61+TndOpyE5hQC5Gu5c8y
	 OaajkTeknurtAiYOEtm+qjHFfUjTQP5fzB8/np2V01zcuI3EO/Oo/BgMQyqvQoeVHb
	 YfZhI90YwEgMsUSLaXGJ6ZeVxChyNGEHL171oUCDIlDivDVkgxCoPnnIE1unODNAGw
	 qI3BSN5/sYitH0iVAMaj7phD9ZUrdge3vUAEv3wpRUTH6OD1HgZQ6uAe2b8s2bk/Tz
	 4OW5rTnZWrv9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1CC7E26D20;
	Sun,  7 May 2023 22:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool 0/3] Fix issues found by gcc -fanalyze
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168349921998.21680.10038176515732974788.git-patchwork-notify@kernel.org>
Date: Sun, 07 May 2023 22:40:19 +0000
References: <cover.1682894692.git.nvinson234@gmail.com>
In-Reply-To: <cover.1682894692.git.nvinson234@gmail.com>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: mkubecek@suse.cz, netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Sun, 30 Apr 2023 18:50:49 -0400 you wrote:
> This patch series provides updates to correct issues found by gcc -fanalyze. The
> issues were found by specifying the following flags when building:
> 
> CFLAGS="-march=native -O2 -pipe -fanalyzer -Werror=analyzer-va-arg-type-mismatch
>             -Werror=analyzer-va-list-exhausted -Werror=analyzer-va-list-leak
>             -Werror=analyzer-va-list-use-after-va-end"
> 
> [...]

Here is the summary with links:
  - [ethtool,1/3] Update FAM syntax to conform to std C.
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=77599cf04110
  - [ethtool,2/3] Fix reported memory leak.
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=7de97fb99868
  - [ethtool,3/3] Fix potentinal null-pointer derference issues.
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



