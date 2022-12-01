Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8584263E99C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiLAGKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiLAGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F74A85E2
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 22:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26FE861EA9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46373C43153;
        Thu,  1 Dec 2022 06:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669875017;
        bh=hozUH6T6PH3Y6/hM/gJcrV49l5jrvVEfOsr88QDqV4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NMlv2kIdOXXpsxwO6wWMg0z/dfV3LoKJzOMbEvoBJjUIP3ajugPonUv1iXUVq1Za3
         JHmzOGYQTDkKOcrjgfC12ngt1+qLyDtjSP9+0VEMYEiHzWXEl5Rb7AIWp4vYfSv+Vv
         lquFGjUBrqCB4h5U06a5UbC3rzJZFVLWf8hTmZdokwK1l1rF/aIpPjoNGLtBFnXY37
         AaDqGt2RZBdG2tx5Wbg+OH1ik76+BN7jbL40VS8YW7u7l5JT8KBBRQlfyRVhj68bQy
         4sp5pIdNM5Vrsq20UR1LJu/3iCQ0J2YOi0WcmJzXrscYxQ4yeOaCWxejmyI0MumfM+
         Z0uiwAXegZgJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B4F0E29F38;
        Thu,  1 Dec 2022 06:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] net: devlink: return the driver name in
 devlink_nl_info_fill
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987501717.18933.6140637869420910519.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 06:10:17 +0000
References: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, kurt@linutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        michael.chan@broadcom.com, ioana.ciornei@nxp.com,
        dmichail@fungible.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, tchornyi@marvell.com,
        saeedm@nvidia.com, leon@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com, manishc@marvell.com,
        jonathan.lemon@gmail.com, vadfed@fb.com, richardcochran@gmail.com,
        vadimp@mellanox.com, shalomt@mellanox.com,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        jiri@mellanox.com, herbert@gondor.apana.org.au,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        chi.minghao@zte.com.cn, sthotton@marvell.com
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

On Tue, 29 Nov 2022 18:51:37 +0900 you wrote:
> The driver name is available in device_driver::name. Right now,
> drivers still have to report this piece of information themselves in
> their devlink_ops::info_get callback function.
> 
> The goal of this series is to have the devlink core to report this
> information instead of the drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] net: devlink: let the core report the driver name instead of the drivers
    https://git.kernel.org/netdev/net-next/c/226bf9805506
  - [net-next,v6,2/3] net: devlink: make the devlink_ops::info_get() callback optional
    https://git.kernel.org/netdev/net-next/c/c5cd7c86847c
  - [net-next,v6,3/3] net: devlink: clean-up empty devlink_ops::info_get()
    https://git.kernel.org/netdev/net-next/c/cf4590b91db4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


