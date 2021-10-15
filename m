Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D98C42E671
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhJOCWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234916AbhJOCWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7CF27611C5;
        Fri, 15 Oct 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634264408;
        bh=b2YWYnX8GWRUKpZxlz8wnpn7Xww38QzbvH0+vAfI4ZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dpVjIkzFWQDpb1qA7EvUI/8hi3vMlkFG+bmXZ047nmXgKar83/KTf9hOdlGbmmCRg
         BeSnMXvBv+LHxmR8m/Ad3N7+mqDr8rrPtkGCi86+eQLL/4h6EJBwA6jTBRm4sP9BIz
         pe0wOkE46qIUBrI8+yV16FCa926M78SQJ3ar5xGREZLMQWvMja/p8+mLVb/3QyDo/B
         IVnhuGEkJaWY+l3f1q5JnW9ZqwPm0ybc/7B/zlkfy7D1tMfmT5+kGe9u/5f80YVATU
         2bwWM9qB18MAgyqtc0/qGp6UtkmTuKXNehbeWnbs0OrsYHQ2Q99/8djIL1agQFzcZU
         NPZoVpvejS/LQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D44F60A44;
        Fri, 15 Oct 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/1] net: phy: dp83867 non-OF and loopback support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426440844.28081.1680625638862173370.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:20:08 +0000
References: <20211013065941.2124858-1-boon.leong.ong@intel.com>
In-Reply-To: <20211013065941.2124858-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuan.loon.lay@intel.com,
        vee.khee.wong@linux.intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 14:59:40 +0800 you wrote:
> Changes in v2:
> 
>  * drop "net: phy: dp83867: add generic PHY loopback" patch as not relevant.
>    Thanks Vee Khee for pointing out.
>  * Fix dictionary spell check error detected and length issue detected.
> 
> Thanks
> Boon Leong
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: phy: dp83867: introduce critical chip default init for non-of platform
    https://git.kernel.org/netdev/net-next/c/4dc08dcc9f6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


