Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208C36BE2C8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjCQILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCQILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:11:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8792D3099;
        Fri, 17 Mar 2023 01:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA6C2B824B3;
        Fri, 17 Mar 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 881ECC433A1;
        Fri, 17 Mar 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679040619;
        bh=hiuS3m/mLqXtP2cO1G1/mmRY4Gv9lYgpUPxVNeQtbnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tQBRH5YkUfB5plPXmOkqf6mZnpby+Ko4xraNFuyhaXAMrD5XZVO8N1X6BjLTmyjE1
         e3PB43eNUoZiCxB8a84CyCxPjKLLeuqG0SGiLPBt2dgBZ4lu+USmKCqlR2ksScO5mH
         DfpLust+40YYYkFWu+rOrY1+sPPql2U8CceevG+oq42K13lG8NfV5USl+Mx7PVKH/9
         fWWENH45IaxUxK17oQZ3omy/6GjZGJkXEtDMopXV9sbVq7B2VZ5KjHT+oxvIBprKlH
         qrLbzP1514XDc3u6d2E4Pbyz5IXkHc43YAf7I03Wyut/Oi/nmPLJThK1i9Fk2zARtz
         be9inMUAFJ48Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6858AE21EE9;
        Fri, 17 Mar 2023 08:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: mana: Add new MANA VF performance counters for easier
 troubleshooting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904061942.2993.10225733131753794874.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:10:19 +0000
References: <1678881313-20468-1-git-send-email-shradhagupta@linux.microsoft.com>
In-Reply-To: <1678881313-20468-1-git-send-email-shradhagupta@linux.microsoft.com>
To:     Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sharmaajay@microsoft.com, leon@kernel.org, tglx@linutronix.de,
        bigeasy@linutronix.de, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, mikelley@microsoft.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 04:55:13 -0700 you wrote:
> Extended performance counter stats in 'ethtool -S <interface>' output
> for MANA VF to facilitate troubleshooting.
> 
> Tested-on: Ubuntu22
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v2] net: mana: Add new MANA VF performance counters for easier troubleshooting
    https://git.kernel.org/netdev/net-next/c/bd7fc6e1957c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


