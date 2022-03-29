Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C492F4EA9A8
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 10:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiC2Iv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 04:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiC2Iv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 04:51:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8300E4C795;
        Tue, 29 Mar 2022 01:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AC87B8162D;
        Tue, 29 Mar 2022 08:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E800FC340F2;
        Tue, 29 Mar 2022 08:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648543812;
        bh=dlBuGuUnOKTfSTpEd5whjluEjge0pFJX6fOgYdNnCnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uug9glEPY/1EA0plVvFdzTlF7Mcc2WgxxIn5h0FRSRjsS6v9KE2CJkxwI7ujzhK4K
         YlMiBEHMutwAFcnuqXQku79yw27Mo2ebzXwf5GsW6b8GF15Ypphm0hIN05D8tFWxfY
         bH/kZ/Lq9rAJ3lIdkMGEJ/YeGc/HfRbkGG24UUTta10HonQoBX09M6cLIBhJEPAz8X
         UzrWg3XnA97cGhmgbTAL0zMXq2e9539L3a8ZKNFkDm6OP1xGt28NE0znwEfv71BF6d
         qxtq9Vj1oyvWBp91vGQKZ/GRGwI5Ffwu/LCWReIa2U0eRUgBpBGhiXrir9qzQscqXQ
         +REQdu8xDntCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5E37E6D44B;
        Tue, 29 Mar 2022 08:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix UAF bugs caused by ax25_release()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164854381180.32009.1756665388491287782.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Mar 2022 08:50:11 +0000
References: <cover.1648472006.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1648472006.git.duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, ralf@linux-mips.org, jreuter@yaina.de,
        dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 28 Mar 2022 21:00:13 +0800 you wrote:
> The first patch fixes UAF bugs in ax25_send_control, and
> the second patch fixes UAF bugs in ax25 timers.
> 
> Duoming Zhou (2):
>   ax25: fix UAF bug in ax25_send_control()
>   ax25: Fix UAF bugs in ax25 timers
> 
> [...]

Here is the summary with links:
  - [net,1/2,V2] ax25: fix UAF bug in ax25_send_control()
    https://git.kernel.org/netdev/net/c/5352a7613083
  - [net,2/2] ax25: Fix UAF bugs in ax25 timers
    https://git.kernel.org/netdev/net/c/82e31755e55f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


