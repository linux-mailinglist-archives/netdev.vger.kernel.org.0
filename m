Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F9154692D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344140AbiFJPKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344041AbiFJPKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7725419FF6F
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B40D361F77
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 15:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 219F2C3411D;
        Fri, 10 Jun 2022 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654873814;
        bh=CdSZiam5BQZOkZsZ2205Bw/AlEtSUZx58kjGjbIDBUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kP4IfMS97YFTGiB+Zj1dGMd2V2QtLBTwYOxQxysnJxCgfhZDsfQB5RXvNNMazxZ2W
         ju0C+WMV9WEWDcagc4Fv/Kf9nKwRPL7+4lrXn2soxujpZA7f3z8HfmGjxgKfPba0vS
         1c13mF5iPUtnX8BRWVpdAGudQPKrYB67MSnR1hAkW4txDTP/OI3W/vt+1yXow/5n5/
         yAiLqaf+71lqCP86U21MUBLc8PhMsLYWtYpWR6xVmqiwyAkJ+qVW3xOIVIsavDZV3J
         /hLjXXbGrFGeRzzGl4F9eu3Hi2DBmkju5PsHjEfG/eCNCJgKnEtuI3Ne3QTYbHj3Ho
         dwo8xUOu3KLtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 057F2E737F0;
        Fri, 10 Jun 2022 15:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 00/10] bridge: fdb: add extended flush support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165487381401.23380.16753813786292392416.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 15:10:14 +0000
References: <20220608122921.3962382-1-razor@blackwall.org>
In-Reply-To: <20220608122921.3962382-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, roopa@nvidia.com
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

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  8 Jun 2022 15:29:11 +0300 you wrote:
> Hi,
> This set adds support for the new bulk delete flag to allow fdb flushing
> for specific entries which are matched based on the supplied options.
> The new bridge fdb subcommand is "flush", and as can be seen from the
> commits it allows to delete entries based on many different criteria:
>  - matching vlan
>  - matching port
>  - matching all sorts of flags (combinations are allowed)
> 
> [...]

Here is the summary with links:
  - [iproute2-next,01/10] bridge: fdb: add new flush command
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=6e1ca489c5a2
  - [iproute2-next,02/10] bridge: fdb: add flush vlan matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d9c15896f1d3
  - [iproute2-next,03/10] bridge: fdb: add flush port matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bb9e453c1406
  - [iproute2-next,04/10] bridge: fdb: add flush [no]permanent entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=988c31980750
  - [iproute2-next,05/10] bridge: fdb: add flush [no]static entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0f6c81a63c50
  - [iproute2-next,06/10] bridge: fdb: add flush [no]dynamic entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8198f75073ed
  - [iproute2-next,07/10] bridge: fdb: add flush [no]added_by_user entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ef5425739fb8
  - [iproute2-next,08/10] bridge: fdb: add flush [no]extern_learn entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b78036468886
  - [iproute2-next,09/10] bridge: fdb: add flush [no]sticky entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=259795676e90
  - [iproute2-next,10/10] bridge: fdb: add flush [no]offloaded entry matching
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4a4e32a92b56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


