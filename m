Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD16506B6E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351900AbiDSLw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352017AbiDSLwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:52:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB40E22514
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E21B61492
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADD2AC385AA;
        Tue, 19 Apr 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650369011;
        bh=bJa+LcxAkU7ZCKzATeHokWrOmPv+3ypu58jX3W3s74s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r6DqFMClGrx/xV59wS/dq5copPHPnb2Qx94H9DhTWNtQFNYjovWUQ9wLy2OnjvEeu
         /U/M30J+96d6DQeGTobYzpk5hivvXxvgNDNVfR4Ao/QhmM+liCVcFA0UJbIxVu9Ehm
         Rr/YniH+F1N3j2FAxJPMk/TNdbSdaiZTyva6g9u/A8wRjbPMSoEUBEPUrAEtWvGd3u
         ES0/iS/OqWNAZNmCyfoRTaQDwkknHm6a8trnFVfMRwb8pBRmWis0u8iWwoASRTQ9hy
         GRMz3NjYNU4Zu8v7m2R/HY3Z7U2cGdtEnIjCyKRvJi6tqNkZ3rEXZBAzYy44jxhsSd
         JXRn3J7VvQEfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95F33EAC09C;
        Tue, 19 Apr 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/4] rtnetlink: improve ALT_IFNAME config and fix
 dangerous GROUP usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165036901161.1040.3143036434940769413.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Apr 2022 11:50:11 +0000
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
In-Reply-To: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 15 Apr 2022 18:53:26 +0200 you wrote:
> First commit forbids dangerous calls when both IFNAME and GROUP are
> given, since it can introduce unexpected behaviour when IFNAME does not
> match any interface.
> 
> Second patch achieves primary goal of this patchset to fix/improve
> IFLA_ALT_IFNAME attribute, since previous code was never working for
> newlink/setlink. ip-link command is probably getting interface index
> before, and was not using this feature.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/4] rtnetlink: return ENODEV when ifname does not exist and group is given
    https://git.kernel.org/netdev/net-next/c/ef2a7c9065ce
  - [v5,net-next,2/4] rtnetlink: enable alt_ifname for setlink/newlink
    https://git.kernel.org/netdev/net-next/c/5ea08b5286f6
  - [v5,net-next,3/4] rtnetlink: return ENODEV when IFLA_ALT_IFNAME is used in dellink
    https://git.kernel.org/netdev/net-next/c/dee04163e9f2
  - [v5,net-next,4/4] rtnetlink: return EINVAL when request cannot succeed
    https://git.kernel.org/netdev/net-next/c/b6177d3240a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


