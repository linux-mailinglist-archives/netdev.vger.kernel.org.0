Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E7B647C68
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiLICug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLICuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:50:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B9686F6B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 18:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6D286213E
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38F62C433F0;
        Fri,  9 Dec 2022 02:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670554233;
        bh=ulLfs8bQcf1IWCR2o9Kgpk0iS7AJFTuSHLXihCatUbo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPq7sWtv3GKeeKZF+O2uz3VY+k0krxP6M7fIoBPWyO1n//kL3r4JsPpmiBDG1tGLW
         0qKBeI/eLr40mH6W8q9DS1rb5Ys+HbzNpdZILU0qrX4lgiN5S3bB0aJ1uH3KlwZPBW
         Udsyju7wunPjW2BxKi4xlOIKkbzKwahPhczcKjnu9V9dAYvyrX5beI8xRijbN5V74P
         hk+M0JHl8a7BMZdXp7sCRGBPfi03cJOTqbpyDNhMCpvvERmsW/an9N+afHP2U30Fns
         IoqSejjBSzDqv3/wrtKVtw9mQjQsKkHHMI6hOrx/X22apei6x1K2ZtpqzEMQZAtIZf
         Y6vAS7beG91qw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 237CEC41606;
        Fri,  9 Dec 2022 02:50:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] mlxsw: Add Spectrum-1 ip6gre support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167055423313.8327.6157288824692899313.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 02:50:33 +0000
References: <cover.1670414573.git.petrm@nvidia.com>
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

On Wed, 7 Dec 2022 13:36:41 +0100 you wrote:
> Ido Schimmel writes:
> 
> Currently, mlxsw only supports ip6gre offload on Spectrum-2 and newer
> ASICs. Spectrum-1 can also offload ip6gre tunnels, but it needs double
> entry router interfaces (RIFs) for the RIFs representing these tunnels.
> In addition, the RIF index needs to be even. This is handled in
> patches #1-#3.
> 
> [...]

Here is the summary with links:
  - [net,1/6] mlxsw: spectrum_router: Use gen_pool for RIF index allocation
    https://git.kernel.org/netdev/net-next/c/40ef76de8a7f
  - [net,2/6] mlxsw: spectrum_router: Parametrize RIF allocation size
    https://git.kernel.org/netdev/net-next/c/1a2f65b4a277
  - [net,3/6] mlxsw: spectrum_router: Add support for double entry RIFs
    https://git.kernel.org/netdev/net-next/c/5ca1b208c5d1
  - [net,4/6] mlxsw: spectrum_ipip: Rename Spectrum-2 ip6gre operations
    https://git.kernel.org/netdev/net-next/c/ab30e4d4b29b
  - [net,5/6] mlxsw: spectrum_ipip: Add Spectrum-1 ip6gre support
    https://git.kernel.org/netdev/net-next/c/7ec5364351ed
  - [net,6/6] selftests: mlxsw: Move IPv6 decap_error test to shared directory
    https://git.kernel.org/netdev/net-next/c/db401875f438

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


