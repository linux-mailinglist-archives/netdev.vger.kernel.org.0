Return-Path: <netdev+bounces-8679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C937252BC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A34752810D1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C5381F;
	Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FBBA5E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C93BEC4339B;
	Wed,  7 Jun 2023 04:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686111622;
	bh=jEWyIKzMhyKk+pCIj7/Ov4ot3qtkNUAnCrmXnIRx7NU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ORF8nz1ALg92XVLC69qgRiJDg/9XVH82dJ4eP8OUfhYRpn+DmGWNkgoG7n8vTS0O3
	 YY0aZ/KVEJ7lvVvVVRaP4tnqgpdf6elKUDbRvlh3W4sRcFG8rbbvQm9u02rbULkp/2
	 KtcX0c0NTaJG667zNAEoYLuAoZ7kw1HX4PNLd4DZtAWUKNdzndqLI5t2+/5ZxOSGM6
	 +xvLEjScykeHsczOYeBYhXlH5+a1U4G3e4ZS0JDyKP+842Kyc4jNHzD0Wo5H/NIIwG
	 kaD0ezU6jwxqA+qRrEiJ6CdyF5UcS6ljaJyKvUiDbHvahU0r/6Tm3ltR6byiO8kv1G
	 PMLfUF6fOlUtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A370DE8723C;
	Wed,  7 Jun 2023 04:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] pds_core: Fix FW recovery detection
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611162266.32150.3491600977084749075.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 04:20:22 +0000
References: <20230605195116.49653-1-brett.creeley@amd.com>
In-Reply-To: <20230605195116.49653-1-brett.creeley@amd.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 shannon.nelson@amd.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 5 Jun 2023 12:51:16 -0700 you wrote:
> Commit 523847df1b37 ("pds_core: add devcmd device interfaces") included
> initial support for FW recovery detection. Unfortunately, the ordering
> in pdsc_is_fw_good() was incorrect, which was causing FW recovery to be
> undetected by the driver. Fix this by making sure to update the cached
> fw_status by calling pdsc_is_fw_running() before setting the local FW
> gen.
> 
> [...]

Here is the summary with links:
  - [net] pds_core: Fix FW recovery detection
    https://git.kernel.org/netdev/net/c/4f48c30312b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



