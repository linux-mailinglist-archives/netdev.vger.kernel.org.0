Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26353195F1
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBKWkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229895AbhBKWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A52964E45;
        Thu, 11 Feb 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083208;
        bh=pr3FcFwfXX8h0np/PTmJ2QB0rRnCCEPljpp9g+1UNpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vPtrs/RvlcCVqr/Rwpa20xcn/YP9ZWevncGqhNm2b8Rgs9j0MNaajtL1Hh5CO9EDP
         jgHh4/ujYti/6QHe+QzSCFw1Ku++Knlku+W66wDEm/ONwvE/l1AWitVvdoKti2/a3S
         qADW19rTCFhsnggANZikKmM3f1Jq342Hdap/eMy7RNA/pvWzR9IY3oGvvI4a8cOR4T
         OYN/k5t9uAierr/OzGif7SuOChljObpC4WVxZnWxQ2s7M+qn4ScJ1XckP052ey4/ac
         oQ/3jJ1+vzxWD0PfCAE/HTn9kVI8b5WShq2EShtsiWpyOVk/SYuxZe3b413zfb5eWG
         7tyRzQ00CdDQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C9C4609D6;
        Thu, 11 Feb 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipconfig: avoid use-after-free in ic_close_devs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308320804.12386.4198662249809519897.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:40:08 +0000
References: <20210210235703.1882205-1-olteanv@gmail.com>
In-Reply-To: <20210210235703.1882205-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        yoshfuji@linux-ipv6.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 01:57:03 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Due to the fact that ic_dev->dev is kept open in ic_close_dev, I had
> thought that ic_dev will not be freed either. But that is not the case,
> but instead "everybody dies" when ipconfig cleans up, and just the
> net_device behind ic_dev->dev remains allocated but not ic_dev itself.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipconfig: avoid use-after-free in ic_close_devs
    https://git.kernel.org/netdev/net-next/c/f68cbaed67cb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


