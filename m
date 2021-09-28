Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B141AF91
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbhI1NBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240669AbhI1NBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 09:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5FA8961266;
        Tue, 28 Sep 2021 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632834008;
        bh=KLqbuPZ3awNNYmQUgRZ2qZO8U8LeOPmjZWD6mYgN4Go=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VztWJL/RZqUW5yb4RAKLeJJ51WszqYwLK+Y1Pxm6uBHlUZLIXlBTBq5cF24xXbpgz
         z8v0ODZh+dys3UgF3nJdC/pdNFf4VKtpj3ABZqndrJcPV82qNnwoqgWieg5yshCLAS
         LWIgQQYihgaxzyfjo2LQFKOS2bzvINl0qEte/8AOJSNQYzIZMyGRRAySNoRxdOcmnR
         ezy3myEKpZ5LVnI47L27t7x2XQJbOnvgP2U47Gd96FyQBdTp78T6IIzWmCpE7N2BC2
         E45ySBtoYmilKYMvcTp808D0YsBUHDDkhXuYsnPd4AQ6n/tKlCWQkeezOf74dkyH9s
         gETRoL2DLXtig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52BEC60A69;
        Tue, 28 Sep 2021 13:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/4] Externel ptp clock support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283400833.20418.1869935426050637692.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 13:00:08 +0000
References: <20210928113101.16580-1-hkelam@marvell.com>
In-Reply-To: <20210928113101.16580-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 17:00:57 +0530 you wrote:
> Externel ptp support is required in a scenario like connecting
> a external timing device to the chip for time synchronization.
> This series of patches adds support to ptp driver to use external
> clock and enables PTP config in CN10K MAC block (RPM). Currently
> PTP configuration is left unchanged in FLR handler these patches
> addresses the same.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] octeontx2-af: Reset PTP config in FLR handler
    https://git.kernel.org/netdev/net-next/c/e37e08fffc37
  - [net-next,2/4] octeontx2-af: cn10k: RPM hardware timestamp configuration
    https://git.kernel.org/netdev/net-next/c/d1489208681d
  - [net-next,3/4] octeontx2-af: Use ptp input clock info from firmware data
    https://git.kernel.org/netdev/net-next/c/e266f6639396
  - [net-next,4/4] octeontx2-af: Add external ptp input clock
    https://git.kernel.org/netdev/net-next/c/99bbc4ae69b9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


