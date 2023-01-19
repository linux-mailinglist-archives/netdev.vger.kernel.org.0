Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAF8673CCB
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjASOuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 09:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjASOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 09:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCDF75A2F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 06:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B677761B5F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24B05C433D2;
        Thu, 19 Jan 2023 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674139818;
        bh=IWc2HeGsV9gzAnAJ9k4L+UYU0HhAN7mx3oS3RjCM0TI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GoeW5C3QsA9jTJwaP25vPu0W1wNsZcyX1c6ecL06GXCm/spZzYWbnMPe97FUYbmX/
         jcNjh0oPgov1odt7noE/XoF8EBQpYDEYd2gJQjgImE8iiklMUAG5l8hw6m04Cx5eWc
         7qZbBoz1/Bqg4Pn4z2jEJWGPTdQULy/aLr3cmznCZ3hGtyIuyXm0D00m/o1OsSBLsd
         5vgHSmZ3qMbgaQxRO4ZThJWgDbfKxHKXUdyciqG6bTbp5dnCsmY+4uJ5v4Q6vCnt+Z
         TXsTLjm3glCKTjSifa/dxjGf0R2WhLSNQZxRzZrnoK5RiAXUtrm9QDjjebAUurRokv
         Nxw/QR1BrLY0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 021C0E54D27;
        Thu, 19 Jan 2023 14:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/10] net/mlx5: fix missing mutex_unlock in
 mlx5_fw_fatal_reporter_err_work()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167413981800.11564.12927804433603480018.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 14:50:18 +0000
References: <20230118080414.77902-2-saeed@kernel.org>
In-Reply-To: <20230118080414.77902-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, yangyingliang@huawei.com, lkp@intel.com,
        error27@gmail.com, shayd@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 18 Jan 2023 00:04:05 -0800 you wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> 
> Add missing mutex_unlock() before returning from
> mlx5_fw_fatal_reporter_err_work().
> 
> Fixes: 9078e843efec ("net/mlx5: Avoid recovery in probe flows")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,01/10] net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()
    https://git.kernel.org/netdev/net/c/90e7cb78b815
  - [net,02/10] net/mlx5e: Avoid false lock dependency warning on tc_ht even more
    https://git.kernel.org/netdev/net/c/5aa561059303
  - [net,03/10] net/mlx5e: Remove redundant xsk pointer check in mlx5e_mpwrq_validate_xsk
    https://git.kernel.org/netdev/net/c/6624bfeecf01
  - [net,04/10] net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT
    https://git.kernel.org/netdev/net/c/f51471d1935c
  - [net,05/10] net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT
    https://git.kernel.org/netdev/net/c/4ddf77f9bc76
  - [net,06/10] net/mlx5e: Set decap action based on attr for sample
    https://git.kernel.org/netdev/net/c/ffa99b534732
  - [net,07/10] net/mlx5e: Remove optimization which prevented update of ESN state
    https://git.kernel.org/netdev/net/c/16bccbaa00b6
  - [net,08/10] net/mlx5e: Protect global IPsec ASO
    https://git.kernel.org/netdev/net/c/e4d38c454ae5
  - [net,09/10] net/mlx5: E-switch, Fix switchdev mode after devlink reload
    https://git.kernel.org/netdev/net/c/7c83d1f4c5ad
  - [net,10/10] net: mlx5: eliminate anonymous module_init & module_exit
    https://git.kernel.org/netdev/net/c/2c1e1b949024

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


