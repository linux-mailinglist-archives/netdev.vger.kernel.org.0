Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E968A80E
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjBDEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbjBDEAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D008F25E;
        Fri,  3 Feb 2023 20:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73138B82CDE;
        Sat,  4 Feb 2023 04:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15347C433A0;
        Sat,  4 Feb 2023 04:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675483222;
        bh=gyBg154DmWTXDHE6sWZ6ckQ5Zi7QUIMbaB7EYfuuyAw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LDJ1z+g91HpwfQtROJctnK7gvWhFOU6sMxY7bJyJdwTdldSbpNAjOsE0jjNDD8dCv
         Zx7Dq1Dcqj/kPSgDxnvhboKUJ0rzhIorV6zKbiZAMprHLqA5bysGGH1p0AKCUyHqYI
         /UrzSxgVinjgT0p0FwfLY8sTXdx2LD+B0ap5y9wi2S9xZBX2qrK05vUKgLaGX6A6jL
         g79Ew4XSSGECW7/JTxIYFULb//z/yQvBttX92slVo2/6k/jPgO+oRVLolYEW9DwyUt
         1jPdXkQ+SiEhxQGXMW7C3DNNrHSQif1BTuLZsfjzEHNKuSkeLIO7vjOhca6GNiNE4p
         dFE0BbYJ/iltA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAD54E4448D;
        Sat,  4 Feb 2023 04:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: Perform zynqmp dynamic configuration only for
 SGMII interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548322188.10981.1509367704209969692.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 04:00:21 +0000
References: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, git@amd.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Feb 2023 17:56:19 +0530 you wrote:
> In zynqmp platforms where firmware supports dynamic SGMII configuration
> but has other non-SGMII ethernet devices, it fails them with no packets
> received at the RX interface.
> 
> To fix this behaviour perform SGMII dynamic configuration only
> for the SGMII phy interface.
> 
> [...]

Here is the summary with links:
  - net: macb: Perform zynqmp dynamic configuration only for SGMII interface
    https://git.kernel.org/netdev/net/c/c9011b028e95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


