Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8C3B0C29
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhFVSDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232825AbhFVSCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1558161380;
        Tue, 22 Jun 2021 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384805;
        bh=rY/ocNpM27DNxceu48dN0njbx+duu6uaqHeC8YZ3KfU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ymum6/UBkY2ybVtKDNPJNaT3lQZ7WmuQKyGqb9R/HCYlh7YvMLdUpZXt82PeOX4Zd
         LZZm45f1G2Nx4mpo0Sf9Vj3H5U2sh2AzGn+9w8p9VzVqZ8ZJLSANti4zePR9R/qFX5
         tHUSFiXKwwO8HRy6Skh4M8lYcZfZF9I0cObfW16Scy5VCeFenpRNWp5ZnpSjxYbYtH
         EK4RSE273HMzyizmEuSuvX7qwaVKrDUBrBcMxPoYu9lejeZ2+MhkSZMzx8WHTPjGz/
         AOm7rdCpshMApDLALc6mF8jVMNTPnSOWCXUDeFEo9extzRjt2chCnbY8t4ST0lD6BT
         y6v+YEjsHaGuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0690760A02;
        Tue, 22 Jun 2021 18:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: marvell: return csum computation result from
 mvneta_rx_csum/mvpp2_rx_csum
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438480502.5394.9748261616363230334.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 18:00:05 +0000
References: <18fb6f42dac5a2ab7b121c83659e0109043b9f8c.1624381975.git.lorenzo@kernel.org>
In-Reply-To: <18fb6f42dac5a2ab7b121c83659e0109043b9f8c.1624381975.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, mcroce@linux.microsoft.com,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com, stefanc@marvell.com, brouer@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        mw@semihalf.com, lorenzo.bianconi@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 19:18:31 +0200 you wrote:
> This is a preliminary patch to add hw csum hint support to
> mvneta/mvpp2 xdp implementation
> 
> Tested-by: Matteo Croce <mcroce@linux.microsoft.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rebase on top of net-next
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: marvell: return csum computation result from mvneta_rx_csum/mvpp2_rx_csum
    https://git.kernel.org/netdev/net-next/c/aff0824dc4d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


