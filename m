Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B449FC7E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349537AbiA1PKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349497AbiA1PKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25AFC061714;
        Fri, 28 Jan 2022 07:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 724EEB82612;
        Fri, 28 Jan 2022 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F8B6C340ED;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=eyQAM67FsSZHQiJBDUuNeexQAmyfsc/8NviVlGkgpR0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BRm5puGPmuMSV9UpiSABKMQDYHOMHXivE96XrDeB+0Drkiohhv6XDCY3YHnNBDkSB
         Uiwnl5D+yAFO1129LUmzONWxX1nsQ36sVcLBIc7f+IadFRQneS05n5ggSVKPbK7Lqd
         fMRG/drMGVfw0eLSA0LSToNgMMpcSHD1zcDPjJneprHRTVhss/Z8Ra7ia5JLpRQg3j
         rbtImV+Qahsv+No0SDhgpCVjAK2bQx5i6+pVXbCJbaq7TNv8mV5q8dVOvoXgb/bpnT
         zqPWC53TUhnok25KX24f6IzA64hhQKeBjs4NPyqGM9ljhj47VIt8OOdLYLjD5kVDhx
         UK+JNdQtoEHcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B193E5D098;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] Allow disabling KSZ switch refclock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261717.2420.10520370094882219716.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <20220127164156.3677856-1-robert.hancock@calian.com>
In-Reply-To: <20220127164156.3677856-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        marex@denx.de, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 10:41:54 -0600 you wrote:
> The reference clock output from the KSZ9477 and related Microchip
> switch devices is not required on all board designs. Add a device
> tree property to disable it for power and EMI reasons.
> 
> Changes since v3:
> -rework some code for simplicity
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] net: dsa: microchip: Document property to disable reference clock
    https://git.kernel.org/netdev/net-next/c/eccfecfe587b
  - [net-next,v4,2/2] net: dsa: microchip: Add property to disable reference clock
    https://git.kernel.org/netdev/net-next/c/48bf8b8a04c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


