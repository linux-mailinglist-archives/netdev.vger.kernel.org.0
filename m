Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAB3E42A9
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhHIJac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234288AbhHIJab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:30:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 576F56101D;
        Mon,  9 Aug 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628501405;
        bh=nOXYxYQLW5zR6aM4Cmr6nujW0ijsZafmxUDF+RZWAMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=emzl5ThEFQTkQ+mmgehTGVj65FmnpQTe9RYyjHCPh361pv5kj2fz/z6Bhp3U2YGS+
         ZoItmmKoKrCxAgeySofsNiyn50bHWRA7+Y+bVQwqoAo0xznxfiUGb4YU9VvE+h4UXM
         AYow2Vmc0kokIgc1EzcfqKv8Ls8gzN0nfy33LHSCjLVNIjh9Zloc5r9/U6aMPdHffM
         CEmSZo+udGe8buqiIrrz8lDk/Cwf+fycgnr3l/BrSlz6sIBDDw1KgVCJVoJbLsTMh3
         qt6icx9m92+823p6zQ3pk/t1Go7K6qNuPTuKF0jqY6vNNbtDO4lWTqNShv4q4vBOLs
         jO7ubl68Mq09g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4346660A14;
        Mon,  9 Aug 2021 09:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Set device as early as possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850140527.16932.1083737685938240617.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 09:30:05 +0000
References: <6859503f7e3e6cd706bf01ef06f1cae8c0b0970b.1628449004.git.leonro@nvidia.com>
In-Reply-To: <6859503f7e3e6cd706bf01ef06f1cae8c0b0970b.1628449004.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch, aelior@marvell.com,
        luobin9@huawei.com, claudiu.manoil@nxp.com, coiby.xu@gmail.com,
        dchickles@marvell.com, drivers@pensando.io, fmanlunas@marvell.com,
        f.fainelli@gmail.com, gakula@marvell.com,
        gregkh@linuxfoundation.org, GR-everest-linux-l2@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, hkelam@marvell.com,
        idosch@nvidia.com, intel-wired-lan@lists.osuosl.org,
        ioana.ciornei@nxp.com, jerinj@marvell.com,
        jesse.brandeburg@intel.com, jiri@nvidia.com, lcherian@marvell.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-staging@lists.linux.dev, manishc@marvell.com,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, richardcochran@gmail.com,
        saeedm@nvidia.com, salil.mehta@huawei.com, sburla@marvell.com,
        snelson@pensando.io, simon.horman@corigine.com,
        sbhatta@marvell.com, sgoutham@marvell.com, tchornyi@marvell.com,
        tariqt@nvidia.com, anthony.l.nguyen@intel.com,
        UNGLinuxDriver@microchip.com, vkochan@marvell.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com,
        yisen.zhuang@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  8 Aug 2021 21:57:43 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> All kernel devlink implementations call to devlink_alloc() during
> initialization routine for specific device which is used later as
> a parent device for devlink_register().
> 
> Such late device assignment causes to the situation which requires us to
> call to device_register() before setting other parameters, but that call
> opens devlink to the world and makes accessible for the netlink users.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Set device as early as possible
    https://git.kernel.org/netdev/net-next/c/919d13a7e455

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


