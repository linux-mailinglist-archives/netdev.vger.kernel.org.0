Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF6F617911
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiKCIuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiKCIuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80EF2728;
        Thu,  3 Nov 2022 01:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61578B82699;
        Thu,  3 Nov 2022 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDF0EC433D7;
        Thu,  3 Nov 2022 08:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667465417;
        bh=hNYYUHUeRrH0biXVBnOC5WH0jPqtMBwiVKVI9oXdXSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qKpsGPricWIgiqWQSEE7Tu2TOrl3twS6T/smo/cLQTFI4oJQPLdpKcwhqmZ8UY2TE
         nP1qCP2MxGobxKmB7y1gXviQgV6LiVszPM6S7sKo4Z7T3DqtjxwiBtiHQynw8ewm8K
         lMamujtzupQ/JosJZibym2nuoP7UjMh2+EhJ9hkghIuWu/HYItnP+RShre1nwFu9Dt
         oNwvQpC9aVGr8fm8jyw/+RApEaNM37+yKS7sfFSJ0jHLdhfFHWS7hygUhgPKlahAyj
         ZKWQpfyb+G2ovIAU9dZr7gvj8GXiotl1ik7aOZfxn+hXAhpSxwWdS/qGXMrXnS5VY4
         mQCrAV5vQlUYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4611E29F4C;
        Thu,  3 Nov 2022 08:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tun: bump the link speed from 10Mbps to 10Gbps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166746541686.6951.1433827394608127777.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 08:50:16 +0000
References: <20221031173953.614577-1-i.maximets@ovn.org>
In-Reply-To: <20221031173953.614577-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 31 Oct 2022 18:39:53 +0100 you wrote:
> The 10Mbps link speed was set in 2004 when the ethtool interface was
> initially added to the tun driver.  It might have been a good
> assumption 18 years ago, but CPUs and network stack came a long way
> since then.
> 
> Other virtual ports typically report much higher speeds.  For example,
> veth reports 10Gbps since its introduction in 2007.
> 
> [...]

Here is the summary with links:
  - [net-next] net: tun: bump the link speed from 10Mbps to 10Gbps
    https://git.kernel.org/netdev/net-next/c/598d2982b111

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


