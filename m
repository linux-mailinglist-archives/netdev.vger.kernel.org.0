Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8194254B2CA
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbiFNOKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiFNOKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AEC3205E
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 07:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E33F161751
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B089C3411D;
        Tue, 14 Jun 2022 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655215815;
        bh=CMAJfJBq7T2T0ktPcvnb2IokxooJWBY3crbTezGNEsA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=msQQoGIpEAR/jsbM/xlDdsE2ASFLjKZ7GnvRGB2jaavpfmpQjuhNJfx+tLOrbCKKP
         0k7uxWkpXCaEDq/FNF40NMXy95OgX7DmF7irUc5vKqQYMozSTOIhI2jMRSgFS4ug7d
         pTsKRiPqMOo6gGTRJhk5X8RAqEqmZLqA7Jh6AV+Ceus7xMNAR62V1rAVqwOeUs/4fG
         T0lVws1SjwM83DF5U0nLqwlYmvXc42AXM1nrBlCcXyVeoeLbb5tML9KQeSvGKI3eNV
         knPP0S9bLX9ltQtjkeTTUW6ScsPAGduMur3Z3ttK+gcBYdkfS6kapNX3vcis2V1TS+
         lEMaQKuFczzxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E109E73856;
        Tue, 14 Jun 2022 14:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: spectrum_cnt: Reorder counter pools
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165521581518.20153.5995266466532935010.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 14:10:15 +0000
References: <20220613125017.2018162-1-idosch@nvidia.com>
In-Reply-To: <20220613125017.2018162-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 13 Jun 2022 15:50:17 +0300 you wrote:
> From: Petr Machata <petrm@nvidia.com>
> 
> Both RIF and ACL flow counters use a 24-bit SW-managed counter address to
> communicate which counter they want to bind.
> 
> In a number of Spectrum FW releases, binding a RIF counter is broken and
> slices the counter index to 16 bits. As a result, on Spectrum-2 and above,
> no more than about 410 RIF counters can be effectively used. This
> translates to 205 netdevices for which L3 HW stats can be enabled. (This
> does not happen on Spectrum-1, because there are fewer counters available
> overall and the counter index never exceeds 16 bits.)
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: spectrum_cnt: Reorder counter pools
    https://git.kernel.org/netdev/net/c/4b7a632ac4e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


