Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66B5337F2A
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhCKUka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhCKUkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7676B64F11;
        Thu, 11 Mar 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495207;
        bh=Fb7uX8FaxmhRNZnflxA6/NzCs4IVy8G1PrCnsyP131I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jtXa8Xfzm1rV7+amnClKu45QLHp2z9cMu1ULoc16Ku6VhMJjFmMFSlqhCp8JYpaCX
         kTcCIEqgbTIc2NX4ARtsZB2S2Iru08XE9ffFDdTml+IRmn0CjF7O55lugnEfT0ut4E
         XQb6rJq8nk/AkW0BYVo1BRt5GWWUjuyks02tM/bKPXioUHsPR0nWxcKvPomKLgjZb3
         C3puTI8Rm3j4nar3Un6qjiri+8q4AffGlsLQNcDP9Ye1YLJxUEQP6BPssLuXpRu9w7
         ZozP4ZA3bIwFqEcOCkT6dUXY4tKF8kff8A/KyAanIIg6u+fk0xTg8VqMQEtqih86xH
         8FcwwnMSdYbnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BC8A609CD;
        Thu, 11 Mar 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: b53: Add debug prints in b53_vlan_enable()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161549520743.24384.15476539431801623264.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Mar 2021 20:40:07 +0000
References: <20210310185227.2685058-1-f.fainelli@gmail.com>
In-Reply-To: <20210310185227.2685058-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 10:52:26 -0800 you wrote:
> Having dynamic debug prints in b53_vlan_enable() has been helpful to
> uncover a recent but update the function to indicate the port being
> configured (or -1 for initial setup) and include the global VLAN enabled
> and VLAN filtering enable status.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: b53: Add debug prints in b53_vlan_enable()
    https://git.kernel.org/netdev/net-next/c/ee47ed08d75e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


