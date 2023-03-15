Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD52C6BAAC5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjCOIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjCOIaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0DB38030;
        Wed, 15 Mar 2023 01:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D5B761B68;
        Wed, 15 Mar 2023 08:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 691CBC4339B;
        Wed, 15 Mar 2023 08:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678869017;
        bh=Z5slyDD6RPYiIxn4gPNIEOc30z1vuenQXP5Yc5ZgU3c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=teh/IDY0hpqObAJtKpkxG7mpYDbEX6sLgHTUjPU00TW2sSgf+908T3IwbnuPg00Uv
         c6qsmNAcNnF9j1aDDt0oyaSWo4VUD7AWYreqvFYFfN0sykyGDKyzdo49h6OnhJX8wt
         X1WVeBHzVlaPliZU/nKfg6KFpbOFmH8y1Asmxy0QPqZD3nJPosgRAt8gRBgCB1kPh8
         IEmyuyknt9iYosRZ2xtYRaRy3xHFrPyOop6WOqfkBSYwMK2fLden57ycKiN1jsFbZr
         I4vib5pzLr+xOXvmhreBPazNW8IgYU5IPWhKV/Ssur/NRqBkGYnbI93UV/pWJ6pamv
         XU0FmqpchN7Gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E6E0E66CBA;
        Wed, 15 Mar 2023 08:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] scm: fix MSG_CTRUNC setting condition for
 SO_PASSSEC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886901731.1055.14504007440539285248.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:30:17 +0000
References: <20230313113211.178010-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230313113211.178010-1-aleksandr.mikhalitsyn@canonical.com>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Mar 2023 12:32:11 +0100 you wrote:
> Currently, kernel would set MSG_CTRUNC flag if msg_control buffer
> wasn't provided and SO_PASSCRED was set or if there was pending SCM_RIGHTS.
> 
> For some reason we have no corresponding check for SO_PASSSEC.
> 
> In the recvmsg(2) doc we have:
>        MSG_CTRUNC
>               indicates that some control data was discarded due to lack
>               of space in the buffer for ancillary data.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] scm: fix MSG_CTRUNC setting condition for SO_PASSSEC
    https://git.kernel.org/netdev/net-next/c/a02d83f9947d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


