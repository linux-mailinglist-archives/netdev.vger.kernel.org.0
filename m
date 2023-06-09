Return-Path: <netdev+bounces-9467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E659F729524
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419A11C210F0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDCC12B6C;
	Fri,  9 Jun 2023 09:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641D4125D7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2518C4339B;
	Fri,  9 Jun 2023 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686303020;
	bh=JWrMxZnb/3WdogQ1aDl5e0b0Ny+udzeKoKkV9zasPM0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E7rssq7Rr+1zYTHknXTN8sCLHgsfhImGBhvNdvmuPqHpabzgCZHXxd8EjjGWXHAC/
	 rhgtpua4yG3Omw5QEiQbeFYRhJiTHddRtgVdHfoE0rOSUOue2wkGxtV/X8eLzy9kUk
	 sdwQ8sfm0Z9+rFKnlk+OWXfKGEPDaL2SIWv2YyI+rQuV9ghpnHoaFwn0+3oyzO4qcN
	 cMqFlUTJWRwN0GVYNwFiz4K+Z4nKjTSMgweck07hiDb2iWk+BAM+JS+qJWNvj/lsAW
	 yBoGCMUpn1PkrJwkdnTiiwyIQWJ/eWrm6CYYevrUdaQ3Smjq/0Neu1tpwVhG/3WTEJ
	 /Gt/0ZPNYtXkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A87E2C43143;
	Fri,  9 Jun 2023 09:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 1/4] usbnet: ipheth: fix risk of NULL pointer
 deallocation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630302068.8448.16788889957368567496.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 09:30:20 +0000
References: <20230607135702.32679-1-forst@pen.gy>
In-Reply-To: <20230607135702.32679-1-forst@pen.gy>
To: Foster Snowhill <forst@pen.gy>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, gvalkov@gmail.com, simon.horman@corigine.com,
 jan.kiszka@siemens.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Jun 2023 15:56:59 +0200 you wrote:
> From: Georgi Valkov <gvalkov@gmail.com>
> 
> The cleanup precedure in ipheth_probe will attempt to free a
> NULL pointer in dev->ctrl_buf if the memory allocation for
> this buffer is not successful. While kfree ignores NULL pointers,
> and the existing code is safe, it is a better design to rearrange
> the goto labels and avoid this.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] usbnet: ipheth: fix risk of NULL pointer deallocation
    https://git.kernel.org/netdev/net-next/c/2203718c2f59
  - [net-next,v4,2/4] usbnet: ipheth: transmit URBs without trailing padding
    https://git.kernel.org/netdev/net-next/c/3e65efcca87a
  - [net-next,v4,3/4] usbnet: ipheth: add CDC NCM support
    https://git.kernel.org/netdev/net-next/c/a2d274c62e44
  - [net-next,v4,4/4] usbnet: ipheth: update Kconfig description
    https://git.kernel.org/netdev/net-next/c/0c6e9d32ef0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



