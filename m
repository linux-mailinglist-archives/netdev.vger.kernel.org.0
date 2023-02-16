Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF463699302
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjBPLU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjBPLUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:20:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D32B34F76;
        Thu, 16 Feb 2023 03:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD6B6B82567;
        Thu, 16 Feb 2023 11:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92368C433EF;
        Thu, 16 Feb 2023 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676546419;
        bh=l6MY0atF8jS0aZVBcoX9GMuGDckwA/CdbUtg9RXDs+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VY8D/qNIPRE9T2T8z2cwFjZ1bfDxZxOICgsOSN5GxbBXzLgyiC1urkgqRCkfhLDx2
         Ib++b/DX8UN4K8COJuAexQkMkj1TzXr/1W6QCJtftTV/uGxdUiw4MzItTYBz/bTlN3
         yefPzaP/Qev04INVMWBJhb86ApcTVqlzQLILHUcKVX2Y8UjM3x4DPNKmkcZ3dD04o0
         ILFkLO7kLCt/Lcfgnkb8v9o4qqW29flG3TrBBOc48HjVjnjrty2zRG0XSiKl370fa6
         DQywwYczzHlC3dZ0N4Njg6sU4nepQpZ5sIvM8tiRBI9zaNbC8ElXbJ+zKZLmgx13XD
         /XK9AqSaLhxTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CDF4E270C2;
        Thu, 16 Feb 2023 11:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 net-next 0/8] sfc: devlink support for ef100
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167654641942.8610.4801746796392234945.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 11:20:19 +0000
References: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
In-Reply-To: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
To:     Lucero@ci.codeaurora.org, Palau@ci.codeaurora.org,
        Alejandro <alejandro.lucero-palau@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 09:08:20 +0000 you wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> v8 changes:
>  - using preprocessor conditional approach instead of ifdef for
>    fixing Microblaze build error.
> 
> v7 changes:
>  - Fix Microblaze build error based on checking RTC_LIB instead of
>    SFC_SRIOV.
> 
> [...]

Here is the summary with links:
  - [v8,net-next,1/8] sfc: add devlink support for ef100
    https://git.kernel.org/netdev/net-next/c/fa34a5140a8e
  - [v8,net-next,2/8] sfc: add devlink info support for ef100
    https://git.kernel.org/netdev/net-next/c/14743ddd2495
  - [v8,net-next,3/8] sfc: enumerate mports in ef100
    https://git.kernel.org/netdev/net-next/c/a6a15aca4207
  - [v8,net-next,4/8] sfc: add mport lookup based on driver's mport data
    https://git.kernel.org/netdev/net-next/c/5227adff37af
  - [v8,net-next,5/8] sfc: add devlink port support for ef100
    https://git.kernel.org/netdev/net-next/c/25414b2a64ae
  - [v8,net-next,6/8] sfc: obtain device mac address based on firmware handle for ef100
    https://git.kernel.org/netdev/net-next/c/7e056e2360d9
  - [v8,net-next,7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
    https://git.kernel.org/netdev/net-next/c/fa78b01718d2
  - [v8,net-next,8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
    https://git.kernel.org/netdev/net-next/c/3b6096c9b30b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


