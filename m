Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5640B6A56C4
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjB1Kaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjB1Kai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AD82E81A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DACE61024
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 10:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F600C4339C;
        Tue, 28 Feb 2023 10:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677580217;
        bh=d+W6JZQ2/hXBDb+TaqkwcIFgj9f/iBbnds+nG9msrkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WSBG0Bnga6ZuLdYtTv4qppHVZGCsftXBZX93+Yi4X6uW//1P0D3ZD+/w0ziTQegXG
         vGRWX1XGH5I0dQz0rnKH2F/gzrO0WFd92+o9UBW4l2fGiJ8BS7SOxluHuh6BfbpJjv
         Wyt5UCRA1z9Fc/l97F6Urv9dSR0X+qNAP/9uliKaAgw6IXrao5Yq3fI/ElAixMMBIx
         0qV72n/0h0Di4ynG/8BRGAqXxyub81s+u5U1CFIB7lfS4wHvKXkc9HWkJUuxm/4AwP
         uawlqhENlMvJpIB+4NoBiQxSO1iZOoQv+pQYgGW387SRP/rktU44tUxJhK0gCzp6oo
         rmGqZIKkAhNfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FF5CE68D34;
        Tue, 28 Feb 2023 10:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167758021751.31836.16273509568066949578.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 10:30:17 +0000
References: <20230227091156.19509-1-zajec5@gmail.com>
In-Reply-To: <20230227091156.19509-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arnd@arndb.de, f.fainelli@gmail.com,
        jon.mason@broadcom.com, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, rafal@milecki.pl,
        jdmason@kudzu.us
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Feb 2023 10:11:56 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> While bringing hardware up we should perform a full reset including the
> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
> specification says and what reference driver does.
> 
> This seems to be critical for the BCM5358. Without this hardware doesn't
> get initialized properly and doesn't seem to transmit or receive any
> packets.
> 
> [...]

Here is the summary with links:
  - [net] bgmac: fix *initial* chip reset to support BCM5358
    https://git.kernel.org/netdev/net/c/f99e6d7c4ed3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


