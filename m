Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C937633B9C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiKVLmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiKVLmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:42:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2034BE29
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BFCB81A2E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A3B4C433D7;
        Tue, 22 Nov 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669117214;
        bh=eVg13pTSaok0FQHtuqDxIkKAw+HYFMzf5rT+ycnEsUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KCdrX3DV2dyZlkOBi+cZ2QU947H2uwXWhYNnZf8disnwtg06jdOmEekPqoDoPHL5m
         UpbDBqUmxrl12UBWVWVpY0J9xek4G61aTX1I9tLy3HQFceiPqzmlb6iuqiuPOnem99
         XZm5H19ocH8I9u56rRjQreTGYdyB8xQrKM1K7COYLsCLdHlXyZsD/Ue3/MZIuZHqB0
         WzHL35fLWM/eKVgYQjHqzf9JNxl40GSSA9bKeZpbI78JvadDTEXyfR78LpcR5xbE3P
         /9y2+Tkh5cHMl54MwDnhsyRC2hMwKkjrMf7GNfwSNpT7AqRG1AGUTVdashKlYjYsHd
         NdRmQ9IXUxMUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2159EE270E3;
        Tue, 22 Nov 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: allow act_ct to be built without NF_NAT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166911721413.22168.1907429566053769478.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 11:40:14 +0000
References: <b6386f28d1ba34721795fb776a91cbdabb203447.1668807183.git.lucien.xin@gmail.com>
In-Reply-To: <b6386f28d1ba34721795fb776a91cbdabb203447.1668807183.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, yuehaibing@huawei.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 18 Nov 2022 16:33:03 -0500 you wrote:
> In commit f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT"),
> it fixed the build failure when NF_NAT is m and NET_ACT_CT is y by
> adding depends on NF_NAT for NET_ACT_CT. However, it would also cause
> NET_ACT_CT cannot be built without NF_NAT, which is not expected. This
> patch fixes it by changing to use "(!NF_NAT || NF_NAT)" as the depend.
> 
> Fixes: f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sched: allow act_ct to be built without NF_NAT
    https://git.kernel.org/netdev/net/c/8427fd100c7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


