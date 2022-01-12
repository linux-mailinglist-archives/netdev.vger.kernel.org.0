Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAAB48C5D9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242015AbiALOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:20:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50772 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241947AbiALOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:20:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E80996155E
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B0A4C36AEB;
        Wed, 12 Jan 2022 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641997208;
        bh=EegoJE8CL6QO/eCbQ63v7Ux/iVOP+EuGdgSajfsCywE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rRqFov8UPoi/CB2dp//t8DwYHmHcp5RX29Nix24yrENGDRNp768t8Zz9ulNejfkdT
         9UQI0UE25cEGQxds2Jhhse59KdgiQREsUqdEbdkMoa5iaIuaUWOr8MG0zRHU4X98aT
         XlywhjFaVxR/a006D0g5jWGmbsB09npoGuei5H+suEbquLyVVIeoZ9mUSi4zjxoG9Y
         a8PDNuPZsD9QcuxJ3rgSjUlHLyL8/INHoViLwknh/iaaE0llkkG5PxgHHDWCpP2STm
         Pm4lYBb6CxPjD2ETTmaOnckptEdSBgfSFfSsn6NdgHMxpT+SzrPACG6DLSKjXvcfxL
         6TawQLt2LY0eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E355F60796;
        Wed, 12 Jan 2022 14:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix sock_timestamping_bind_phc() to release device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199720818.30844.12070988737433815809.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:20:08 +0000
References: <20220111151053.4112161-1-mlichvar@redhat.com>
In-Reply-To: <20220111151053.4112161-1-mlichvar@redhat.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Jan 2022 16:10:53 +0100 you wrote:
> Don't forget to release the device in sock_timestamping_bind_phc() after
> it was used to get the vclock indices.
> 
> Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
> Cc: Yangbo Lu <yangbo.lu@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: fix sock_timestamping_bind_phc() to release device
    https://git.kernel.org/netdev/net/c/2a4d75bfe412

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


