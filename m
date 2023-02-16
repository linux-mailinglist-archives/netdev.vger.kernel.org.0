Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD7698B33
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBPDaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPDaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:30:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C08446D77
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA6F261E71
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E48EC4339B;
        Thu, 16 Feb 2023 03:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676518222;
        bh=tIP0Mn7AB8r0WlpliSrORk2lm/HfWpQIx1dq4vsEeeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DbE3YwYTEIfWkyEV+fcbj53T7MmtryGBdUknq8EDH02AYldId79xfTGpsmRc4ErPv
         Tk95I2/KKkk5Y7j8os5SGLm1ijumrJ1LUdAYcB7W1o2vdofR3iLYDO+enpxYOLQLbo
         nUACU4ZPPpw5fQjlkZ35gNqOYAzHZ4ulUcB4m0ChJ5B2JPNWiwNc4vCyUtMSUxI/OM
         Y7pz0kl5AGzymqTCfefdVflRnxH4Br0W7KmoeFpy5qe3g8Jkf5MRAYfM4a/8ONMQs0
         /VyLyh0APLDICIQZru8e/sRZA2d6Z+v2ykTPosS3kogvoFlTw2nyOP/YHvDwfFp0hq
         nJT6IXdmd1oFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4636E29F41;
        Thu, 16 Feb 2023 03:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] devlink: cleanups and move devlink health
 functionality to separate file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167651822192.29240.16746598808039292318.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 03:30:21 +0000
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 18:37:56 +0200 you wrote:
> This patchset moves devlink health callbacks, helpers and related code
> from leftover.c to new file health.c. About 1.3K LoC are moved by this
> patchset, covering all devlink health functionality.
> 
> In addition this patchset includes a couple of small cleanups in devlink
> health code and documentation update.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] devlink: Split out health reporter create code
    https://git.kernel.org/netdev/net-next/c/b4740e3a8137
  - [net-next,v2,02/10] devlink: health: Fix nla_nest_end in error flow
    https://git.kernel.org/netdev/net-next/c/bfd4e6a5dbbc
  - [net-next,v2,03/10] devlink: Move devlink health get and set code to health file
    https://git.kernel.org/netdev/net-next/c/db6b5f3ec400
  - [net-next,v2,04/10] devlink: Move devlink health report and recover to health file
    https://git.kernel.org/netdev/net-next/c/55b9b2496852
  - [net-next,v2,05/10] devlink: Move devlink fmsg and health diagnose to health file
    https://git.kernel.org/netdev/net-next/c/a929df7fd9c6
  - [net-next,v2,06/10] devlink: Move devlink health dump to health file
    https://git.kernel.org/netdev/net-next/c/7004c6c45761
  - [net-next,v2,07/10] devlink: Move devlink health test to health file
    https://git.kernel.org/netdev/net-next/c/c9311ee13f0e
  - [net-next,v2,08/10] devlink: Move health common function to health file
    https://git.kernel.org/netdev/net-next/c/12af29e7790a
  - [net-next,v2,09/10] devlink: Update devlink health documentation
    https://git.kernel.org/netdev/net-next/c/c745cfb27ae3
  - [net-next,v2,10/10] devlink: Fix TP_STRUCT_entry in trace of devlink health report
    https://git.kernel.org/netdev/net-next/c/d0ab772c1f15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


