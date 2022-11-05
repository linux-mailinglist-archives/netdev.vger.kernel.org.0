Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D181D61A6F0
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKECkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKECkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDF395BB
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A10CDB83064
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 227C2C433C1;
        Sat,  5 Nov 2022 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667616016;
        bh=kvHJGNF/BIc3pEO5uyH3JPesXpwQvV8xQ5r+lAv6Ex0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fuOR6V1ZlR9W71OzBd8uMRITdQ1HEM9zEOyNKXXCCu72GPAaphjSBLz5GMk7ejmUu
         5wZY81qh3A34ONdeS6lx0OeOryaB0Be5qpF9kv+DbjY7nItn1KMS+0RIhvCkZvp0TR
         Ayv2mGweEfYav5uhIL7fIvjQ8Ox0vDytU6piWevW20eRnyIaHYtq8X6UvKSdZkkd/I
         h+qc00vZFEdTlPQ6qHFn7o2sRQ1fiNVJoKMEkUldHipKEQMWsV2/QepieK+wTlFAeQ
         CkBo0/wMAkDUrwJE3riJ4Mx7JzxTDuyxUbYg1ILTHYxce8pFIaLGWxN0wNUATsCTy9
         YFN7GkIKT/Xzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07D9CE29F4C;
        Sat,  5 Nov 2022 02:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166761601602.5821.12423020008499338624.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Nov 2022 02:40:16 +0000
References: <1667518407-15761-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1667518407-15761-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  3 Nov 2022 19:33:23 -0400 you wrote:
> This bug fix series includes fixes for PCIE AER, a crash that may occur
> when doing ethtool -C in the middle of error recovery, and aRFS.
> 
> Alex Barba (1):
>   bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
> 
> Michael Chan (1):
>   bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()
> 
> [...]

Here is the summary with links:
  - [net,1/4] bnxt_en: refactor bnxt_cancel_reservations()
    https://git.kernel.org/netdev/net/c/b4c66425771d
  - [net,2/4] bnxt_en: fix the handling of PCIE-AER
    https://git.kernel.org/netdev/net/c/0cf736a18a1e
  - [net,3/4] bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()
    https://git.kernel.org/netdev/net/c/6d81ea3765df
  - [net,4/4] bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
    https://git.kernel.org/netdev/net/c/02597d39145b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


