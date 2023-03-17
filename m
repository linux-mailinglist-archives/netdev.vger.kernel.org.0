Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F286BDDBF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCQAkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCQAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561C560AAB;
        Thu, 16 Mar 2023 17:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D3D62168;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37E4FC433A4;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013618;
        bh=UaoOlgdjL2mC0DDzbWN9Tml2jueAJ5KeO3PXA0PG2rg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nj3MPyxemQCbM50IbPE23+bmcDBgoLT9F5/KojR5MuIaHenL0rIt0Bj6A4sAcmIXt
         jCE3p2zn4JjGyCgyQ9oAOmVOFouJRwcMErqJqdkHIiSNjO5pF9HAgE2dVZR7EUSaj+
         bEcdHv5hRg76nYGckZ3zFweOJ4CgYzw8fdiwdD26QiVx2DvVwtBDiRc4aweZzmvlp9
         t5RGvcJM7h20UOesGl9d2CdyXt8BXR7/Udg+I5u3Ji4Hp2TptnGkgN3opcfpeXchMZ
         2Z5kP4E6pJeakxCkBxieqk4kxnvuYJMe4SK+OZauYobx0gn68f+5AJAlOEy1UqzvYz
         /x8WDRAiI5yTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1AE32E4D031;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3] selftests: net: devlink_port_split.py: skip test if no
 suitable device available
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901361810.32704.5315746948051322541.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:40:18 +0000
References: <20230315165353.229590-1-po-hsu.lin@canonical.com>
In-Reply-To: <20230315165353.229590-1-po-hsu.lin@canonical.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, danieller@mellanox.com, petrm@mellanox.com,
        idosch@mellanox.com, shuah@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 00:53:53 +0800 you wrote:
> The `devlink -j port show` command output may not contain the "flavour"
> key, an example from Ubuntu 22.10 s390x LPAR(5.19.0-37-generic), with
> mlx4 driver and iproute2-5.15.0:
>   {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
>            "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
>            "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
>            "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}
> 
> [...]

Here is the summary with links:
  - [PATCHv3] selftests: net: devlink_port_split.py: skip test if no suitable device available
    https://git.kernel.org/netdev/net/c/24994513ad13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


