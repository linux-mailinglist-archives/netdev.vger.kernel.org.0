Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5235513B08
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349309AbiD1Rne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiD1Rnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:43:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2519813E1B
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8584F6216B
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 17:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBFCBC385AE;
        Thu, 28 Apr 2022 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651167611;
        bh=/YR6KqTh11TqGz6WY5n2BvWvlL3dOLpquOKMsovQ3ac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KTqEFQ+aA4LJrRai9Xw5DKWqLJU1Nf8r5JuVOG7Atk5229dBmR5VCeYtpgWA/K4ag
         ORqi0a280yXYlehg4NMxe8JD1ay2PS2UmZIA3BSw8p0T4NaNjFwv/awvGaVuDjhf+F
         aaJDFH2AdJXZkGtKwRjfWypBQD2c1P/qbtj65VosI7vPddYZ9esbA1U/JPpaYlxHWr
         PAPDDjutze9Ejbd5YzWiAB6rReiiiCGCBSkubfMFKpbzyL2iyPmXB/usBqt2n9zsqK
         LHbksxX4T0efLjVW67uM35JdyvQSk7QcQl5VWc1J3IWG5qGYR/EJbeZQ83ogPwqSjC
         xEj1Qg4JXfJ9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDB35E85D90;
        Thu, 28 Apr 2022 17:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix F-RTO may not work correctly when receiving
 DSACK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165116761177.10854.18409623100154256898.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 17:40:11 +0000
References: <1650967419-2150-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1650967419-2150-1-git-send-email-yangpc@wangsu.com>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     edumazet@google.com, ncardwell@google.com, ycheng@google.com,
        netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Apr 2022 18:03:39 +0800 you wrote:
> Currently DSACK is regarded as a dupack, which may cause
> F-RTO to incorrectly enter "loss was real" when receiving
> DSACK.
> 
> Packetdrill to demonstrate:
> 
> // Enable F-RTO and TLP
>     0 `sysctl -q net.ipv4.tcp_frto=2`
>     0 `sysctl -q net.ipv4.tcp_early_retrans=3`
>     0 `sysctl -q net.ipv4.tcp_congestion_control=cubic`
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix F-RTO may not work correctly when receiving DSACK
    https://git.kernel.org/netdev/net/c/d9157f6806d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


