Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3899526F78
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiENBDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiENBC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:02:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DA3EBA96
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F129B8324D
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D661AC34115;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652487013;
        bh=GDukE55xZSBDyz+lx1K1PGwEk3oc+CKe4624F5ANekQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=op9P8bVf+M99zXj2q0eD8/SX/nPE0EzL/KZkQuSqg1sGdyX+nQrbjqnwde5RG18BZ
         uzE9+GGi+sft0tLB1OsS6gSN9EQt1r2VuGKkR8Wylt7FE+Pj9hbf87toIo6bOTCS7k
         phC9EHOEp4ZJKVfo5ZDjUlKh1/BxgIF1Eb5M5OwZf12XVa1kGuIL1mr2ORnwiYn/W+
         zDuksmv25DeCHWvE6ew9+zagEMa5QsFbFiEaIhc6Jj5PE4nYmK1hkbOSCIJpF6KovD
         ZfZKX36cxzdkoLt+Afq8tLk0BO3ck28aD+yIVRyQKY8ynzXgXkWZ9ouj94N1ma+ZjF
         4ycUulHJAK4zQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C052DF03934;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: sfc: remove remnants of the out-of-tree
 napi_weight module param
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165248701378.14999.8863916795598626983.git-patchwork-notify@kernel.org>
Date:   Sat, 14 May 2022 00:10:13 +0000
References: <20220512205603.1536771-1-kuba@kernel.org>
In-Reply-To: <20220512205603.1536771-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, hkallweit1@gmail.com, ihuguet@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 12 May 2022 13:56:03 -0700 you wrote:
> Remove napi_weight statics which are set to 64 and never modified,
> remnants of the out-of-tree napi_weight module param.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ecree.xilinx@gmail.com
> CC: habetsm.xilinx@gmail.com
> CC: hkallweit1@gmail.com
> CC: ihuguet@redhat.com
> 
> [...]

Here is the summary with links:
  - [net-next] eth: sfc: remove remnants of the out-of-tree napi_weight module param
    https://git.kernel.org/netdev/net-next/c/c28678162b33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


