Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D771B5E882B
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 06:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiIXEK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 00:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiIXEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 00:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C6C3F1FB
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 21:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E19FEB81E12
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E495C433D6;
        Sat, 24 Sep 2022 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663992618;
        bh=NYeHAOpTWSFR2tsmroMEzETwL1ZjD25FKRsJw/InV00=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XrfyQsp2hFKnZe31Fu6d27airO42v36ueaWnRp5MhvbOjktpqniYQAJ6kGesqIPDA
         GPORNarz2lxSy/qhdyBOHLyorZbSajMS7WvEqO0aDdZOB/7e/UFko+4IylQolAKt2Y
         3S3ssQ0bG7VxzykBf+R1Idgb8a/QRDwVtcoZ+l4pKN1Ii9Lz1ylbYO4WE6by16bIXA
         +RIbMr6x8XXIp7VAyis9aYEj+/+9EJjh/SpYd2TsvQI3GqF9y5QCMRl4eg9h3TTJaC
         klJpo4TEyi9OxO+cUdInefBQ32DnJnGklZn0dzjoUUbLuooHi2Ycm5z5/zDPfPJiKp
         j34P7Q15q9UwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79A98E4D03A;
        Sat, 24 Sep 2022 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: correct filter_table_remove method for EF10 PFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166399261849.11836.13796426900300959202.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Sep 2022 04:10:18 +0000
References: <20220922211218.814-1-ecree@xilinx.com>
In-Reply-To: <20220922211218.814-1-ecree@xilinx.com>
To:     <ecree@xilinx.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, andy.moreton@amd.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 22:12:18 +0100 you wrote:
> From: Andy Moreton <andy.moreton@amd.com>
> 
> A previous patch added a wrapper function to take a lock around
>  efx_mcdi_filter_table_remove(), but only changed EF10 VFs' method table
>  to call it.  Change it in the PF method table too.
> 
> Fixes: 77eb40749d73 ("sfc: move table locking into filter_table_{probe,remove} methods")
> Signed-off-by: Andy Moreton <andy.moreton@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc: correct filter_table_remove method for EF10 PFs
    https://git.kernel.org/netdev/net/c/b7ca8d5f56e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


