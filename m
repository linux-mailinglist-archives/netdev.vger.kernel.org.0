Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58196427F1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiLEMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiLEMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE330E02F;
        Mon,  5 Dec 2022 04:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB2D6101F;
        Mon,  5 Dec 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD8D5C433D6;
        Mon,  5 Dec 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670241615;
        bh=wV5ABqckFi3sFUBzWGbdsvVKYDM5LVbGm2zpCYRVtAE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WnG1vi5EWrqIaGsnSNbfDZvHM055wh/YkT4Dc5qJyFKkba4Pq3onaNunGqCHQAtlK
         ZmjeiTpvKw+CCtq0X8rjX/TDF91LebSW6UaTimCYZjU8RM1FxjCqO+gWVhnJnW1t5R
         O92bGxhIWoEJmwjQou8Hg+akV0tOKKuKpJVyfJPeKbeSFvUqqT5H6jeIlSfsE+c0VU
         ZMtlRe9lmn1N4P0N7YdyHp6JUti1X6663YpqJKfgEOUte1+cSLgx0hmW9ajbJFRm1Q
         UYB5kC+netfKX8pdECaL/UeNwf9K6m4tGsT2opK3lAifXcIRjASRpC5890nJQ+cS2G
         M9nEPJGQ+hkYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95D79E21EFD;
        Mon,  5 Dec 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: mxl-gpy: rename MMD_VEND1 macros to match
 datasheet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167024161560.14641.10134460671246447975.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 12:00:15 +0000
References: <20221202144900.3298204-1-michael@walle.cc>
In-Reply-To: <20221202144900.3298204-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     lxu@maxlinear.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Dec 2022 15:49:00 +0100 you wrote:
> Rename the temperature sensors macros to match the names in the
> datasheet.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> For the curious: I probably copied the prefix from the already existing
> VPSPEC2_ macros in the driver, the datasheet also mentions some VPSPEC2_
> names, but I suspect they are typos.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: mxl-gpy: rename MMD_VEND1 macros to match datasheet
    https://git.kernel.org/netdev/net-next/c/343a5d358e4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


