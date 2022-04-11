Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3694FB8D1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344974AbiDKKCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344953AbiDKKC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5734710FC;
        Mon, 11 Apr 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15CAAB81195;
        Mon, 11 Apr 2022 10:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1C24C385AA;
        Mon, 11 Apr 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649671212;
        bh=4nuUzdrxqSSsR55oPV2LrNCSys89L6G+BR+aPdjjn/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HFPMkS7Ms++roW8K7wA4DvHI5eZuZ8MglV6NxgaCElM/QPz7Pmv66xE/BIj/O5LaH
         LBx9HrQ9PNro0DUDHtZ0IY57qHFFrJlUIJSPlfNZXp52CERKhdIeWYqtSFTqoKYjZE
         sWshr+a0wcIR9KqXFX3DtYBqQg8YhcVLslE7Txxq+RI69Cb65OeWpI+t5PlDCvcxj8
         Zo5ZtPiCHFv7HTvfpl9OwQfAa97xbWYMGpU5x3HLDlgSFVrFW80i465PjgnLny518p
         qsrA937xru5VRE/xipLPzJzuJUdNZqqJ+7qXVQrwxZA39lKdhLwrnw3kwpmDAKIukr
         rR8PD1Hrn8FIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8369CE8DD63;
        Mon, 11 Apr 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: stmmac: fix altr_tse_pcs function when using a
 fixed-link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967121253.20630.17401758441100611076.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 10:00:12 +0000
References: <20220407132521.579713-1-dinguyen@kernel.org>
In-Reply-To: <20220407132521.579713-1-dinguyen@kernel.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Apr 2022 08:25:21 -0500 you wrote:
> When using a fixed-link, the altr_tse_pcs driver crashes
> due to null-pointer dereference as no phy_device is provided to
> tse_pcs_fix_mac_speed function. Fix this by adding a check for
> phy_dev before calling the tse_pcs_fix_mac_speed() function.
> 
> Also clean up the tse_pcs_fix_mac_speed function a bit. There is
> no need to check for splitter_base and sgmii_adapter_base
> because the driver will fail if these 2 variables are not
> derived from the device tree.
> 
> [...]

Here is the summary with links:
  - net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link
    https://git.kernel.org/netdev/net/c/a6aaa0032424

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


