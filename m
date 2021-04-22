Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9936887E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbhDVVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhDVVUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:20:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F96761406;
        Thu, 22 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619126409;
        bh=RGNneSD2l5wopnH94EKqNGopTGxfb8buT03WI3gH7Dw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K/CwQ8FG7qRYSnIyysXYfrwjDmjdGocYeZ+EG4FcFx7pzWqEgXoocQple5JhVCJ1k
         FcZW2/cW4AGv4wY9CvHru7+D8waBU3E++SG/on2sbPHe3MXm58pICv0Sax/PlzFy1C
         IbQwag+qyyFXn6kEEnNvY1uVJF69Kfiv6YaEfZPORS3vxEQyAgJzQPpadFJetRuyXl
         q9Ki8D9GTu3OQm4MDni2GRGkCunlq45SYDFKbdVabE+28rxo7gWBTcyu8xTmPB2eD5
         /8HToT/pOASHHA3J5JWOsGApNw0Kq9YwAJLNj30ZivU4HQg0j30Iku755y2sSA9Cb3
         lEXEKMBVKc9SQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 375DD60A53;
        Thu, 22 Apr 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8152: replace return with break for ram code
 speedup mode timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912640922.15549.7928635712864520520.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 21:20:09 +0000
References: <1394712342-15778-358-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-358-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 16:48:02 +0800 you wrote:
> When the timeout occurs, we still have to run the following process
> for releasing patch request. Otherwise, the PHY would keep no link.
> Therefore, use break to stop the loop of loading firmware and
> release the patch request rather than return the function directly.
> 
> Fixes: 4a51b0e8a014 ("r8152: support PHY firmware for RTL8156 series")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8152: replace return with break for ram code speedup mode timeout
    https://git.kernel.org/netdev/net-next/c/f49c35b89b78

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


