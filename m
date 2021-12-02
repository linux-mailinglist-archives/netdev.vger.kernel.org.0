Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB561465C9D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355162AbhLBDXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:23:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38326 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355151AbhLBDXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA13B8220F
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58CB7C53FD4;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415211;
        bh=UmROIwDZ/VAIn6YHgas9gBONwg7eugVb1J9lF90vYt0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ksjGL1idAm1GxtTkIMCINnJLQ/hSSgpjRRPUyf1W3J0USdjgYp/L5uqM+PRIZRBzh
         yIpIMb5cjFEITK5ea28tJ9Vo4Iou/TBZ4DHHhy3I2XgJC2FRwwG0fXEyDld0fuNzcz
         SXRZDxZOOSyVsofKuCo13rspdeIykOVmPUL7uibD/H3bUZowgsXW4fSVUDHZ43+kzT
         7kXn/id/cs5nJkaYpaWrJc4nnX/+s2EQxQeJl27VJ7eHW7Td7x8vT0gWyqtUEj4ECR
         217cJurNmfSJ6rhF2hMgSmXUuRX0Vg0ZW+81l3woE2q05eYiCd/QIruXMScXV7RjAZ
         50QcHO5+ysotw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D8E260A4D;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: dsa: convert two drivers to
 phylink_generic_validate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841521124.978.17179788830079883683.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:20:11 +0000
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
In-Reply-To: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, hauke@hauke-m.de, kuba@kernel.org,
        kurt@linutronix.de, vivien.didelot@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 13:09:29 +0000 you wrote:
> Hi,
> 
> The following series comes from the RFC series posted last Thursday
> adding support for phylink_generic_validate() to DSA.
> 
> Patches 1 to 3 update core DSA code to allow drivers to be converted,
> and patches 4 and 5 convert hellcreek and lantiq to use this (both of
> which received reviewed-by from their maintainers.) As the rest have
> yet to be reviewed by their maintainers, they are not included here.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: dsa: consolidate phylink creation
    https://git.kernel.org/netdev/net-next/c/21bd64bd717d
  - [net-next,2/5] net: dsa: replace phylink_get_interfaces() with phylink_get_caps()
    https://git.kernel.org/netdev/net-next/c/072eea6c22b2
  - [net-next,3/5] net: dsa: support use of phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/5938bce4b6e2
  - [net-next,4/5] net: dsa: hellcreek: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/1c9e7fd2a579
  - [net-next,5/5] net: dsa: lantiq: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/a2279b08c7f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


