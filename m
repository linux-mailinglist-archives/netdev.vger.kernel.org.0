Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3686EA229
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjDUDKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjDUDKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62651FE7;
        Thu, 20 Apr 2023 20:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68ABD618BB;
        Fri, 21 Apr 2023 03:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE1B9C4339B;
        Fri, 21 Apr 2023 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682046621;
        bh=PxQlMZHt462rH3/YZlPvcpmM5U9K+lz98YiwnqZtSPg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dtFF76yShNdpUXsm+W3vX7ouHUNLx0j+JtjvlhUZsQbN/Vx1vGXl+o3yHvZFYdfCw
         mMWVF5s6/0fTLH81zn7scMZRnOCpFX0y3KVuus6CGdm+5DcTSu0d8f/Fyl2aC5CLme
         TQ01LWGx8V6tKWt/Mt+ob6QRleGJxdSulcm8lb1GCE1UOIwiIWMDnLkyPPm4siTLJK
         hyzcSNMXMrceYfx2VsKrqeGsCrj9uc8HbLj16o5JUy2J0xS+gNmD+5pfjI/UcMLN3v
         E1avwNz7fwS61L+3EGn6QLMp05bkILMHkl7ixyftGqpZM70j2hDLsH7y4iZIMb8mgC
         IlYaR3/Vl4O7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99791E270E1;
        Fri, 21 Apr 2023 03:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/9] ethtool mm API consolidation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204662162.31034.16190929689278834562.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 03:10:21 +0000
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com, petrm@nvidia.com,
        danieller@nvidia.com, pranavi.somisetty@amd.com,
        harini.katakam@amd.com, vinicius.gomes@intel.com,
        kurt@linutronix.de, gerhard@engleder-embedded.com,
        ferenc.fejes@ericsson.com, aconole@redhat.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 14:14:50 +0300 you wrote:
> This series consolidates the behavior of the 2 drivers that implement
> the ethtool MAC Merge layer by making NXP ENETC commit its preemptible
> traffic classes to hardware only when MM TX is active (same as Ocelot).
> 
> Then, after resolving an issue with the ENETC driver, it restricts user
> space from entering 2 states which don't make sense:
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/9] net: enetc: fix MAC Merge layer remaining enabled until a link down event
    https://git.kernel.org/netdev/net-next/c/59be75db5966
  - [v2,net-next,2/9] net: enetc: report mm tx-active based on tx-enabled and verify-status
    https://git.kernel.org/netdev/net-next/c/153b5b1d030d
  - [v2,net-next,3/9] net: enetc: only commit preemptible TCs to hardware when MM TX is active
    https://git.kernel.org/netdev/net-next/c/827145392a4a
  - [v2,net-next,4/9] net: enetc: include MAC Merge / FP registers in register dump
    https://git.kernel.org/netdev/net-next/c/16a2c7634442
  - [v2,net-next,5/9] net: ethtool: mm: sanitize some UAPI configurations
    https://git.kernel.org/netdev/net-next/c/35b288d6e3d4
  - [v2,net-next,6/9] selftests: forwarding: sch_tbf_*: Add a pre-run hook
    https://git.kernel.org/netdev/net-next/c/54e906f1639e
  - [v2,net-next,7/9] selftests: forwarding: generalize bail_on_lldpad from mlxsw
    https://git.kernel.org/netdev/net-next/c/8fcac79270ca
  - [v2,net-next,8/9] selftests: forwarding: introduce helper for standard ethtool counters
    https://git.kernel.org/netdev/net-next/c/b5bf7126a6a0
  - [v2,net-next,9/9] selftests: forwarding: add a test for MAC Merge layer
    https://git.kernel.org/netdev/net-next/c/e6991384ace5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


