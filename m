Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E5579166
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbiGSDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiGSDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD43A626F
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75AAAB8180F
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A56BC341CB;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202014;
        bh=anAjfeWSgCSqTsxogYAZfq3a0pUVSGG55RqJS/bQOLA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XpRANlrLaX5r1GAz2bxKnNcMjAlukKDZY+9mMNay/qnCw0v+n2ct/UvUqRZ+1gKmu
         F/s8bsECr1y/Ol80waiDGUvo8yQkA/59wTJzHewwk82wgZzseaQylEX65bU6n4K0RA
         wWylfKSGByhxAXPu2djIcVxlqyqhHyX/Nycaty5Xgza4f1OVNtexZj579dhckXHyPC
         J576UXF/uFVLKq6ppYp+57AmGH0vMYr+H/QB5rmmFixed6+pU6q2BhfjFkvQa834LL
         1yFIkmWCAhNjQCFy6/uxd4lySx6mi0adggGBHIkEYdlFgFBtGavIq6xkfmQInQuGjT
         4ncTun4Kb2Z/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CFCBE451B3;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] i40e: Fix erroneous adapter reinitialization during
 recovery process
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820201404.29134.5763526483519912541.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:40:14 +0000
References: <20220715214542.2968762-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220715214542.2968762-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dawid.lukwinski@intel.com,
        netdev@vger.kernel.org, jan.sokolowski@intel.com,
        konrad0.jankowski@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 15 Jul 2022 14:45:41 -0700 you wrote:
> From: Dawid Lukwinski <dawid.lukwinski@intel.com>
> 
> Fix an issue when driver incorrectly detects state
> of recovery process and erroneously reinitializes interrupts,
> which results in a kernel error and call trace message.
> 
> The issue was caused by a combination of two factors:
> 1. Assuming the EMP reset issued after completing
> firmware recovery means the whole recovery process is complete.
> 2. Erroneous reinitialization of interrupt vector after detecting
> the above mentioned EMP reset.
> 
> [...]

Here is the summary with links:
  - [net,1/1] i40e: Fix erroneous adapter reinitialization during recovery process
    https://git.kernel.org/netdev/net/c/f838a6336981

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


