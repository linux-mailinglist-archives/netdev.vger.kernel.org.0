Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AC54FCBE3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244866AbiDLBc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiDLBc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AD113D23;
        Mon, 11 Apr 2022 18:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEA661047;
        Tue, 12 Apr 2022 01:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 703FCC385AA;
        Tue, 12 Apr 2022 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649727011;
        bh=y0SHa5ehdasmyuILDO1pFKt4qKWN4fredmH2EEpE8XI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VuA3HDCnGKJ4u1TuBPUNVg1+BmE5AOdFSCaQSYMSuQriF3zGi6x8ZP4Y4Gi5ermLb
         pTbeHpTTMNOLqQMU3FH8WIm5eL9Ciqh9OTeR/78Eief/QPzdVCdhldxr6ResvU88Ik
         wMjapP3aXDAxz4RnI2yNpXXCRe4hNo+/FbEwv9VbbTWRH+rb1M25d3W7xEYd/P0gsS
         N3xjgTqWrwmfGir4EZvl20B1IgdLE3P7OPI7jsec8fz2GzAIeb5wPgjxqQkQnGMLUu
         Cae/kRnU2QMadxRJwKY8qPI2NpnpfvsoPhW6NDZhWKGZrpvI6C2SAC3INuNof8/T1H
         8wXPU726a2o6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 561D7E85B76;
        Tue, 12 Apr 2022 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] hv_netvsc: Add support for XDP_REDIRECT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164972701134.31190.7243820472815913361.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 01:30:11 +0000
References: <1649362894-20077-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1649362894-20077-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 13:21:34 -0700 you wrote:
> Handle XDP_REDIRECT action in netvsc driver.
> Also, transparently pass ndo_xdp_xmit to VF when available.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h |  69 ++++++++++++++-
>  drivers/net/hyperv/netvsc.c     |   8 +-
>  drivers/net/hyperv/netvsc_bpf.c |  95 +++++++++++++++++++-
>  drivers/net/hyperv/netvsc_drv.c | 150 +++++++++++++-------------------
>  4 files changed, 228 insertions(+), 94 deletions(-)

Here is the summary with links:
  - [net-next] hv_netvsc: Add support for XDP_REDIRECT
    https://git.kernel.org/netdev/net-next/c/1cb9d3b6185b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


