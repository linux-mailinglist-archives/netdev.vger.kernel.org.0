Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E394AE94A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiBIF15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbiBIFUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81D0C03C19B;
        Tue,  8 Feb 2022 21:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFC92B81ED5;
        Wed,  9 Feb 2022 05:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A665C340EB;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384033;
        bh=bSTFqW/HSnU4ZikSddVpkVuvsasCEOdbYA6/jcF6L/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DNQgY1WRUzncWa3YxZMC2/F/TJWqMHjlJ/b8oprufJe/Lw7pjxwVDaJXgbfCOb4Hg
         TF0MDQga8+KVINjNvQLhHipw1/zgMYZ0d0jxcLTE0XuFgvxvfz4GxQX5SvMnZnMXAz
         mVY8rwxi4kVkeZ8k1/45SQKd84fFb6MRTSdKmQzppJdygAYIWRWXWXv2ferIoIFDUQ
         s0afoEiww7wdqknfGlH8J6C41D2TJWHkZ/dEtmd4oXIsMeEXSgmU5lCMjEDQ+jvxK3
         yn1ht2NvSwthaSWRMmX114WhPjLzSAwDB7CloRqvHFl01FNE1OON+zVYwPslrOHCrx
         IERiLtoLZSvBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A528E5D09D;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 1/6] ptp_pch: use mac_pton()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438403336.12376.2798786588740408075.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:33 +0000
References: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Feb 2022 23:07:25 +0200 you wrote:
> Use mac_pton() instead of custom approach.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v2: no changes
>  drivers/ptp/ptp_pch.c | 41 ++++++++++-------------------------------
>  1 file changed, 10 insertions(+), 31 deletions(-)

Here is the summary with links:
  - [v2,net-next,1/6] ptp_pch: use mac_pton()
    https://git.kernel.org/netdev/net-next/c/4e76b5c11d25
  - [v2,net-next,2/6] ptp_pch: Use ioread64_lo_hi() / iowrite64_lo_hi()
    https://git.kernel.org/netdev/net-next/c/8664d49a815e
  - [v2,net-next,3/6] ptp_pch: Use ioread64_hi_lo() / iowrite64_hi_lo()
    https://git.kernel.org/netdev/net-next/c/d09adf61002f
  - [v2,net-next,4/6] ptp_pch: Switch to use module_pci_driver() macro
    https://git.kernel.org/netdev/net-next/c/3fa66d3d60b9
  - [v2,net-next,5/6] ptp_pch: Convert to use managed functions pcim_* and devm_*
    https://git.kernel.org/netdev/net-next/c/874f50c82e14
  - [v2,net-next,6/6] ptp_pch: Remove unused pch_pm_ops
    https://git.kernel.org/netdev/net-next/c/946df10db670

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


