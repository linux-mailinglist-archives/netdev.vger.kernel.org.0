Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9316C7B1A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjCXJUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjCXJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11AB1E1EE;
        Fri, 24 Mar 2023 02:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2719BB8234D;
        Fri, 24 Mar 2023 09:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5502C433A7;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649620;
        bh=RBW4NMqNqCl3kvxNuXwbe+ghhoJlv+ODi+c3IbU1lYE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qsoRh78HFE4WpZxS/n2mpfjAiDgy6Vm+NkqPmH8ilksDBO+xtbUON6KwpQ4rUTtYG
         AdtxaGp1N/IwEdOa8Y06xx1KsQnmnMsKkT5dpCofgu6fqi8FaL4fGFdrHZ/3seMu3Z
         8Dqgtow9e4ftqM9cbFrt/dSPUanAz/N13pjHBQOTCJCfwWgKW8oHlrdN2zXn7EK5J4
         AWRmx1AGnf/wKcmmjpIWvlSp9jKdFcgBTlsqPgvbR4wNsczNQKC0s0wY9LasI5o4NO
         CsVTvIJTgUy1DfFvMHKT5XR01vCFQGdIH7jmtCJkiK2/Jk5B+XNFhua8daNStk+rQA
         3wXp9AktLnaXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EFCBE55B3E;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: Improved PHY error reporting in state
 machine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964962064.21111.12041145794542616870.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:20:20 +0000
References: <20230323214559.3249977-1-f.fainelli@gmail.com>
In-Reply-To: <20230323214559.3249977-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 14:45:59 -0700 you wrote:
> When the PHY library calls phy_error() something bad has happened, and
> we halt the PHY state machine. Calling phy_error() from the main state
> machine however is not precise enough to know whether the issue is
> reading the link status or starting auto-negotiation.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: Improved PHY error reporting in state machine
    https://git.kernel.org/netdev/net-next/c/323fe43cf9ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


