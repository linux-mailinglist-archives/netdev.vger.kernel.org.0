Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E0568CF8E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjBGGkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjBGGkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A9E222E4;
        Mon,  6 Feb 2023 22:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14918611DF;
        Tue,  7 Feb 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66CDEC433EF;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675752019;
        bh=/qGix3O7gnaPGGj+od8ObwY2cImTjQDrivzBvtDhDI0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JR6OdSP891g4RvGmPYT9gyZrg67zfucBh4IcEojEIV1ybtjEh/cqs6WcWIBlPSPZj
         N6cBTIF/ux5YQbqfY/zDeql09rX1TBflFve0cm3k6BudwB2mZp82LPvylv/ZbX388F
         fwfsfAOnUHEEnI/WEURLnDBH/S1miMbVlQ7uakB9Id/3EOYYlj9k9RW6ewcKc3E0i8
         fFD9nER/RBbpuMrSNS4CRm6w6dChtUmhlo5LrTYrFb/SAkQc0cS+NMG3bi+msbJzGN
         Gxs40+abG6m11MvBMrdsJkq4m+yxtOlnlQsEtFb8fUVRxXCKZgJAMpFZM21aJ5vSvB
         q/93V/aZGnGrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48A97E55F07;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v11 0/8] Add Auxiliary driver support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167575201929.385.11164394951252164491.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 06:40:19 +0000
References: <20230202033809.3989-1-ajit.khaparde@broadcom.com>
In-Reply-To: <20230202033809.3989-1-ajit.khaparde@broadcom.com>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, gregkh@linuxfoundation.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Ajit Khaparde <ajit.khaparde@broadcom.com>:

On Wed,  1 Feb 2023 19:38:01 -0800 you wrote:
> Add auxiliary device driver for Broadcom devices.
> The bnxt_en driver will register and initialize an aux device
> if RDMA is enabled in the underlying device.
> The bnxt_re driver will then probe and initialize the
> RoCE interfaces with the infiniband stack.
> 
> We got rid of the bnxt_en_ops which the bnxt_re driver used to
> communicate with bnxt_en.
> Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> In most of the cases we used the functions and entry points provided
> by the auxiliary bus driver framework.
> And now these are the minimal functions needed to support the functionality.
> 
> [...]

Here is the summary with links:
  - [net-next,v11,1/8] bnxt_en: Add auxiliary driver support
    https://git.kernel.org/netdev/net-next/c/d80d88b0dfff
  - [net-next,v11,2/8] RDMA/bnxt_re: Use auxiliary driver interface
    https://git.kernel.org/netdev/net-next/c/6d758147c7b8
  - [net-next,v11,3/8] bnxt_en: Remove usage of ulp_id
    https://git.kernel.org/netdev/net-next/c/dafcdf5e2bd0
  - [net-next,v11,4/8] bnxt_en: Use direct API instead of indirection
    https://git.kernel.org/netdev/net-next/c/63669ab384ea
  - [net-next,v11,5/8] bnxt_en: Use auxiliary bus calls over proprietary calls
    https://git.kernel.org/netdev/net-next/c/3b65e9456c29
  - [net-next,v11,6/8] bnxt_en: Remove struct bnxt access from RoCE driver
    https://git.kernel.org/netdev/net-next/c/848dc857c8de
  - [net-next,v11,7/8] RDMA/bnxt_re: Remove the sriov config callback
    https://git.kernel.org/netdev/net-next/c/a43c26fa2e6c
  - [net-next,v11,8/8] bnxt_en: Remove runtime interrupt vector allocation
    https://git.kernel.org/netdev/net-next/c/303432211324

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


