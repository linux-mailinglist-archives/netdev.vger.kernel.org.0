Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33DF287CB7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgJHUAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgJHUAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187205;
        bh=1WhE5EzPegLl39at06cilTCOFsyWTja12hZlDpWb/d4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ev69BPsUnGFThD4QuhjsMdaITkLXmaCxF1IF1nEtbtZ5WyP0MB4/DF23UujrfOZEb
         k2v9b6PnFSqsV+R6ZwBZswxvbCsO+YnCkhirg4GIo93a9y3C6Z7/rovZElPtaLdXEh
         fNDquAxg25EMer+Ql6/V8t3O+arZ7XN/drZBZbEE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bridge: Netlink interface fix.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720516.8125.842220080436586129.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:05 +0000
References: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     davem@davemloft.net, roopa@nvidia.com, nikolay@nvidia.com,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, horatiu.vultur@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Oct 2020 12:07:00 +0000 you wrote:
> This commit is correcting NETLINK br_fill_ifinfo() to be able to
> handle 'filter_mask' with multiple flags asserted.
> 
> Fixes: 36a8e8e265420 ("bridge: Extend br_fill_ifinfo to return MPR status")
> 
> Signed-off-by: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net] bridge: Netlink interface fix.
    https://git.kernel.org/netdev/net/c/b6c02ef54913

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


