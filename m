Return-Path: <netdev+bounces-5826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE4A713028
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 386661C21103
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB892A9EF;
	Fri, 26 May 2023 22:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C210015B7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 22:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5953EC4339B;
	Fri, 26 May 2023 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685141420;
	bh=buJ0kg9TthoEcX/t2xhiboAClMDfGdVzjvAmmxVZnrU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=CMHL6mnZHy+qC8VsU1uYE6yHPbYHewUKYPDIi2AhaW1wYAQz4LkaWhMoA5jpNP/qW
	 rb6cm1582dHZ1aXjQ/7yhhpxt63KaPPLngKlZqGCS1ltDEF6IBXuOj/O7Ruo6M9lWr
	 0vR/twDxtvsOhF/KQxLHs1OAQO78h26KhmpVbYZKxqGrPzU9i5U66wdXDkjYiSs8FD
	 BxkQ9xZsWs2ajkG/x4jCN3DUemcxOHdDtUjRO3rtkcB7jGFa+Cm5Vf9MU0ETd9ZnKf
	 TtVs/z2MroHEMiqTL2hLOQNc4o+KlodC8ZLUlUB2dYCF7bi6cdIMd4AJ0d/jZrLBuC
	 C6xuNhVZxk9GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 341CAE22B06;
	Fri, 26 May 2023 22:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v1] Bluetooth: L2CAP: Fix use-after-free
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <168514142020.22605.4446430781940089100.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 22:50:20 +0000
References: <20230524170415.kernel.v1.1.I575ec21daa35ebba038fe38e164df60b6121c633@changeid>
In-Reply-To: <20230524170415.kernel.v1.1.I575ec21daa35ebba038fe38e164df60b6121c633@changeid>
To: Zhengping Jiang <jiangzp@google.com>
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
 luiz.dentz@gmail.com, chromeos-bluetooth-upstreaming@chromium.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 johan.hedberg@gmail.com, pabeni@redhat.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 24 May 2023 17:04:15 -0700 you wrote:
> Fix potential use-after-free in l2cap_le_command_rej.
> 
> Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> ---
> 
> Changes in v1:
> - Use l2cap_chan_hold_unless_zero to prevent adding refcnt when it is
>   already 0.
> 
> [...]

Here is the summary with links:
  - [kernel,v1] Bluetooth: L2CAP: Fix use-after-free
    https://git.kernel.org/bluetooth/bluetooth-next/c/a088d769ef3a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



