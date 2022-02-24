Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706C04C33DB
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiBXRkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiBXRkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:40:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFD51A7DB2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD628B8269C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 17:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F365C340F0;
        Thu, 24 Feb 2022 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645724410;
        bh=9Al/PZwQpg97QCLF4oyRpIzR2B2cElWZ+pTZgnH48Zg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vDDx2wfO3OX0vlICdzp26CfD92cSJd7ln9/ZjlPdqhRGZuiRHqjSyVgsL7qJEjAM8
         +MGVpebSs1JgEQr2dMcOlnQYe77R1j58sMNhLFBzF+5fozKKBqEatT44bon2x4y6mo
         GG3c3X77mblM+KjYYlvkVMTC0TGpqACyaVHt0VoikNIJlOJpO65W6OxRkJSz8t/G0y
         h4HII5RCzvsgDl9zjns5Bm+jToXrEPtDdBwwq06hgFJkJoyBMn26CxE/N8KNR06Fzq
         TU8xsqIQC8TXX/6A9Kz3OQ/zK5funzGVuOBfbysO44bBidl1oP+B8dII8A1SQsBf61
         jg8bOFcoxcQHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47FEFEAC081;
        Thu, 24 Feb 2022 17:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] Revert "i40e: Fix reset bw limit when DCB enabled
 with 1 TC"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572441029.16635.17138146531227687434.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 17:40:10 +0000
References: <20220223175347.1690692-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220223175347.1690692-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mateusz.palczewski@intel.com,
        netdev@vger.kernel.org, sassmann@redhat.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 09:53:47 -0800 you wrote:
> From: Mateusz Palczewski <mateusz.palczewski@intel.com>
> 
> Revert of a patch that instead of fixing a AQ error when trying
> to reset BW limit introduced several regressions related to
> creation and managing TC. Currently there are errors when creating
> a TC on both PF and VF.
> 
> [...]

Here is the summary with links:
  - [net,1/1] Revert "i40e: Fix reset bw limit when DCB enabled with 1 TC"
    https://git.kernel.org/netdev/net/c/fe20371578ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


