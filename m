Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9C7569858
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiGGCuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiGGCuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A0D2F3B9;
        Wed,  6 Jul 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA4E0620D1;
        Thu,  7 Jul 2022 02:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16CB4C341CA;
        Thu,  7 Jul 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162214;
        bh=XnQK+eECpSZ3e/MV59t4zcybku2jGtfF2yLmp9tJmu4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=miV66brl/WVnGDjly/OQG1OU9EAtjYV1owEwJA4PUaM7mp2902LxMLnNV3uDuOfNl
         GcvbN5uPSKQpzZ2PG1WAgT9eT8zCDnJsV4utXLOIR6gooTVf1E4XHvBvriPHHBI87H
         hai5OMAcX9SaB5h7fbX34zdH7vn/y7RtWesQ/z/+Ku9X/PRAj3/+QffJ/QFAaVurbO
         335/BATyx+YdR67PmqNbsB/DAczrCondHV0IwTCiqNmXSjKwAm6rVBv3WUl7rgb+W7
         /d6xi+8hgsJXtzJTU2dWmFCe7pYQt6unFIx0SBFep56vsbfK9dmL3jeRPhBT0vI5T5
         IBa7PqdLnDZLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3705E45BDE;
        Thu,  7 Jul 2022 02:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3] usbnet: fix memory leak in error case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716221399.6818.11575624289125230749.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 02:50:13 +0000
References: <20220705125351.17309-1-oneukum@suse.com>
In-Reply-To: <20220705125351.17309-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Jul 2022 14:53:51 +0200 you wrote:
> usbnet_write_cmd_async() mixed up which buffers
> need to be freed in which error case.
> 
> v2: add Fixes tag
> v3: fix uninitialized buf pointer
> 
> Fixes: 877bd862f32b8 ("usbnet: introduce usbnet 3 command helpers")
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv3] usbnet: fix memory leak in error case
    https://git.kernel.org/netdev/net/c/b55a21b764c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


