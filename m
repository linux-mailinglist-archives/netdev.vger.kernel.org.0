Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46715BED3C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiITTA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiITTAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40786582C;
        Tue, 20 Sep 2022 12:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A7F62D30;
        Tue, 20 Sep 2022 19:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8D45C4314F;
        Tue, 20 Sep 2022 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663700419;
        bh=1gLmX7uHLPgGgGb+WXC9SmUysHHG6gxHOyg05Mv3g2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N4BmC3Ijnm03Q7LRs3vDA6y3dERWtWvFUuFEYpJuIyqKk+P+oCrfwnelvKWpsokAD
         KguLNhHNIwy71i06K0jLKCyAd5JFjq4LOr2tV62whZm7DZ/gH2RNVEHChpGYSJGyVL
         6PxlEsmh2TSe3oP3GHOyYsS95XDR+i0ECHPUUYX1Bq0f3/kC9h5j7XXxhjASQExH7f
         f6lCeVd9yb8ya7oupRfPqEcaGddsGTE2ml502wLn7DRRa3ITFCok5MazlWR2kHW0Kc
         1eWXSn3M1YcymMm8tl1AFaygPzA4SFHkNUHHZT4uxED5SwZhHBuzV3k0HYS1tOuiTt
         FVlaz6Y7JwHtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A68C1E52510;
        Tue, 20 Sep 2022 19:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/2] net: enetc: move enetc_set_psfp() out of the
 common enetc_set_features()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370041967.20640.16151381451398906801.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 19:00:19 +0000
References: <20220916133209.3351399-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220916133209.3351399-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, richard.pearn@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Sep 2022 16:32:08 +0300 you wrote:
> The VF netdev driver shouldn't respond to changes in the NETIF_F_HW_TC
> flag; only PFs should. Moreover, TSN-specific code should go to
> enetc_qos.c, which should not be included in the VF driver.
> 
> Fixes: 79e499829f3f ("net: enetc: add hw tc hw offload features for PSPF capability")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
    https://git.kernel.org/netdev/net/c/fed38e64d9b9
  - [v2,net,2/2] net: enetc: deny offload of tc-based TSN features on VF interfaces
    https://git.kernel.org/netdev/net/c/5641c751fe2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


