Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6512E47D97A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 00:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbhLVXAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 18:00:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36878 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhLVXAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 18:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6228161D2B;
        Wed, 22 Dec 2021 23:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C84D9C36AEA;
        Wed, 22 Dec 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640214009;
        bh=fsbeqIQby44+pz9kwSDauv8++5lsi9zHv8TQzkvhQi4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dTfZRsG/enyjLR2Lb07ucRiOs28Eug+lwciZBpEZxgJufVJqoZXUDyj0X3/3eTYco
         ClQQ091ypkrEFzGa91NAB249d2juoiCIffw61aIihS9BxVQqp2209KI2P90tYHE+Of
         ei8O200q5c+NW808sZI4nwubN9Tj5hQxf6am4JVjantU+04ASP7VdWjqPDgsVITpxk
         i/pjwYpIhnRRR/nSKZdeOgFQZHSFOs4Bv3oG+QiH99HeqIqB/PWJqwuoBeUfwmwr6b
         /veCgbFahLVPoojOg6QDuz+txJWBCw1Hje+bbiLFmdJxy0oEAfrDKiajyiYDcgz6TM
         hBNYnki7iVxPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFD76FE55BC;
        Wed, 22 Dec 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] asix: fix uninit-value in asix_mdio_read()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164021400971.685.16899015623032122973.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 23:00:09 +0000
References: <8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com>
In-Reply-To: <8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, robert.foss@collabora.com, freddy@asix.com.tw,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Dec 2021 23:10:36 +0300 you wrote:
> asix_read_cmd() may read less than sizeof(smsr) bytes and in this case
> smsr will be uninitialized.
> 
> Fail log:
> BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
> BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
> BUG: KMSAN: uninit-value in asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
>  asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
>  asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
>  asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
> 
> [...]

Here is the summary with links:
  - [v2,1/2] asix: fix uninit-value in asix_mdio_read()
    https://git.kernel.org/netdev/net/c/8035b1a2a37a
  - [v2,2/2] asix: fix wrong return value in asix_check_host_enable()
    https://git.kernel.org/netdev/net/c/d1652b70d07c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


