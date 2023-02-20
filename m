Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1342769C8F7
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjBTKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjBTKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3877812F3F
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C269D60C7F
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 212C9C433A1;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890217;
        bh=ldxx2I5ejRVzzYasnKLHlatqYyOhGGbW+e7T/nkgVWo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UShxdeOJzQu4Tmrnd+SVjT8yAVWe0PNbTA08SV1VgrIKcvSVGFX+ULLc01OB0x4kw
         4oonQA+VhpBfd06hccEg+eu0aHB12Gf7G2jAt+jZ+PDDYcxRjqj8XdFh4N+27nRaYN
         /e715c1xt3aDX3PHykPl+scy6LWmFpVYcPOmPNkGnsT5j/8i59QtJJ1E5eJCNBeqaO
         vzzgf7Y8WsdRr7Rik2RUDk1HDXEIz5KpuKznDcCRTAAJgDtS/isS+d5DsfiVJCWUj3
         M5Smxt0NGb2/GkdomObKTGng8UYMNhP2r5UoYqSee501nMS3QlS7wUhwVb1z11xsSd
         i7kDlutKtCIkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 023CCC73FE7;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] ice: properly alloc ICE_VSI_LB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689021700.13054.11542164917931060672.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:50:17 +0000
References: <20230217105017.21057-1-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230217105017.21057-1-michal.swiatkowski@linux.intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 11:50:17 +0100 you wrote:
> Devlink reload patchset introduced regression. ICE_VSI_LB wasn't
> taken into account when doing default allocation. Fix it by adding a
> case for ICE_VSI_LB in ice_vsi_alloc_def().
> 
> Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] ice: properly alloc ICE_VSI_LB
    https://git.kernel.org/netdev/net-next/c/8173c2f9a1a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


