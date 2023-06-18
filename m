Return-Path: <netdev+bounces-11768-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB1E7345D4
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 12:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30DEC2811F5
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A585EBE47;
	Sun, 18 Jun 2023 10:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23270BA30
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 710AEC433C9;
	Sun, 18 Jun 2023 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687084219;
	bh=5fsuaDnwo2qvmwk8ou2lxLE0fvol54AynpeZPNcwaPM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lDsrpVBDDA6CnkU/0DJrMu+5EtLL74KbXD5m+eqaoLiLac4kIN1LOt7EM5BsrCn72
	 g0B24gBDO8sZ6umP7D6UrFTJcQsxkuDb+xDtqyQ32eTYqRprTL9DqbcwcVd4y8Rcsp
	 588Jw41xyTMboYzVQpI16bpXH/S9i98PoSkRe9VF86zFA93J2RYc4J6BmB0BB9DQ7t
	 ymKtK9iWAgbnOXqunV+YhH7LDDASZ/Jtza5IwqoiURpxgf44Fb/CzzEontlOrKo3iJ
	 WNKMyvZ5LXsZOPI2isB5OY3AwChO5IhJPLFHsdFMD34d6sB6l+oJHSR3/wIS4JDGUu
	 Nh43sS4bQSu6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56C08E21EE5;
	Sun, 18 Jun 2023 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: fdp: Add MODULE_FIRMWARE macros
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168708421935.2238.16204190681278158265.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 10:30:19 +0000
References: <20230616122218.1036256-1-juerg.haefliger@canonical.com>
In-Reply-To: <20230616122218.1036256-1-juerg.haefliger@canonical.com>
To: Juerg Haefliger <juerg.haefliger@canonical.com>
Cc: krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, davem@davemloft.net, shangxiaojing@huawei.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 14:22:18 +0200 you wrote:
> The module loads firmware so add MODULE_FIRMWARE macros to provide that
> information via modinfo.
> 
> Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
> ---
>  drivers/nfc/fdp/fdp.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - nfc: fdp: Add MODULE_FIRMWARE macros
    https://git.kernel.org/netdev/net/c/eb09fc2d1416

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



