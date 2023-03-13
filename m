Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC876B85CA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCMXBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjCMXB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:01:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BF36F60A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F7CC6154A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79639C4339C;
        Mon, 13 Mar 2023 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678748417;
        bh=dkHV1JucW69bMidthF/sBqq67BuKRIwmhwnSPG0cuNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mNrAtqPa1wi3XbrUgJim3ch6eKBCQzu5HI6YVYSMqfhVtLlLPsXEPzJuhu3su531M
         39jG879ZylHUrPRsJ3dy1dzRInTr/67G9sM+bHJTF2PeRKxpTDiLF3xNs8RWnD9Vco
         88Fe++PGG9+zNfiKT84w7LDd9whOoKmQh3V8ovBlALDASLoSjCwlm0JQ+/MnXa9UW3
         zi4xuwUMhLD3bFkLccZB1B3nCc05DIYTyUKDupEakcEZoPbXzIlWRY2HsnG/oVyCFd
         a6FzCWRQXJTZmHPVu6g0BCO4v2sDPVpDwTmsViJByVUhWeXwlNVoQbUpyrGpQ4VPG9
         0Xh2AbjrGdg/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43293E66CB9;
        Mon, 13 Mar 2023 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] bnxt_en: reset PHC frequency in free-running mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167874841727.13753.7099605851212312940.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:00:17 +0000
References: <20230310151356.678059-1-vadfed@meta.com>
In-Reply-To: <20230310151356.678059-1-vadfed@meta.com>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     pavan.chebbi@broadcom.com, kuba@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        richardcochran@gmail.com, vadim.fedorenko@linux.dev,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 07:13:56 -0800 you wrote:
> When using a PHC in shared between multiple hosts, the previous
> frequency value may not be reset and could lead to host being unable to
> compensate the offset with timecounter adjustments. To avoid such state
> reset the hardware frequency of PHC to zero on init. Some refactoring is
> needed to make code readable.
> 
> Fixes: 85036aee1938 ("bnxt_en: Add a non-real time mode to access NIC clock")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> 
> [...]

Here is the summary with links:
  - [net,v4] bnxt_en: reset PHC frequency in free-running mode
    https://git.kernel.org/netdev/net/c/131db4991622

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


