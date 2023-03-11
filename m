Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B616B58B0
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCKFkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCKFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09847E9180
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 981F660BCB
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 05:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F014FC4339B;
        Sat, 11 Mar 2023 05:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513218;
        bh=9LYxVXVwyQRDUGywIZXTncL3JwAX+dwxVmpQUzzmGdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f8yDa7co4jJhX6WRVcA1ghR7f8UjTgdYrSExupUVEQoDyUjGJmmTYh7bCnhGNJx5X
         8Wb3vABcTW1zwqfEZS9cdd+6Rnw/q8/VF+L1Jun/Kup6UQQljCKRi0O+99EW33Nm4k
         SElHnQQXTpNes7aO2dzeIkSOo+cNINDryQTZBLhpSyYYRLWjdIMpVsqV1FUHYcYo4q
         ciVRonk81X8kXkYjWJ1lNLeBXBHWeG7FwzO/Zjcu1WMTBzbFjTzCipnJn/CK4kugNK
         zHQz9V6ani2obV/qAEa6sL3dvJtTdkmYj2oaf1NVoY4ARVijVkgFWBSPqVF3D5cmMI
         wfQHmK+O6bcjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8BC1E61B65;
        Sat, 11 Mar 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] sfc: support offloading TC VLAN push/pop actions
 to the MAE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851321788.18470.5349911665260612243.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:40:17 +0000
References: <20230309115904.56442-1-edward.cree@amd.com>
In-Reply-To: <20230309115904.56442-1-edward.cree@amd.com>
To:     <edward.cree@amd.com>
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Mar 2023 11:59:04 +0000 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> EF100 can pop and/or push up to two VLAN tags.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v3:
>  * used VLAN_VID_MASK and VLAN_PRIO_SHIFT instead of raw constants (Simon)
>  * stopped checkpatch complaining about long lines (Simon, Martin)
> Changed in v2: reworked act->vlan_push/pop to be counts rather than bitmasks,
>  and simplified the corresponding efx_tc_action_order handling.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] sfc: support offloading TC VLAN push/pop actions to the MAE
    https://git.kernel.org/netdev/net-next/c/05ccd8d8a15e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


