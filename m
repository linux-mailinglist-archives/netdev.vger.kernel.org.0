Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12602436530
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhJUPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhJUPMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 11:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1041611C7;
        Thu, 21 Oct 2021 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634829007;
        bh=mmtf6+0UiSIEEP87RDWfN/cmNztF+130EEPUAoympvk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tfS2pAfQ2LON3nR3wOdZ4PIQOE/URgvD2XsOBsK5CObWIIvIE8NFtxyNBLw11qqGP
         Lqix98/7hDyzsQym18rolu7SwHEc13dm0QmsHwarumyonw3CR9elbx6QEGp2CbQUId
         KXd3p8EcCFrhWYq4gwznb0wTa4lSRzKktMEDgLEcNXqJgNJVmjy+R1alAOZxVeLSfY
         hscUKEHIioYEomvEkAS1QfuihYmbtQDfKvzpQSxdZT2KTbhZeQ8ehD6JxWji/jwpWQ
         QUejCbdF1FWiXKXi0A+uC3rF2pmNTOtOXib46iF5b1YX3FpHndG6tvCc/QYuuhVXV/
         n20wItyD4ynNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5C3D609E7;
        Thu, 21 Oct 2021 15:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: make sure all traffic classes can send large
 frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163482900780.14016.11295432266040521454.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 15:10:07 +0000
References: <20211020173340.1089992-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020173340.1089992-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        claudiu.manoil@nxp.com, richard.pearn@nxp.com,
        camelia.groza@nxp.com, po.liu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Oct 2021 20:33:40 +0300 you wrote:
> The enetc driver does not implement .ndo_change_mtu, instead it
> configures the MAC register field PTC{Traffic Class}MSDUR[MAXSDU]
> statically to a large value during probe time.
> 
> The driver used to configure only the max SDU for traffic class 0, and
> that was fine while the driver could only use traffic class 0. But with
> the introduction of mqprio, sending a large frame into any other TC than
> 0 is broken.
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: make sure all traffic classes can send large frames
    https://git.kernel.org/netdev/net/c/e378f4967c8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


