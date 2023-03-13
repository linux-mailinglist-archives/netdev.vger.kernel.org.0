Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C86B8630
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCMXkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjCMXkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457253B206;
        Mon, 13 Mar 2023 16:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0E6E61540;
        Mon, 13 Mar 2023 23:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35ECAC4339B;
        Mon, 13 Mar 2023 23:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678750817;
        bh=BWJpo5Yx95YbIqYpWbjuzEmNkFYrx8DMntUSrU0h6Es=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AphEpNggaO4M++PQwRigDyn6y+7PhHJAs3L6vkIPKMT+1Zf4U2jwxGafCBJrD/nzH
         7DYf4NmvWAmxt5PeMUcRUNIS6+cpLf62h+SeuSlJbe24ZZsqH6FkWdVeHLUiBVj5vF
         UOmE7JOGM8QuqTm7BFuhN/flw0e6lTDepM8TuEPMZsMQyDKiCNmoTsC35IIBKG1m4K
         RQ0W1jTNv0oP8E1PqWpvryC9yZ+1q9677Qswf8yBFco54cXh14NVs9LxXO7ZwmkjIK
         dfQBe5OpFBUQEm+N8xGQhVBNPceAu1IxvkQPSkuA7bzxSPgRIgQst5Zsva8H2yeHdz
         n/PhVYKgX1n5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C2A4C59A4C;
        Mon, 13 Mar 2023 23:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH next-next] bnxt: avoid overflow in bnxt_get_nvram_directory()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875081711.805.4783713735950503185.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:40:17 +0000
References: <20230309174347.3515-1-korotkov.maxim.s@gmail.com>
In-Reply-To: <20230309174347.3515-1-korotkov.maxim.s@gmail.com>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 20:43:47 +0300 you wrote:
> The value of an arithmetic expression is subject
> of possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Security Code and Linux Verification
> Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [next-next] bnxt: avoid overflow in bnxt_get_nvram_directory()
    https://git.kernel.org/netdev/net-next/c/7c6dddc239ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


