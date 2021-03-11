Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4038A337F42
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhCKUuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbhCKUuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:50:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7F98064F70;
        Thu, 11 Mar 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495807;
        bh=qdxq+QFcE22MM1+ncIpEYzPJgyO6UNUjpdVKVzVQ6QE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YE4yKREm54kc6NDrbZ6/rrzlPNNQ5IRuXeWOWK5fM+h+duq14BLIPVw49sUy88iey
         WdrgnpkEcXJLGQ6/ZM8TOQpEOEt4NcPcX3/jTE34bUIHK8GfitIGWAmxR5rWT+61Kv
         hFwYLHP4yTqAMM9s6gJvqkqDsYtjiu0yRSUhr0I0EJVHG8yVdlC5UNFLfkyT+RobtB
         eFj9GhKhZ9YkUyYvrUdJQHbVfVyPUto2rrIUkObZW1475mVciQWDWoE7OcwUIpT6bs
         uPeQyB99QyeBHWcRdGYX9sATpfaiEXencO4gV//IS9uOO6bCFLyg1yyZyoJdRURPzf
         IyMgML6lMjkEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6662E609E7;
        Thu, 11 Mar 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: Expose phydev::dev_flags through sysfs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161549580741.28163.16121543913244829470.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Mar 2021 20:50:07 +0000
References: <20210310221244.2968469-1-f.fainelli@gmail.com>
In-Reply-To: <20210310221244.2968469-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 14:12:43 -0800 you wrote:
> phydev::dev_flags contains a bitmask of configuration bits requested by
> the consumer of a PHY device (Ethernet MAC or switch) towards the PHY
> driver. Since these flags are often used for requesting LED or other
> type of configuration being able to quickly audit them without
> instrumenting the kernel is useful.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: Expose phydev::dev_flags through sysfs
    https://git.kernel.org/netdev/net-next/c/b0bade515d36

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


