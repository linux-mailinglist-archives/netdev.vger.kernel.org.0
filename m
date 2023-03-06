Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76DA6AD076
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCFVbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCFVbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4B286DF2
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA8CB8113E
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAD03C4339B;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678138218;
        bh=U8x5bFrrn8CErSl1hq8NhdLhYgAoOYDXZ/5YZCYrR54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nPHnXSMuSAbsFsPev54l4dxuqB4jmpZT2TMPNGs1p4zMl76nTODx0ohxb09/Oj531
         vOmi/HKq1MG2qF38yTPCZoDtDUnNglBTR/m4WlTImXZlvPKP8APfCYY7S3HbdJKyUQ
         l3khiJbfKIdc8c296+Iayzzk4MvnH8ksj17+07ZL/kBOo19lges4hckZH5tSV8xXdg
         CA6do9k+XXCKEDxZM2Ktno5t149PTO5dw1QJzo6l3NQYfdsy8zyJv9laAm1waKsQ0M
         orpvMDlJKJJUFlG94KDnEKPKMgeGfYlVPIR/uKprD0bsNFMsuXI+Hrruaplm70pdSs
         oMU+SBqbkGo6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEAC8E52504;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: 2 bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167813821877.7576.17450604410395897224.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Mar 2023 21:30:18 +0000
References: <1677897838-23562-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1677897838-23562-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Mar 2023 18:43:56 -0800 you wrote:
> This series fixes 2 issues:
> 
> 1. A potential order-5 memory allocation failure during open.
> 2. Double memory free bug during shutdown.
> 
> Michael Chan (1):
>   bnxt_en: Avoid order-5 memory allocation for TPA data
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Avoid order-5 memory allocation for TPA data
    https://git.kernel.org/netdev/net/c/accd7e23693a
  - [net,2/2] bnxt_en: Fix the double free during device removal
    https://git.kernel.org/netdev/net/c/89b59a84cb16

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


