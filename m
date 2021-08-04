Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37333DFD8D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhHDJAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhHDJAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A44260F56;
        Wed,  4 Aug 2021 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628067607;
        bh=a4bBwwAM8u8go6kxBPlTLDHRIFtqiAT/wuwlPa+6rI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YegsBcklbpmHi7aRcDaz3IR8SduTIBGGL/QK82v76P8xA9DKZFLoLZuUqvIkrXWUV
         wvPGR7+AWdEKRPrJAQlYmv+fL25kfH76Qs8BPwIb5x87GYxtH9rpIjKjBO380dx0EF
         kkPke5+CjySvokcWzKRXHtDagpwVxqRPwpQDNx7LUwhxUcBrIqdwCNjd8zbLbeahEK
         zm3uae/qS9wQkFVEnM0H1wG7PQPWr/bCPtZKPsiDHKLqJmaUigkYLv/HBGv/EBcLlb
         GCnuhlq2fu8cqjpFKJY5L7qbEzlwrk6XJsmKBRFK8BCsoevuqzxFcrDqaRTkGO8GQH
         BP/eJ6YoSD3uA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D32660A6A;
        Wed,  4 Aug 2021 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] dpaa2-switch: integrate the MAC endpoint support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162806760717.27431.27938602404910124.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:00:07 +0000
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 19:57:37 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set integrates the already available MAC support into the
> dpaa2-switch driver as well.
> 
> The first 4 patches are fixing up some minor problems or optimizing the
> code, while the remaining ones are actually integrating the dpaa2-mac
> support into the switch driver by calling the dpaa2_mac_* provided
> functions. While at it, we also export the MAC statistics in ethtool
> like we do for dpaa2-eth.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] dpaa2-switch: request all interrupts sources on the DPSW
    https://git.kernel.org/netdev/net-next/c/1ca6cf5ecbde
  - [net-next,2/8] dpaa2-switch: use the port index in the IRQ handler
    https://git.kernel.org/netdev/net-next/c/24ab724f8a46
  - [net-next,3/8] dpaa2-switch: do not enable the DPSW at probe time
    https://git.kernel.org/netdev/net-next/c/042ad90ca7ce
  - [net-next,4/8] dpaa2-switch: no need to check link state right after ndo_open
    https://git.kernel.org/netdev/net-next/c/2b24ffd83e39
  - [net-next,5/8] bus: fsl-mc: extend fsl_mc_get_endpoint() to pass interface ID
    https://git.kernel.org/netdev/net-next/c/27cfdadd687d
  - [net-next,6/8] dpaa2-switch: integrate the MAC endpoint support
    https://git.kernel.org/netdev/net-next/c/84cba72956fd
  - [net-next,7/8] dpaa2-switch: add a prefix to HW ethtool stats
    https://git.kernel.org/netdev/net-next/c/8581362d9c85
  - [net-next,8/8] dpaa2-switch: export MAC statistics in ethtool
    https://git.kernel.org/netdev/net-next/c/f0653a892097

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


