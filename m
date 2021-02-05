Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8398531044B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhBEFBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhBEFAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DE53E64F45;
        Fri,  5 Feb 2021 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612501207;
        bh=/DKHZmraTzfKVDSf4OjToPF4d7pYKU8I3WG9LeQaQHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NTDX0vhiZDvlPh/KEhEYGuPb7cpxAG23OExPfdxLSgit0AT+NShZGt0FC3F3LjqEq
         1SEtHLAw9OwYddL0858jWrDS+1mAtPHiwn4U/+uvkfJkcgNzmXjHpaWu1WFsSr7d6L
         d3HXSeDLbpyDrFfr/ndGuVrJK+1D4L5BKa0+LQxZbfp8wNw4t/QkaRPa63oOvwvVEB
         uov8qCEahC5s3YQhaQudqFXSfp0oytm4iRMJFsd9zxzmWV+SH2/Qzgx14ZXnnh/XSi
         3TGEeLPKqpDuRpXUjDZsV9fAjUjiPnS06ZVhoBCtcX0CzATYpc9Vk3NPMeHW7fcF2i
         +Ovujq6TiColQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C77E1609E5;
        Fri,  5 Feb 2021 05:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] r8152: adjust flow for power cut
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250120781.4551.10548606123432458434.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 05:00:07 +0000
References: <1394712342-15778-398-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-398-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 3 Feb 2021 17:14:27 +0800 you wrote:
> The two patches are used to adjust the flow about resuming from
> the state of power cut. For the purpose, some functions have to
> be updated first.
> 
> Hayes Wang (2):
>   r8152: replace several functions about phy patch request
>   r8152: adjust the flow of power cut for RTL8153B
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] r8152: replace several functions about phy patch request
    https://git.kernel.org/netdev/net-next/c/a08c0d309d8c
  - [net-next,2/2] r8152: adjust the flow of power cut for RTL8153B
    https://git.kernel.org/netdev/net-next/c/80fd850b31f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


