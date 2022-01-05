Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0D74855B2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241258AbiAEPUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241264AbiAEPUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:20:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D17C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 07:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EEC1B81C10
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 15:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 658DDC36AEF;
        Wed,  5 Jan 2022 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641396011;
        bh=KHtelWBWZY6nUL5AbvDV9gyJ3mLxt6pF89m9qBU6xy4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YEvo/osd79CQD4GyUkGgWLQZEvEaRfDS35O0eL+/5r8x4Gv/Ym47ABUOoZD7p96vc
         lE6/A2Dvcnau0DWWNbGQhVWJeZ0FLPa7EUcS1tQVZvdGMhASPspJpxngf0aXJgttjq
         VD0dFJqpgW0MO3nwjIhG5KLfuiF8xKOP1pxpG2z87+hWn0qeXamf+/kcN6zNQRFENK
         tP+7gb6Skq8IJqZTNo7oFnKEz3Lm9prmW8svnU/HZhcm1UxZYN5M79GrN/stiSh8AB
         hwDYKWsPv/vN0gDRckI91AhQckth1Lh7vATQk1YDIAZEYVOrxtA6le1ABAe0Bx3ljd
         tBrm/p5SQXv6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 549B2F79401;
        Wed,  5 Jan 2022 15:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] DSA cross-chip notifier cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164139601134.20548.12148564741177992692.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 15:20:11 +0000
References: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        horatiu.vultur@microchip.com, george.mccollister@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 15:18:10 +0200 you wrote:
> This series deletes the no-op cross-chip notifier support for MRP and
> HSR, features which were introduced relatively recently and did not get
> full review at the time. The new code is functionally equivalent, but
> simpler.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net: dsa: fix incorrect function pointer check for MRP ring roles
    https://git.kernel.org/netdev/net-next/c/ff91e1b68490
  - [v2,net-next,2/3] net: dsa: remove cross-chip support for MRP
    https://git.kernel.org/netdev/net-next/c/cad69019f2f8
  - [v2,net-next,3/3] net: dsa: remove cross-chip support for HSR
    https://git.kernel.org/netdev/net-next/c/a68dc7b938fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


