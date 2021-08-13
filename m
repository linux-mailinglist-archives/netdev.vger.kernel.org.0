Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55A13EBDBD
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhHMVKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234832AbhHMVKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 17:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1579360041;
        Fri, 13 Aug 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628889006;
        bh=46AxkmygV+YPAy2VgpvxLVfCCD/ckAgJB0lLebJq/mE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cdXd/Ihe0hWv+AGOau4S8kF7YMg7eP+ekuQn4LwtQRJDCxvO13EsureXvaNpIKr3e
         tFd/iI1fHJANIdPlknZMyPTH+/u61i2Wncgg5hwhpmkhvVkzSJSmXAtOQUMQOyQRfy
         mwMc4WOvpuYqP0vE+BBpfqvyRvEgXzGmeHaX3x41DQQHbtx5ceJnqXCW/wml2XCTBZ
         yAePOiQP5Kxx04QSFoPP1USfP3YgbuNLSdGHo7rTPrZ8kemM1JAiR+vIYBzF4H/OF+
         wJ5NtCFdkMt5gcFc1pnpLyMGqjKOBpmrs/RZ2AtWQTU+UVepM0agYX152v4w1s8+QR
         ktFPXmIfolpdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08AC860A9C;
        Fri, 13 Aug 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net, bonding: Disallow vlan+srcmac with XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162888900603.14089.2634132052256203051.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Aug 2021 21:10:06 +0000
References: <20210812145241.12449-1-joamaki@gmail.com>
In-Reply-To: <20210812145241.12449-1-joamaki@gmail.com>
To:     Jussi Maki <joamaki@gmail.com>
Cc:     netdev@vger.kernel.org, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 14:52:41 +0000 you wrote:
> The new vlan+srcmac xmit policy is not implementable with XDP since
> in many cases the 802.1Q payload is not present in the packet. This
> can be for example due to hardware offload or in the case of veth
> due to use of skbuffs internally.
> 
> This also fixes the NULL deref with the vlan+srcmac xmit policy
> reported by Jonathan Toppins by additionally checking the skb
> pointer.
> 
> [...]

Here is the summary with links:
  - [net-next] net, bonding: Disallow vlan+srcmac with XDP
    https://git.kernel.org/netdev/net-next/c/39a0876d595b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


