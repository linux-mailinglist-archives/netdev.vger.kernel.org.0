Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94C05FF9A2
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJOKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJOKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEC32B19B;
        Sat, 15 Oct 2022 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E818B808BD;
        Sat, 15 Oct 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3331AC43143;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665829216;
        bh=FmXaLLKk0Lfa4F9XQZXzPNPYWe/8cexBMT8DjooMkiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dXfTr42e5+/diKFXVZYnFcu7KWxwnODkXQ2lPxxT0nO2e59ukZrlLRGApbsg88iEW
         oA+NJW8Ourzgfx/H+XbGLrVbH9kSzoxvu7usig4nlIGo7beYWHw/0zkDwFVefRIJ6d
         jqgDD7lr/AYJxtSbmbOm9ZqsxSPOmV6IYyIsAilywFb/YnAZKXxcNHQtqTvx8m3ocm
         0kOtcKROrWVkvFSrjWsBP2wZ8Ku2Nxexrlb3aAitU5yw5HtuYwRj5n6jKuHfrfwNf1
         CT1f0EakGSHeQBOYXB4jtxjEfY4IJX2iC/51UX1lNEI93wlttNuS3evLKTZ6Da+teM
         /Vfs0tSyKsSvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14340E50D94;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: dp83867: Extend RX strap quirk for SGMII mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582921607.1299.16882732811766875807.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:20:16 +0000
References: <20221014064735.18928-1-harini.katakam@amd.com>
In-Reply-To: <20221014064735.18928-1-harini.katakam@amd.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Oct 2022 12:17:35 +0530 you wrote:
> When RX strap in HW is not set to MODE 3 or 4, bit 7 and 8 in CF4
> register should be set. The former is already handled in
> dp83867_config_init; add the latter in SGMII specific initialization.
> 
> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: dp83867: Extend RX strap quirk for SGMII mode
    https://git.kernel.org/netdev/net/c/0c9efbd5c50c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


