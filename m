Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45E63E27F9
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbhHFKA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhHFKAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 06:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B6435611B0;
        Fri,  6 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628244006;
        bh=rt71S2O6mlS8r3GGfkNDOD1TGqW/cOPMrdVlU4BDvDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TDMSpaztSwaKW/ZRTL/lN6JkF3CGZFRGIfyXRo5S5KL3LCsO84ojpqWc+VYfbeA8s
         ttUKZtIHDOoiHJvULMj9YQTTRjC+deiYYAf+RjVjn0zmgy2itKRh8U+VT2CG7WsveF
         nzk6FWjq6s/ie8kesojSFRDtKotBJYJ5UOdIvGSmjhuTHNVux4F+YLJT0gv9ulCiU1
         iEaHtrE8kUwux0KjKqRGkA3jgEpcFuM1hGnxdCvHXjLnN3xZxVypUiMtBAzRXQ84lu
         piMUcFPy3DAsVq4PyBGvbNZb16oJg0iSFB+sQEyLP83oD49MH3je5K21nWM+csGdx8
         kY/txAZ9Bx1MA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA1A160A48;
        Fri,  6 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ptp: ocp: assorted fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824400669.32361.11067641825942861226.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 10:00:06 +0000
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 12:52:42 -0700 you wrote:
> Assorted fixes for the ocp timecard.
> 
> Jonathan Lemon (6):
>   ptp: ocp: Fix the error handling path for the class device.
>   ptp: ocp: Add the mapping for the external PPS registers.
>   ptp: ocp: Remove devlink health and unused parameters.
>   ptp: ocp: Use 'gnss' naming instead of 'gps'
>   ptp: ocp: Rename version string shown by devlink.
>   ptp: ocp: Remove pending_image indicator from devlink
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ptp: ocp: Fix the error handling path for the class device.
    https://git.kernel.org/netdev/net-next/c/d12f23fa5142
  - [net-next,2/6] ptp: ocp: Add the mapping for the external PPS registers.
    https://git.kernel.org/netdev/net-next/c/0d43d4f26cb2
  - [net-next,3/6] ptp: ocp: Remove devlink health and unused parameters.
    https://git.kernel.org/netdev/net-next/c/37a156ba4cbb
  - [net-next,4/6] ptp: ocp: Use 'gnss' naming instead of 'gps'
    https://git.kernel.org/netdev/net-next/c/ef0cfb3460a4
  - [net-next,5/6] ptp: ocp: Rename version string shown by devlink.
    https://git.kernel.org/netdev/net-next/c/1a052da92924
  - [net-next,6/6] ptp: ocp: Remove pending_image indicator from devlink
    https://git.kernel.org/netdev/net-next/c/8ef8ccbc6967

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


