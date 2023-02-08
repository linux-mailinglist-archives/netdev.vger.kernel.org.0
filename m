Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D768E729
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjBHEbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjBHEaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA21D3BDBD
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 20:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B9BB81BE7
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FC5DC433A0;
        Wed,  8 Feb 2023 04:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675830619;
        bh=7YEVU9bx7VKEe+YUr10Cx7Nx0GCtHkz04jqoNo5KDfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ie6TX4WlPfYIB4rNO38M1hue+Ne6ZV7wJvVsDtKwIupgqoseoO0cv+Wf1N25ut6gk
         df+3OUFDECfZSb4t9Rl9lJ9A6jOA93LN0iCbx/HUHV0hFEHj8NNBOm0M4F4Oz+LFeJ
         zJKI77CdYWpWSXHbvItFxt98UeNa8vahZFa3ZdwVhgnbpNBZe0oFjyvA/vphTz4cdU
         OtRZmxm0KYpJGcuYSiWfGRsWjd7XPg1KzRQfE8xVKMigBzJvaMwyoIG7bOUueQvFVq
         SFl+bHKjVOxT+7YhjIw2bU+bspdUw5y3DYzEyFyjuc9xmtPxn3POdj7Zr+0E0bfOR+
         kGbXv/FlOF6wQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBAF0E55F06;
        Wed,  8 Feb 2023 04:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Misc devlink changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583061896.23427.6505396902325822012.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 04:30:18 +0000
References: <cover.1675692666.git.petrm@nvidia.com>
In-Reply-To: <cover.1675692666.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, idosch@nvidia.com, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com
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

On Mon, 6 Feb 2023 16:39:17 +0100 you wrote:
> This patchset adjusts mlxsw to recent devlink changes in net-next.
> 
> Patch #1 removes a devl_param_driverinit_value_set() call that was
> unnecessary, but now additionally triggers a WARN_ON.
> 
> Patches #2-#4 are non-functional preparations for the following patches.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: spectrum: Remove pointless call to devlink_param_driverinit_value_set()
    https://git.kernel.org/netdev/net-next/c/8b50ac29854a
  - [net-next,2/6] mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
    https://git.kernel.org/netdev/net-next/c/65823e07b1e4
  - [net-next,3/6] mlxsw: spectrum_acl_tcam: Make fini symmetric to init
    https://git.kernel.org/netdev/net-next/c/61fe3b9102ac
  - [net-next,4/6] mlxsw: spectrum_acl_tcam: Reorder functions to avoid forward declarations
    https://git.kernel.org/netdev/net-next/c/194ab9476089
  - [net-next,5/6] mlxsw: spectrum_acl_tcam: Move devlink param to TCAM code
    https://git.kernel.org/netdev/net-next/c/74cbc3c03c82
  - [net-next,6/6] mlxsw: core: Register devlink instance before sub-objects
    https://git.kernel.org/netdev/net-next/c/9d9a90cda415

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


