Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78B7576B17
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiGPAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiGPAUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3DD4E851
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B87ECB82E4B
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 411B0C341C6;
        Sat, 16 Jul 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657930813;
        bh=wgBYvrm5xoq/tIIq+puX3+AjGMv7Vva20tAU6rbyTG8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EWdJLMq3+oTO3ecXXD/rBwTOvJakd5j5HiOegJ6LbYUVb3Anp6eBIiE8Pvj1lKJAK
         NoB/kEfMWo89p/ikEPTE865afvkDmpu9f05tynPi3IVvPUOMAXZbWMsVmEWvDE4ff3
         DMlaU4Gi6wezvltvGp3anqEyfRrY/I4JlGBNuG6MTBrxvXAwGmfDtgFHhUfRFo9FI7
         EoPrEVFHo163AQHovhZimElMIZZ0E6pkXDVDkwi0sRy2LQZJIyzVdlg5CDMJ8pmJKr
         TnFmUocaca2carX2nbaHMFgy4ytXF9RLdVJtZ81c2GkcSobTdC4kppz3Vbka/yxbka
         BogY246+3PbXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 211A9E4522F;
        Sat, 16 Jul 2022 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: microchip: ksz_common: Fix refcount leak bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165793081313.25022.5430979429745840689.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jul 2022 00:20:13 +0000
References: <20220714153138.375919-1-windhl@126.com>
In-Reply-To: <20220714153138.375919-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 14 Jul 2022 23:31:38 +0800 you wrote:
> In ksz_switch_register(), we should call of_node_put() for the
> reference returned by of_get_child_by_name() which has increased
> the refcount.
> 
> Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
> Signed-off-by: Liang He <windhl@126.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: microchip: ksz_common: Fix refcount leak bug
    https://git.kernel.org/netdev/net/c/a14bd7475452

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


