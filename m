Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8993669422B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjBMKAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjBMKAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8B5E3A1
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 02:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44730B81081
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB3FAC4339E;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676282421;
        bh=N9joze8tTsiuFWomoAFSlpJf5PlJq7tcIkrOm9NdafU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t7F7pTuECTtT7knyrQ/wsYAunAk6ZECET0KcUhPD5WO73aYTQo8lC2FOM17hOk0du
         r1y37C21nXMZX0JLipmyTOzet3TVcinSezsluJLZ+fQ4RT+X+KGA4ZvXwSpE1yXZdh
         DO2xIzwyOudJ+eSNblM/Czf/7/5NSm+wL6t7m9HZ115tlwXKY0m4EBVCKucHDYDGW+
         EQ8cCLvFIlrstNoxbNiKbuNn2odxl7DTt4jZ0kjdDCThxaa0yapnFy794sC0S/2N6g
         DtmvVsG1oh+VdvOFG1GGSK0B9pbk4G2BXotJP4lrVYNIDEYu5rMPeepbqhB1vo92Sq
         b6CM2C8lN6NZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD9FAE68D30;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628242083.19101.6056516224763881889.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 10:00:20 +0000
References: <20230210100131.3088240-1-jiri@resnulli.us>
In-Reply-To: <20230210100131.3088240-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com, simon.horman@corigine.com,
        idosch@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 11:01:24 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The primary motivation of this patchset is the patch #6, which fixes an
> issue introduced by 075935f0ae0f ("devlink: protect devlink param list
> by instance lock") and reported by Kim Phillips <kim.phillips@amd.com>
> (https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/)
> and my colleagues doing mlx5 driver regression testing.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] devlink: don't use strcpy() to copy param value
    https://git.kernel.org/netdev/net-next/c/fa2f921f3bf1
  - [net-next,v2,2/7] devlink: make sure driver does not read updated driverinit param before reload
    https://git.kernel.org/netdev/net-next/c/afd888c3e19c
  - [net-next,v2,3/7] devlink: fix the name of value arg of devl_param_driverinit_value_get()
    https://git.kernel.org/netdev/net-next/c/94ba1c316b9c
  - [net-next,v2,4/7] devlink: use xa_for_each_start() helper in devlink_nl_cmd_port_get_dump_one()
    https://git.kernel.org/netdev/net-next/c/fbcf938150ec
  - [net-next,v2,5/7] devlink: convert param list to xarray
    https://git.kernel.org/netdev/net-next/c/a72e17b45232
  - [net-next,v2,6/7] devlink: allow to call devl_param_driverinit_value_get() without holding instance lock
    https://git.kernel.org/netdev/net-next/c/280f7b2adca0
  - [net-next,v2,7/7] devlink: add forgotten devlink instance lock assertion to devl_param_driverinit_value_set()
    https://git.kernel.org/netdev/net-next/c/6b4bfa43ce29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


