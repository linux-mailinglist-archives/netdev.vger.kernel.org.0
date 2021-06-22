Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35383B0B73
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhFVRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhFVRcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F9DF61166;
        Tue, 22 Jun 2021 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383004;
        bh=DeTmtwcE3LOzdZOdLoegZVvpf5nno6n3rjTrpzIjNg8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m1r2k/Ao5S/YXkdhA9tnk0/+vnEVpPygYhVfhBzsODdlK2nR83McUoly3RGiSBtyg
         Mw6z7XYc7DmBRUo5oqlOAfnRfnk3GrPpAr3JbPym+rryNN5t5Nb+b0ttsLV5RaeCaq
         Tfz560Krmhh9+HjvUlII0S/8eBo0cyO3uxRcmtUZqGnji0MZuI3AIlk0ZmQ4EYyC7K
         fXJlqeJXk0wapvfKnaeMvlvE640x3kMNo0yNKRLmsrlr4i7FV06u4mYdxA8UJ4el7x
         O9/QIvrMp16RVqq1f0kt109s05JLj5pinhwkRJnoRg8YDAPl/GzdElGTIi7y9I6q4o
         x0CbqWSCiDLlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C28560ACA;
        Tue, 22 Jun 2021 17:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: b53: Create default VLAN entry
 explicitly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438300437.21657.10394005576786567703.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:30:04 +0000
References: <20210621221055.958628-1-f.fainelli@gmail.com>
In-Reply-To: <20210621221055.958628-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 15:10:55 -0700 you wrote:
> In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
> b53 driver to ensure that the default PVID VLAN entry will be configured
> with the appropriate untagged attribute towards the CPU port. We were
> implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
> instead make it explicit.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: b53: Create default VLAN entry explicitly
    https://git.kernel.org/netdev/net-next/c/64a81b24487f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


