Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE93AD24F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFRSmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhFRSmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C2216112D;
        Fri, 18 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624041605;
        bh=eCAEnZdaJrmWcPOoYUpoKZsiNV62kBoVhg/NUd2k0T8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7FPpz65+Jv3rc1EQXcZ/0SUsvoPy5klh+FcBGoHigiaRR7uiW9eFaTMb1/IosByP
         d3pk6sCOoc5dIKHF2p4tgCvdxqE8xlH+EwvpCXJxXwdt6hTvHH5ukH7h5s2Vem/STO
         UWl7WTM3MsMAF6RjhMzI/0yT8WG0leflPR4EuZLkktHviV0UDbSBQV0EDNCTHREFm2
         2D6jD9GQH9KMqzVGQv5+PC8HSfOK/MEjeaZvif5XXPLnRiiGSmBSYXZwQie+nluihP
         RIiB+wHhrM4zobr87DKRXL+51brADGW2HXkzlTEL/ck3uKLaY4fiPKmT1/k9lVuDkI
         7cS9VRxZZsj9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFE68609EA;
        Fri, 18 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Documentation: ACPI: DSD: fix some build
 warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404160497.23407.3314189255087613856.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:40:04 +0000
References: <20210617155552.1776011-1-ciorneiioana@gmail.com>
In-Reply-To: <20210617155552.1776011-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rjw@rjwysocki.net, calvin.johnson@oss.nxp.com,
        grant.likely@arm.com, lenb@kernel.org, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 18:55:50 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Fix some build warnings in the phy.rst documentation describing the MDIO
> bus and PHYs in ACPI.
> 
> Ioana Ciornei (2):
>   Documentation: ACPI: DSD: include phy.rst in the toctree
>   Documentation: ACPI: DSD: fix block code comments
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] Documentation: ACPI: DSD: include phy.rst in the toctree
    https://git.kernel.org/netdev/net-next/c/79ab2b37034b
  - [net-next,2/2] Documentation: ACPI: DSD: fix block code comments
    https://git.kernel.org/netdev/net-next/c/5a336f97f1f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


