Return-Path: <netdev+bounces-110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E7A6F52F9
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26C3528120B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE487484;
	Wed,  3 May 2023 08:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCCF1FA6
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D7F2C433A1;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102021;
	bh=hDSioszy6Y34PmcJRNS3GXKRfFZ/Kj6RSB9yGb5Yt1c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cbo3u69r+WsVNWPH1RMJQdU/zWFyfo4ZLUiPuXUK9aSPTM1Kxr1OphQCsSbPgiSVi
	 ajAJ8mDtBsbyrnZbCGU9SMLkqGiyR93Jf34wUEuI+f42+2c3ExRvrLZwImj58FE1vv
	 3s7R7QFLBnkoyRWaBc1iaGiJYIY+dzghm6siXF+29TQKmJrJhrq3pD8EjMsg7jSJY5
	 WFFbDaWzusdGuOe0moWCd91yJxyMfkVb1jdzjIYLyZtDvnd/30u8hk4HDfnYy5q0T3
	 25DX1v+/oQNyytYO5kObjuqS+nVwhBErm3PnR/Yu7czGzftlYy3uGfNJ4Nz4SP4jOO
	 kLGcQefdA3srg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F841E270D2;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ionic: catch failure from devlink_alloc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310202112.22454.11412734390478086148.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:20:21 +0000
References: <20230502183536.22256-1-shannon.nelson@amd.com>
In-Reply-To: <20230502183536.22256-1-shannon.nelson@amd.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 drivers@pensando.io

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 2 May 2023 11:35:36 -0700 you wrote:
> Add a check for NULL on the alloc return.  If devlink_alloc() fails and
> we try to use devlink_priv() on the NULL return, the kernel gets very
> unhappy and panics. With this fix, the driver load will still fail,
> but at least it won't panic the kernel.
> 
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] ionic: catch failure from devlink_alloc
    https://git.kernel.org/netdev/net/c/4a54903ff68d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



