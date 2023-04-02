Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C36A6D37D7
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDBMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDBMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:30:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6551C1C9
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83F66CE0C2F
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA727C433A7;
        Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680438617;
        bh=zKOp8DAmqTwAcLdcwBfgwVNz2Luj+mD73dAhGSfgFIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHqF5N1kNtwWgmS1GQNG9QaRs0DrQnV99EnSmF/RFh+zDy+3440pDQq2gio6jdi8W
         JsDEli7TmGgnd3yEUrawBISCQoExKtUPFc2hXazVWJzE+NscrDj4PhHlT7klnMSb1N
         UVOES1OOEC+poJvpnseWByo7jsE4x28Csu/+JefySq01KiNfKSX5AGPziHmAOaOE72
         m1HWdTephEwDu5YmSLffuU0VxsUF6HbLN8kj7VEXY+DOQV3mbW+NjR53hsdORg9Ony
         b172OFiTFLA1wkyhD1Fi765MF2UL/sd3sOG+KnHGVA6PZFrgvm1MY6A5D+XYJ+FDwh
         szsLhHCTBykZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8FF9BE2A036;
        Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] i40e: Add support for VF to specify its primary
 MAC address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043861758.6785.6148501671970637218.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:30:17 +0000
References: <20230330170022.2503673-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230330170022.2503673-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        sylwesterx.dziedziuch@intel.com, mateusz.palczewski@intel.com,
        rafal.romanowski@intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Mar 2023 10:00:22 -0700 you wrote:
> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> 
> Currently in the i40e driver there is no implementation of different
> MAC address handling depending on whether it is a legacy or primary.
> Introduce new checks for VF to be able to specify its primary MAC
> address based on the VIRTCHNL_ETHER_ADDR_PRIMARY type.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] i40e: Add support for VF to specify its primary MAC address
    https://git.kernel.org/netdev/net-next/c/ceb29474bbbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


