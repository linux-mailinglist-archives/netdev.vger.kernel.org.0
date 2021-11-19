Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7532F456E97
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhKSMDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234601AbhKSMDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A2C5761AF0;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323211;
        bh=FOyf4H5f/7liDt268z0Uq7AvU8bW1nPtefVp8BRgjQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MNhAWPVDeafEoGLEAM6JeQFgMmxw7q1pKtVscnL2sHEjou/voY4Zb8Fr2cZCII4T/
         QdR6DUgHJnYk+Pw9ro6V9IeZ2uzIqi2kyxPT9l0W2lGQg1gby2Z3pLcBpNK3YfsgNr
         kKuKKXziNLtfIJhVlSHykYDSREpVwzoMyDKD4K0V/pP4n4ACooGtVWnimIiEneK8Df
         ox7u227w2Ds/igbd8tzhFdKuIG09JcHCcFSRymbZnjMYa7gs8KcC53r0IEPq5ES81E
         3oF8cwVq1v2vJOTZv7c8BgaddnsDZhtHfHjSTtErWxAsLGSZDgRdmEQVIy5pQCDlmP
         0ujYRFcZmnX2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B48860A0F;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix double free issue on err path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321163.14736.8578198200279960716.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:11 +0000
References: <1637265100-24752-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1637265100-24752-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        ioana.ciornei@nxp.com, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        vmytnyk@marvell.com, tchornyi@marvell.com, davem@davemloft.net,
        kuba@kernel.org, vadym.kochan@plvision.eu,
        serhiy.boiko@plvision.eu, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 21:51:40 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> fix error path handling in prestera_bridge_port_join() that
> cases prestera driver to crash (see below).
> 
>  Trace:
>    Internal error: Oops: 96000044 [#1] SMP
>    Modules linked in: prestera_pci prestera uio_pdrv_genirq
>    CPU: 1 PID: 881 Comm: ip Not tainted 5.15.0 #1
>    pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>    pc : prestera_bridge_destroy+0x2c/0xb0 [prestera]
>    lr : prestera_bridge_port_join+0x2cc/0x350 [prestera]
>    sp : ffff800011a1b0f0
>    ...
>    x2 : ffff000109ca6c80 x1 : dead000000000100 x0 : dead000000000122
>     Call trace:
>    prestera_bridge_destroy+0x2c/0xb0 [prestera]
>    prestera_bridge_port_join+0x2cc/0x350 [prestera]
>    prestera_netdev_port_event.constprop.0+0x3c4/0x450 [prestera]
>    prestera_netdev_event_handler+0xf4/0x110 [prestera]
>    raw_notifier_call_chain+0x54/0x80
>    call_netdevice_notifiers_info+0x54/0xa0
>    __netdev_upper_dev_link+0x19c/0x380
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix double free issue on err path
    https://git.kernel.org/netdev/net/c/e8d032507cb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


