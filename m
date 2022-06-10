Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C08545BC4
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbiFJFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243357AbiFJFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A63349256;
        Thu,  9 Jun 2022 22:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2259661E6D;
        Fri, 10 Jun 2022 05:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65838C3411C;
        Fri, 10 Jun 2022 05:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654839616;
        bh=piL3ZUsVXKLpnDEjDM8fV8VxAK87PAtjngdGcTceFhY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bZlgtvihg6Vva7Kcpfx4fg9/usXpMClwd3MBNr+K2bi2LwFBFb5/wrYpE+o7N87GF
         T1TaIW+pKzzeRD3sxEhbrfRUIXam5v1vdqzUIgLyv+LQX1XPtMuncB47k3Z6Jc7gZa
         pRU8fbeMk7mxFKPkHUJbfr+hzd5WNI+O33NtHY9M+btwu7612BWtjKvvuq74tT5FGe
         olAyOzF33iMacLoGp9NE9GwoKdG8rjE6Pr1inP5X8Djsd7jfFyMr7JrJf/2BtZMx7C
         QrKzFFnqDCQq+LkM3Dp6pe/QtVNa9OIw1esqaEWeShyzWgcllt/Mh9Ps9DCHy//J0B
         F1PY32q+dUGBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 481E5E73803;
        Fri, 10 Jun 2022 05:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483961628.13976.4015696054691394649.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:40:16 +0000
References: <20220608043955.919359-1-kuba@kernel.org>
In-Reply-To: <20220608043955.919359-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, dsahern@kernel.org,
        steffen.klassert@secunet.com, jreuter@yaina.de,
        razor@blackwall.org, jiri@resnulli.us, kgraul@linux.ibm.com,
        ivecera@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        lucien.xin@gmail.com, arnd@arndb.de, yajun.deng@linux.dev,
        atenart@kernel.org, richardsonnick@google.com,
        hkallweit1@gmail.com, linux-hams@vger.kernel.org,
        dev@openvswitch.org, linux-s390@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Jun 2022 21:39:55 -0700 you wrote:
> Netdev reference helpers have a dev_ prefix for historic
> reasons. Renaming the old helpers would be too much churn
> but we can rename the tracking ones which are relatively
> recent and should be the default for new code.
> 
> Rename:
>  dev_hold_track()    -> netdev_hold()
>  dev_put_track()     -> netdev_put()
>  dev_replace_track() -> netdev_ref_replace()
> 
> [...]

Here is the summary with links:
  - [net-next] net: rename reference+tracking helpers
    https://git.kernel.org/netdev/net-next/c/d62607c3fe45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


