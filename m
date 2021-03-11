Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CE336847
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhCKAAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCKAAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:00:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9012A64FCA;
        Thu, 11 Mar 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615420808;
        bh=1aoIbQMbDKhRtG+wyxONAPZvcdOmf/K+Dj4rhW5H9gE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NOdPAW7ft2qHXViEKMysTl8CDEaLADjq8fYs5XKGBXVjjlDCGhBiCzRJqTW6va5Si
         HgUs7H+DIkGlVFqq0S+M5DYfnOTqXiQIaO+oHyoxlYGuv1hS0lJyzjM3u26oVM64sx
         USdh2hB6pxbYS9pQkgI++ml4QSoEUCF8SfUvFbNZs4rRMprpLGgZR1Kum5zz5OKqsu
         8nWIpc24E7iPuYnSHcuJBpSjaDQEuCjOMrItuLhtqRmlpPxXT7EbC8YK+tcQXjx0rI
         SkXMjfoWNppCJG7Si1JCDSbA+eREgRpQK2dJnRJFxZ4OKoeUxo1WzZKdH9zOfWJIHr
         ljJoFW3ULAxjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8044A609D0;
        Thu, 11 Mar 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: b53: VLAN filtering is global to all users
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161542080852.19331.3067516552691002345.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Mar 2021 00:00:08 +0000
References: <20210310184610.2683648-1-f.fainelli@gmail.com>
In-Reply-To: <20210310184610.2683648-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 10:46:10 -0800 you wrote:
> The bcm_sf2 driver uses the b53 driver as a library but does not make
> usre of the b53_setup() function, this made it fail to inherit the
> vlan_filtering_is_global attribute. Fix this by moving the assignment to
> b53_switch_alloc() which is used by bcm_sf2.
> 
> Fixes: 7228b23e68f7 ("net: dsa: b53: Let DSA handle mismatched VLAN filtering settings")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: b53: VLAN filtering is global to all users
    https://git.kernel.org/netdev/net/c/d45c36bafb94

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


