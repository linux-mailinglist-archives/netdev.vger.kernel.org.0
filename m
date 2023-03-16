Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03E96BD77C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjCPRuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCPRuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD918763D8;
        Thu, 16 Mar 2023 10:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C16620D7;
        Thu, 16 Mar 2023 17:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8667C433AC;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678989020;
        bh=1IXcxWId4m5ZRzpBX1tmxoLg5iAm2BUzPQWn6PyukMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Te+7Be4hAlYd+WM38HlB4alVYFTrnK+IyfXpFqcu13FGFFBVVk9BTVlHi663Im9G/
         w1PK4FdIugHxilyUhMg+xSk6060Q5vujYA38HSLBaD9m/FXM7EbdJ65mkdrXDJl2Z0
         FO8QPhobVJJ4dKM0T9vuI2svyZupPwDxznIXao8FSCNqmTAVceOysvYNN0awMZcfUF
         Rzsd1CyXWPXclSUCFbROTvZ185ZrtspUGVm0MnqPNJ7ueHQ5+eBnWivOYJJTwSXH37
         CS8r9bnAPcWaPdzFtfEgpACio8S1d929gnITEIUrBrl4q0qqnLKoPF+HAJNaEVmCCL
         nhW6AdE/ts9mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95399E66CBB;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] nfc: mrvl: Move platform_data struct into driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898902060.2133.11751535560234368439.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:50:20 +0000
References: <20230314201309.995421-1-robh@kernel.org>
In-Reply-To: <20230314201309.995421-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org,
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

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Mar 2023 15:13:08 -0500 you wrote:
> There are no users of nfcmrvl platform_data struct outside of the
> driver and none will be added, so move it into the driver.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/nfc/nfcmrvl/nfcmrvl.h         | 30 +++++++++++++++--
>  include/linux/platform_data/nfcmrvl.h | 48 ---------------------------
>  2 files changed, 28 insertions(+), 50 deletions(-)
>  delete mode 100644 include/linux/platform_data/nfcmrvl.h

Here is the summary with links:
  - [v2,1/2] nfc: mrvl: Move platform_data struct into driver
    https://git.kernel.org/netdev/net-next/c/053fdaa841bd
  - [v2,2/2] nfc: mrvl: Use of_property_read_bool() for boolean properties
    https://git.kernel.org/netdev/net-next/c/cc6d85c1cb5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


