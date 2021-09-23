Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACC1415D0D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240683AbhIWLvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240695AbhIWLvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94EFE610D1;
        Thu, 23 Sep 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632397807;
        bh=RpnHpV71WO9Ths/0MPsFyIRLFMJMKsR1hMRR3Saaw1g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DhmPvLT5ncAruFU2fQt93Ggw4BSFqr8gMIJ+dO/QcTZ4ywnlWvq/OC2dweGDiF25R
         ebz801U8lyaQNKyyHNy30YJn2mIKIliuLRD2hgpa65AzPESdZaX2OQzxrDLjW3dFBR
         inLT/BXZ6k5ZwTmqiHb2MPSZZFt/pyz3lK1l8SRbZSpd0sxE735LsY0vP4r/hJS8Rm
         IKX1Ts+2+bSACRSSs5IGLO18aaVkVc0+1MScm6qHRCRP70pjWv1G2BAn3oT2DfIGja
         IP7Jg/L6IcTcWF4NfKirXj8hY7qi1KpPHQUDGxizrZw1AU35r+YVI6EXDBslRxW8ix
         v8a2XucPMTE2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88BF160A88;
        Thu, 23 Sep 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix circular dependency between sja1105 and
 tag_sja1105
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239780755.29089.16121838570087217495.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 11:50:07 +0000
References: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 17:37:24 +0300 you wrote:
> As discussed here:
> https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
> DSA tagging protocols cannot use symbols exported by switch drivers.
> 
> Eliminate the two instances of that from tag_sja1105, and that allows us
> to have a working setup with modules again.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver
    https://git.kernel.org/netdev/net-next/c/6d709cadfde6
  - [net,2/2] net: dsa: sja1105: break dependency between dsa_port_is_sja1105 and switch driver
    https://git.kernel.org/netdev/net-next/c/f5aef4241592

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


