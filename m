Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7443FEDE5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344649AbhIBMlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234098AbhIBMlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 08:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 57960610CF;
        Thu,  2 Sep 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630586406;
        bh=+OpYzx6I7O/9fEue2A9AlFW7q6f827URkvrW4Yp64lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7GVRpjfdC2kymLiaN783//8/50ZXX/itUvE8KBQLE3/qGVcifFdKChJnvV2FFIcb
         kJABSyI6sFQZwi9daRnY1E3mZo6L518TZzCaQ7jVY7ik9MS0kKGz3O8S22iPblh0KY
         AxugYDRxslEx9Ya+h3BRGsdoShk6FUcZ7aFzHPv0JtBbOFLBvlNs/u7hxv+u1b8XR3
         zJuncVQRyhOjfV1N6LPEMPoEJF1Tu5R9RcQn5TeYGCuDmZGucVetLjNRFuQ8gBOiKD
         ix+3z7UtnIKwALKB4zt8KiQvpUHjBZNeIyFoGmliCxkhqwgwkOzjysqpmKXjieQUSi
         1yJoFgdMsM4sQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A8E060A17;
        Thu,  2 Sep 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net 1/2] net: dsa: b53: Fix calculating number of switch
 ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163058640629.7347.7280659235460607833.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 12:40:06 +0000
References: <20210902083051.18206-1-zajec5@gmail.com>
In-Reply-To: <20210902083051.18206-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 10:30:50 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It isn't true that CPU port is always the last one. Switches BCM5301x
> have 9 ports (port 6 being inactive) and they use port 5 as CPU by
> default (depending on design some other may be CPU ports too).
> 
> A more reliable way of determining number of ports is to check for the
> last set bit in the "enabled_ports" bitfield.
> 
> [...]

Here is the summary with links:
  - [V2,net,1/2] net: dsa: b53: Fix calculating number of switch ports
    https://git.kernel.org/netdev/net/c/cdb067d31c0f
  - [V2,net,2/2] net: dsa: b53: Set correct number of ports in the DSA struct
    https://git.kernel.org/netdev/net/c/d12e1c464988

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


