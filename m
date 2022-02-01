Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317DF4A5702
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiBAFkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:40:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiBAFkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AE98B82D01;
        Tue,  1 Feb 2022 05:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17163C340ED;
        Tue,  1 Feb 2022 05:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643694009;
        bh=cKgANmfRqUVDRsLCwiVgrvW3MMj+qISr3GTtMm+Kms8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dSrQK3Ubsl0KWeRTSj3Vex7eXRTMNziQtmI1TTuOBZ/0A6KKdhIFhjzm5X1EyU5nA
         lYwbAQ4qsEBUhgtEAOBpGgMK8wo81RvhrVRfzsu4S+c9Iob7arqs3IxgqaVZ5ujiUt
         p3LRTsMlucUcjSVkOSNS8faoDu+jdHGEH9HJ1UTNU5wM7u3ZF4+hZPFlJnF2uFOw/J
         kRo9xt0fcY8rAZ8XTsnmaIYHWlsvqy4P3mK7PwA99TDInh7E7kttfX15hlv97iYEXb
         xBTT7E3m3GpgiTm4R0Ezdf0zzroQjTxoMn3vxr/fQpWsfyEPFyyNWOv/unNBMOIuEf
         g/nXhBqA0x8Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F16C6E6BAC6;
        Tue,  1 Feb 2022 05:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: macsec: Fix offload support for NETDEV_UNREGISTER
 event
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164369400898.8547.951399722195264606.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 05:40:08 +0000
References: <1643542141-28956-1-git-send-email-raeds@nvidia.com>
In-Reply-To: <1643542141-28956-1-git-send-email-raeds@nvidia.com>
To:     Raed Salem <raeds@nvidia.com>
Cc:     atenart@kernel.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liorna@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 30 Jan 2022 13:29:01 +0200 you wrote:
> From: Lior Nahmanson <liorna@nvidia.com>
> 
> Current macsec netdev notify handler handles NETDEV_UNREGISTER event by
> releasing relevant SW resources only, this causes resources leak in case
> of macsec HW offload, as the underlay driver was not notified to clean
> it's macsec offload resources.
> 
> [...]

Here is the summary with links:
  - [net] net: macsec: Fix offload support for NETDEV_UNREGISTER event
    https://git.kernel.org/netdev/net/c/9cef24c8b76c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


