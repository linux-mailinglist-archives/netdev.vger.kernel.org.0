Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8F652D0B0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiESKkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiESKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50DEAE25A
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C015B823E4
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CB09C34116;
        Thu, 19 May 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652956812;
        bh=4FEdEWRuOdr7k41fBwo5nfNNGfeljGaxYXwWJCLWAF8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hgy77+fEbPpjLRiIeK3nCc2ZQoXQ8oC1nlyUfpaqEEopBMOF5p2dsKZBpjzVtT5fz
         QbiHJsf7yqnarf02T6uxnrQkrVR26OGATbduWfUFdKvpaoPxHgVmea420H1FSec24k
         C3tu4BgUuFiUeh1BHh5uv6qUH4KCnv8t7DsCw4kcX93vvieKRBrYHfILqyP9N8shLX
         TxgR2rsOqwdA2YQiPR1DiiSCCXVpasHoQlyy3bLgMxaqeMH6M2Bh5lLJfXM/OvBxon
         cKK8LMXfj5ekR3ltgurHn2k/QVwOoxO691gtEqEjR03voA2J2/keesJjB/vBzYXB1d
         oxCjSZ/FD+MmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1ADBEF0389D;
        Thu, 19 May 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] tls: Add opt-in zerocopy mode of sendfile()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165295681210.17580.257718671549894067.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 10:40:12 +0000
References: <20220518092731.1243494-1-maximmi@nvidia.com>
In-Reply-To: <20220518092731.1243494-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        pabeni@redhat.com, borisp@nvidia.com, tariqt@nvidia.com,
        saeedm@nvidia.com, gal@nvidia.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 May 2022 12:27:31 +0300 you wrote:
> From: Boris Pismenny <borisp@nvidia.com>
> 
> TLS device offload copies sendfile data to a bounce buffer before
> transmitting. It allows to maintain the valid MAC on TLS records when
> the file contents change and a part of TLS record has to be
> retransmitted on TCP level.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] tls: Add opt-in zerocopy mode of sendfile()
    https://git.kernel.org/netdev/net-next/c/c1318b39c7d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


