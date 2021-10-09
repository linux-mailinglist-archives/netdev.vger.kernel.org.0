Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ECF427A45
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhJIMwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232925AbhJIMwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C6F5660F9D;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633783807;
        bh=XEntNEKkidGvR4ZS/7TGI8VaGnrE2yP5M8CtrFsUnAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4iYsZi2CMSa4pWdp3Y+G3p0dUEjfRyZ6XMH+jkDptElDIsQp6X4gc2i8xsXARC3f
         9WcrNgPsb/FwB9zJsuIn5vXCVbGSOPA+a1dG8yyAUKKupPRGCJjLyy9l6GYzo+2MKQ
         9wdynSnuDYIqLo4PE6strw1spF8ZGN85ZPbL0YXllH5+oOEJm92i8iJRDjMzNZ26O+
         85kihRNHgxKG9lD33fkeH9L97Qo5c6p2aHTgVDFKvO4deI2gNOme/iDR5Z/mrbmXSP
         Me8UBOwAzAlhL0xLfFg+VPHbk0E+jp/ioMqqKdOnyJ4hKZpRE9MQ/0NQo/ITgQuncu
         uFkH5yvKxoKdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BBA7A60AA2;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: hold rtnl_lock in dsa_switch_setup_tag_protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163378380776.3217.15056215533350444464.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 12:50:07 +0000
References: <20211009122607.173140-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211009122607.173140-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tobias@waldekranz.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Oct 2021 15:26:07 +0300 you wrote:
> It was a documented fact that ds->ops->change_tag_protocol() offered
> rtnetlink mutex protection to the switch driver, since there was an
> ASSERT_RTNL right before the call in dsa_switch_change_tag_proto()
> (initiated from sysfs).
> 
> The blamed commit introduced another call path for
> ds->ops->change_tag_protocol() which does not hold the rtnl_mutex.
> This is:
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: hold rtnl_lock in dsa_switch_setup_tag_protocol
    https://git.kernel.org/netdev/net/c/1951b3f19cfe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


