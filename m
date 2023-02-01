Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DBB685EBF
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjBAFK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjBAFKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BFD4FAC9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66F89B81F2D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2FA6C4339C;
        Wed,  1 Feb 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228220;
        bh=XVtTLB6lY8yy3n4NcZUva89KyEDrIrpy1NkeA6NRYBs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B5GQNHKvIb5KkKa6k9hQCmiYsEBOS/mAVkQ4BPsb0f03ay75JwytZOeZ+a95mmjrr
         iMElZvEKhjaDeBfnzzpEPppKU3KTDK+znJVGSnBDYhYBSVP9uJIfMtRQCnZbzVeAAR
         4CztS+9rvJxv/7J1WLmKQnskhHCyNtqYzYrHcuocBeqGZ06yVdjl5LtEtj73dr0Bsq
         k3BtnvAhLJ4FRrMZXRIbsDLNwHMPnKw2ctHaIRyCSh1CSDBZnhlHr+TZj9dZXKNJyo
         ZIJMdoyxBYQeSBFmL9iQz3P2SgMkDGtTyLd1OW9V2NKzvki5Qfk6DiGfhy+eCDTya6
         2WwFFcemFTptQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D23DEE21ED4;
        Wed,  1 Feb 2023 05:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] selftests: mlxsw: Convert to iproute2 dcb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522821985.27789.7304890309311849.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:10:19 +0000
References: <cover.1675096231.git.petrm@nvidia.com>
In-Reply-To: <cover.1675096231.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, danieller@nvidia.com,
        mlxsw@nvidia.com
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

On Mon, 30 Jan 2023 17:40:00 +0100 you wrote:
> There is a dedicated tool for configuration of DCB in iproute2. Use it
> in the selftests instead of lldpad.
> 
> Patches #1-#3 convert three tests. Patch #4 drops the now-unnecessary
> lldpad helpers.
> 
> Petr Machata (4):
>   selftests: mlxsw: qos_dscp_bridge: Convert from lldptool to dcb
>   selftests: mlxsw: qos_dscp_router: Convert from lldptool to dcb
>   selftests: mlxsw: qos_defprio: Convert from lldptool to dcb
>   selftests: net: forwarding: lib: Drop lldpad_app_wait_set(), _del()
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: mlxsw: qos_dscp_bridge: Convert from lldptool to dcb
    https://git.kernel.org/netdev/net-next/c/1680801ef64d
  - [net-next,2/4] selftests: mlxsw: qos_dscp_router: Convert from lldptool to dcb
    https://git.kernel.org/netdev/net-next/c/10d5bd0b69ed
  - [net-next,3/4] selftests: mlxsw: qos_defprio: Convert from lldptool to dcb
    https://git.kernel.org/netdev/net-next/c/5b3ef0452c59
  - [net-next,4/4] selftests: net: forwarding: lib: Drop lldpad_app_wait_set(), _del()
    https://git.kernel.org/netdev/net-next/c/bd32ff68721c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


