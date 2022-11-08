Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F74620CC4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiKHKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiKHKAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2F2A94C;
        Tue,  8 Nov 2022 02:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A98F614E6;
        Tue,  8 Nov 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 690ECC433D7;
        Tue,  8 Nov 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667901615;
        bh=WdDOo8U/DzkUPI7ETAKH9dAAWOmv1Yt9yMQjVaB2hKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ScWd4GHK5xQQHeHmqZPX9xcyvvj/QHWJwKfh98ICb5POEhhYcI3rL/bo1j7zV+Qvd
         EYI1o0FAT5OgZ7twGyC79mlgfhskXvwpO2NeWb5SqpZrcDzeE3QPKClfL5OhWjPgUH
         jyhkOVMukoey+64U6fYnsFBa8wM4FPGM1slG86C+5/rELi9SrDE56QbpzqLbd+5Lii
         zrHS2J1VAdjnFtejepZL6wRHGI4HnPBphdZ1ViuAc7SijfJrjzAR1BwkcNgnaNpHYa
         2OeXR9IVml9R15HUugbmFQOMedjniq2yO2kFuS4o2ke5Qa2vEXoFZacMjDpw5T5qe2
         Hq6EJvoqg+qXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C035C4166D;
        Tue,  8 Nov 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] ethtool: linkstate: add a statistic for PHY down
 events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166790161530.10635.9762046985462618583.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 10:00:15 +0000
References: <20221104190125.684910-1-kuba@kernel.org>
In-Reply-To: <20221104190125.684910-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, f.fainelli@gmail.com, michael.chan@broadcom.com,
        andrew@lunn.ch, corbet@lwn.net, hkallweit1@gmail.com,
        linux@armlinux.org.uk, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  4 Nov 2022 12:01:25 -0700 you wrote:
> The previous attempt to augment carrier_down (see Link)
> was not met with much enthusiasm so let's do the simple
> thing of exposing what some devices already maintain.
> Add a common ethtool statistic for link going down.
> Currently users have to maintain per-driver mapping
> to extract the right stat from the vendor-specific ethtool -S
> stats. carrier_down does not fit the bill because it counts
> a lot of software related false positives.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] ethtool: linkstate: add a statistic for PHY down events
    https://git.kernel.org/netdev/net-next/c/9a0f830f8026

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


