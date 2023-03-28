Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0726CC12A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjC1NkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjC1NkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE38C15F;
        Tue, 28 Mar 2023 06:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC04617C4;
        Tue, 28 Mar 2023 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F98BC4339C;
        Tue, 28 Mar 2023 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680010819;
        bh=W7CkkhoADbYkEkKnj7YOIqkOzfALUfXLdWDJ3FNHACk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vAIj4zxRXrZtECoGB2XymFVbmwQL6H3bVBJxiOjmMNGrPM0cinsV5i5yEk5enV4lM
         YPPb/fZg/IXKU6CFNWeAHJWD2TjW1GrtC4EWrKS5xgWlVD17Rap3A9WcqkQiIUJc8W
         srYqZhFDr4AEsiNGDdDikuYBLS/WISrC5sJfuSP6VgB7RLUS22VMTDuABob7CtT1ki
         C6En1XVBVYQnqNwLARYoboPYz37VrE8LSYnzFlfmc8Ju5TC7J6sQIWsM6vexb+5cdq
         1eTH86Mo3eFFYbGixKsDO46SbvMhtajfruTYK/3fCSyK7Oqk+aHm4Jpw7pyhGLOq8U
         liRyc2GIsd3pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86E55E4D01A;
        Tue, 28 Mar 2023 13:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: enable p0 host port
 rx_vlan_remap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168001081954.18925.1181894423003592285.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 13:40:19 +0000
References: <20230327092103.3256118-1-s-vadapalli@ti.com>
In-Reply-To: <20230327092103.3256118-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Mar 2023 14:51:03 +0530 you wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> By default, the tagged ingress packets to the switch from the host port
> P0 get internal switch priority assigned equal to the DMA CPPI channel
> number they came from, unless CPSW_P0_CONTROL_REG.RX_REMAP_VLAN is enabled.
> This causes issues with applying QoS policies and mapping packets on
> external port fifos, because the default configuration is vlan_aware and
> DMA CPPI channels are shared between all external ports.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpsw: enable p0 host port rx_vlan_remap
    https://git.kernel.org/netdev/net-next/c/86e2eca4dded

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


