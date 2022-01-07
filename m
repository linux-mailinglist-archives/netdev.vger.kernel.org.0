Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F4A4878CC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbiAGOUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:20:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34030 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiAGOUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 09:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5F7EB82631;
        Fri,  7 Jan 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 601D6C36AE5;
        Fri,  7 Jan 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641565210;
        bh=2EOzG7oNFW/lw0SW/jsqf0o8yZgPDhMEI/bsIL/aFi4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PjIPfavU1YO/VWl4tZBgZRo2cFIL2w/wwzYWxk2Qos+kbOvB8I+aAkjQEdEBHI+re
         WLHuAAiddq7+A0q+aCGJ87x8b4GUcm7QdtqIbrUKIbk8f7Y5wB8YuHwiERH15z5OxD
         Q3Xhhiy+BYUB5031P0Dwvi5G0YB86o6+xtz2l+2mN5eboNbjTuZ8GALwiCH17BVRoG
         9Onnu5HLotbLA3b8x++h9tu+2n9X5X2+w1SnSV2TEfMneODsekgNyuhI+iRqsfFKmO
         M6FbnQsc92YLkA/DIaHTMjvbe1pyuY7voP8a2O+/Q2iruNu90QHcHGZjAv0paT4xvt
         /ocNj6IU3ut6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B9D2F79405;
        Fri,  7 Jan 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netrom: fix api breakage in nr_setsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164156521023.21832.17160553680833983322.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 14:20:10 +0000
References: <20220107071209.GA22086@kili>
In-Reply-To: <20220107071209.GA22086@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 7 Jan 2022 10:12:10 +0300 you wrote:
> This needs to copy an unsigned int from user space instead of a long to
> avoid breaking user space with an API change.
> 
> I have updated all the integer overflow checks from ULONG to UINT as
> well.  This is a slight API change but I do not expect it to affect
> anything in real life.
> 
> [...]

Here is the summary with links:
  - [net] netrom: fix api breakage in nr_setsockopt()
    https://git.kernel.org/netdev/net/c/dc35616e6c29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


