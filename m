Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEBC59942C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbiHSEU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346113AbiHSEUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2FDB064;
        Thu, 18 Aug 2022 21:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7938B825AB;
        Fri, 19 Aug 2022 04:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96BF4C433D6;
        Fri, 19 Aug 2022 04:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660882814;
        bh=CT77yHALvLTtIZNCPcMKOTCgH2M6jAUIkGweMbwJ08E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gjw5I6fidI3tufXURpIbYjfYAhFoyXS5ELOoyfZGkJO/2kdHJ1U3GV8NSDQ4Be4fU
         EeKsDuJGhvcxOa8YzsCuUK6d3EUrzg1RHUVWKH7oBJmAeuUP3U5DxoGguZirbwavL8
         yR8HSkTHq1+KkYsGHRrkCfGIdTzyaCIZkkvdyF+5SaF/ZYondflaQ0ha55aZaeSZZP
         JzZnJ0PbuLogjPFkcxINvUPrIFI9UCtdOJgk5ogyI5E/iH7Do4OhqkAzELYfB90E56
         JVSnpu3O6d7Dgb6UE8JZ6vzEyQNtogE10hYTdGNMKgTJndXEMC9SlGle1ihqEeZ56K
         i1qbIVVngrQRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 760A5E2A054;
        Fri, 19 Aug 2022 04:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] igc: add xdp frags support to ndo_xdp_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166088281448.25213.9992525174310842366.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 04:20:14 +0000
References: <20220817173628.109102-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220817173628.109102-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        naamax.meir@linux.intel.com
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

On Wed, 17 Aug 2022 10:36:28 -0700 you wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Add the capability to map non-linear xdp frames in XDP_TX and
> ndo_xdp_xmit callback.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] igc: add xdp frags support to ndo_xdp_xmit
    https://git.kernel.org/netdev/net-next/c/8c78c1e52b0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


