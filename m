Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF375159AF
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiD3Bxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382034AbiD3Bxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403F95FFA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B1B624B3
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 01:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D739C385B9;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283412;
        bh=L3j9qfRXL/JO5zB/G0PWw2WSz0Yrr6ybx8oHg15HgHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aVR1q3p2ayFF2Gt1zCw4wXaaLD+KrKbhMo3gYQsGHlBVMx9Bxg+c3eN5pZ39708Ri
         Aw+z8ccSJwpbO0CCQHpgVLBdNxrNmQfIRE4b7L5RmRKBTdiz5ZT9vw9k+J6S0dhVNg
         SSIbFIZDsj0YhH+pLDUFFafHvUwVaS3GHuTUA/vhKrdMc7Bn2IJZUTSskmu6AGccJw
         SZkATG3fEF8sBtQY3hVMAdNAt/lEZ/MsVJjTTfw0N27ey2FA8S1P1Sk6strCoQ6fTm
         9Y1hpbIuVTMGVuuasEI8BIqRqB6M/clQZV7mZwevozitoNxC0yF9spX6biz9yODFLK
         md4WqxSz3FnLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5922DF67CA0;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: add EF100 VF support via a write to
 sriov_numvfs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128341236.13664.11750003983600922788.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:50:12 +0000
References: <75e74d9e-14ce-0524-9668-5ab735a7cf62@gmail.com>
In-Reply-To: <75e74d9e-14ce-0524-9668-5ab735a7cf62@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, pieter.jansen-van-vuuren@amd.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Apr 2022 12:39:33 +0100 you wrote:
> From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> 
> This patch extends the EF100 PF driver by adding .sriov_configure()
> which would allow users to enable and disable virtual functions
> using the sriov sysfs.
> 
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: add EF100 VF support via a write to sriov_numvfs
    https://git.kernel.org/netdev/net-next/c/78a9b3c47bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


