Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB986F0118
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243042AbjD0G4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242942AbjD0G4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:56:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3114698;
        Wed, 26 Apr 2023 23:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CFBE63AED;
        Thu, 27 Apr 2023 06:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76907C4339B;
        Thu, 27 Apr 2023 06:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682578563;
        bh=C6DlJnSIVgfRza1lDbmKC4eFjLoL6Dkd0XJsivg/rF8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4MslcA1H4Qfs7UVIn1JhbmUHNUenWdCMzRGBi1uUHgTNUwBUWIe3rfrGZSvSBht5
         /OWuDaB79DBsAZ6CcWfxuqxGng2ovQm1qUnk+nmREQ+yrLLg0bV0Pm4DjznGv8jJ31
         oSMZxfzLc4jUFgbhsWtPtdKLoo0lt0zsdxPnFjG447y0pBuHAWq1ZIE3zKb9+Lz/65
         jRC77rzLhrEu6ePtNqPz3w+2hcLajnYNu1QBbsVu5qZbp/cWGJ+fvdIE4KS+89hqQY
         LMYpusXufqfAeW/gM0LMj3uLgrwr6U7C/2NoIrlezVIEGT12L7POkHQTAhfCQPjTGs
         A1kltaWlPLJmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C49BE5FFC7;
        Thu, 27 Apr 2023 06:56:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 6.4
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168257856337.3333.16600030988253941664.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 06:56:03 +0000
References: <20230426143118.53556-1-pabeni@redhat.com>
In-Reply-To: <20230426143118.53556-1-pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Wed, 26 Apr 2023 16:31:18 +0200 you wrote:
> Hi Linus!
> 
> We have a few conflicts with your current tree, specifically:
> 
> - between commits:
> 
>   dbb0ea153401 ("thermal: Use thermal_zone_device_type() accessor")
>   5601ef91fba8 ("mlxsw: core_thermal: Use static trip points for transceiver modules")
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 6.4
    https://git.kernel.org/netdev/net-next/c/6e98b09da931

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


