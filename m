Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3556405AC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiLBLUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiLBLUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:20:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FADD5BD42
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 03:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA7FF62243
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E550C433B5;
        Fri,  2 Dec 2022 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669980017;
        bh=0FwwC+4RyVcPIbS3zwEKuvpS+pI+2K+xAOcg7I5X0fg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OmO5OAKphjMefu0e6zDQlnzalY3heIBlf/AnjcFIhHsmmT3OnNRfbdFXkTuZNzqvD
         IVB0bJcLWh1xtlV/Uf5abAS5nhZa2X2NxZqEbw1j/UfDs4winWF9rcopT91AiWNkbg
         WQEqx4IU/a8qryoH3bnbdkJovzwdcV4aG42JuGLi9WCvcnLQC2VqdC74xM3ckpzICj
         IjT9K68rdDuVUNadgBUoTpasu2BhobTGwzXSzseE1wpyLGQBMzpoBwG8rFmlN6z59d
         pLoqoRF1N5BHgdND2G5V1C69XGt9EdykkeYMm+jj03wmDlew84/s7Yrh8v75NLlYBU
         7NdWnC1OXz51g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 324F6C41622;
        Fri,  2 Dec 2022 11:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] tsnep: Throttle interrupts,
 RX buffer allocation and ethtool_get_channels()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166998001720.12503.6333150149628522017.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 11:20:17 +0000
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
In-Reply-To: <20221130193708.70747-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 30 Nov 2022 20:37:04 +0100 you wrote:
> Collection of improvements found during development of XDP support.
> Hopefully the last patch series before the XDP support.
> 
> ethtool_get_channels() is needed for automatic TAPRIO configuration in
> combination with multiple queues.
> 
> Rework of the RX buffer allocation is prework of XDP. It ensures that
> packets are only dropped if RX queue would otherwise run empty because
> of failed allocations. So it should reduce the number of dropped packets
> under low memory conditions.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] tsnep: Consistent naming of struct net_device
    https://git.kernel.org/netdev/net-next/c/91644df1ba01
  - [net-next,v2,2/4] tsnep: Add ethtool::get_channels support
    https://git.kernel.org/netdev/net-next/c/4f661ccfcac7
  - [net-next,v2,3/4] tsnep: Throttle interrupts
    https://git.kernel.org/netdev/net-next/c/d3dfe8d6c040
  - [net-next,v2,4/4] tsnep: Rework RX buffer allocation
    https://git.kernel.org/netdev/net-next/c/dbadae927287

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


