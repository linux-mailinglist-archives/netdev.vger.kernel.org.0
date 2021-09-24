Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B287417578
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345281AbhIXNYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346063AbhIXNVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 970716124F;
        Fri, 24 Sep 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489608;
        bh=56znLhm2Eu6W0VdktjA89pY7++BwUbPQJ/zhVaJ6O6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sJ/nWK1Gt0RVBCj1srbjQwlrJK28x1LPuRPIRo5dZMNHUlaD+bTijQkDGqnD7n4LY
         UgCe0AMnaxdPElgP885ybrdz7yetYbYOPxlcdiDwpPVGIhZczHh/yCAY6amh5VJypP
         3Ozv36MqFnOXyy9Tm7Dqcv8L8bX729rNiIMzaeXVuaMeYVc5nBzVbvTdL9y+Pyo7kp
         XfClOmvTIf/2Fb+jnjCyqx7iNS6pBQAeXrKtrzeaurFMiuLCtsnLXQ4C0bMsGwYXkJ
         7BioNOGeVFVdZi3pY6k4vTr0dlZB5KHNVV5/FzViWjEV9f5L3WeITF84UZyYgGgcp+
         rWomgW7PqJSvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8DD9F60973;
        Fri, 24 Sep 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Batch of devlink related fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248960857.28971.5549585387092198522.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:20:08 +0000
References: <cover.1632420430.git.leonro@nvidia.com>
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        alobakin@pm.me, anirudh.venkataramanan@intel.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, irusskikh@marvell.com,
        intel-wired-lan@lists.osuosl.org, jejb@linux.ibm.com,
        jhasan@marvell.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, jiri@nvidia.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, michael.chan@broadcom.com,
        michal.kalderon@marvell.com, netdev@vger.kernel.org,
        sathya.perla@broadcom.com, skashyap@marvell.com,
        anthony.l.nguyen@intel.com, vasundhara-v.volam@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 23 Sep 2021 21:12:47 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> I'm asking to apply this batch of devlink fixes to net-next and not to
> net, because most if not all fixes are for old code or/and can be considered
> as cleanup.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] bnxt_en: Check devlink allocation and registration status
    https://git.kernel.org/netdev/net-next/c/e624c70e1131
  - [net-next,2/6] bnxt_en: Properly remove port parameter support
    https://git.kernel.org/netdev/net-next/c/61415c3db3d9
  - [net-next,3/6] devlink: Delete not used port parameters APIs
    https://git.kernel.org/netdev/net-next/c/42ded61aa75e
  - [net-next,4/6] devlink: Remove single line function obfuscations
    https://git.kernel.org/netdev/net-next/c/8ba024dfaf61
  - [net-next,5/6] ice: Delete always true check of PF pointer
    https://git.kernel.org/netdev/net-next/c/2ff04286a956
  - [net-next,6/6] qed: Don't ignore devlink allocation failures
    https://git.kernel.org/netdev/net-next/c/e6a54d6f2213

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


