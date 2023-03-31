Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999596D1A93
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjCaImJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjCaIlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:41:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5191D909;
        Fri, 31 Mar 2023 01:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA6CB82D3F;
        Fri, 31 Mar 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01E3DC433D2;
        Fri, 31 Mar 2023 08:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680252019;
        bh=2awnFRbwlRr0wF/0EtqlcbkmL5UREFWPCl9PiidbMaQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aj0SZjErK7rbaciHhkIeW+Po5O2r/L4KUs0628aJBB0/T1a23yHlzHe7dZpvNCNKm
         qxIJ7Tdt7d+YAg8n2svRf0ZjMoHAUR+yHd+bjcl5CAv1ReZ93Mcs60p5OdevjtP4B2
         fy28p4fbt1T9K4OHCfSSwW/jE3c+0g618cRp2fjVthRrMMrJZqcb18GwXIPvwnB3hz
         99xZAJ7sFL94zZV/UXHS86mK2NH7yRu1/hg5Z2+YOTSdTyueIN3O6pVZezkpH3HCLq
         Pg2P2E4tm/GwgtihAhxGrRrrBXYru81xhuB9fO46jikmjef+D1Gbh3/HWTVZMF2PUP
         OpjbLsEzW+kPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C77F5C73FE0;
        Fri, 31 Mar 2023 08:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] l2tp: generate correct module alias strings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025201881.3875.10346861679226207793.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:40:18 +0000
References: <20230330095442.363201-1-andrea.righi@canonical.com>
In-Reply-To: <20230330095442.363201-1-andrea.righi@canonical.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, wojciech.drewek@intel.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Mar 2023 11:54:42 +0200 you wrote:
> Commit 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h") moved the
> definition of IPPROTO_L2TP from a define to an enum, but since
> __stringify doesn't work properly with enums, we ended up breaking the
> modalias strings for the l2tp modules:
> 
>  $ modinfo l2tp_ip l2tp_ip6 | grep alias
>  alias:          net-pf-2-proto-IPPROTO_L2TP
>  alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
>  alias:          net-pf-10-proto-IPPROTO_L2TP
>  alias:          net-pf-10-proto-2-type-IPPROTO_L2TP
> 
> [...]

Here is the summary with links:
  - l2tp: generate correct module alias strings
    https://git.kernel.org/netdev/net/c/154e07c16485

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


