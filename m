Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA24674B23
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjATEpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjATEoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:44:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A24C133B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:39:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 669CDB82793
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11DC4C433D2;
        Fri, 20 Jan 2023 03:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674184821;
        bh=zq/MPifUKc0LMvDwyFHEU1pYFIISkSvtUxOVjow/fE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kzR2rpI2HV6I+2fZf44y8obRtEIzyJEcTUbJJaBEVGr0pAeoRrc+V52p/EMbMaLQD
         xszZx74NE7YQMNgDP2pxFbnQw5/j7j9bAg09a2OUzLEzKq/oDJQbmpMXnjKUtKyANK
         XZ363ZwdGOWTDTVhTx2Yjwn/SxePPeu/ZvzGuqLOYw6dL5W4uubKqS77PUqNpbT5k+
         IIGDkpg3WbYYAFhryvD2KIlOrSUcVrAv9GovZW/zI3TJHHbGzF8zHTJenG9oBpel22
         fZzHl26vBRnTTDBN3aUqs1nf2pFpWD4EDS0y+/MghpR63ZkpJ83dbeKoDAn9Vzfpa8
         b+EN5HRBy3DQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E75D8C395DC;
        Fri, 20 Jan 2023 03:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v5 00/12] devlink: linecard and reporters locking
 cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167418482094.4845.13742265399809148202.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 03:20:20 +0000
References: <20230118152115.1113149-1-jiri@resnulli.us>
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
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

On Wed, 18 Jan 2023 16:21:03 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset does not change functionality.
> 
> Patches 1-2 remove linecards lock and reference counting, converting
> them to be protected by devlink instance lock as the rest of
> the objects.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/12] devlink: remove linecards lock
    (no matching commit)
  - [net-next,v5,02/12] devlink: remove linecard reference counting
    https://git.kernel.org/netdev/net-next/c/3a10173f48aa
  - [net-next,v5,03/12] net/mlx5e: Create separate devlink instance for ethernet auxiliary device
    https://git.kernel.org/netdev/net-next/c/ee75f1fc44dd
  - [net-next,v5,04/12] net/mlx5: Remove MLX5E_LOCKED_FLOW flag
    https://git.kernel.org/netdev/net-next/c/65a20c2eb96d
  - [net-next,v5,05/12] devlink: protect health reporter operation with instance lock
    https://git.kernel.org/netdev/net-next/c/dfdfd1305dde
  - [net-next,v5,06/12] devlink: remove reporters_lock
    https://git.kernel.org/netdev/net-next/c/1dea3b4e4c52
  - [net-next,v5,07/12] devlink: remove devl*_port_health_reporter_destroy()
    https://git.kernel.org/netdev/net-next/c/9f167327efec
  - [net-next,v5,08/12] devlink: remove reporter reference counting
    https://git.kernel.org/netdev/net-next/c/e994a75fb7f9
  - [net-next,v5,09/12] devlink: convert linecards dump to devlink_nl_instance_iter_dump()
    https://git.kernel.org/netdev/net-next/c/2557396808d9
  - [net-next,v5,10/12] devlink: convert reporters dump to devlink_nl_instance_iter_dump()
    https://git.kernel.org/netdev/net-next/c/19be51a93d99
  - [net-next,v5,11/12] devlink: remove devlink_dump_for_each_instance_get() helper
    https://git.kernel.org/netdev/net-next/c/543753d9e22e
  - [net-next,v5,12/12] devlink: add instance lock assertion in devl_is_registered()
    https://git.kernel.org/netdev/net-next/c/63ba54a52c41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


