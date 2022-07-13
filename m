Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D135572C04
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiGMDuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiGMDuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EF3D9145;
        Tue, 12 Jul 2022 20:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 111FFB81D08;
        Wed, 13 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5808C341C0;
        Wed, 13 Jul 2022 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657684213;
        bh=7o+Dw3QCs29lyvv4dtq9cP9AotkGGFdSoaS6NoC1F78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=slReMfb7M0vhzJ08BJN2MTvm+O2Sf4a4pPTUg28wZx+KoD+WU8cOE+4caE7zoC097
         qZ9F8MnmrWmYdm+qr1S8bq7CSlQt5j4xYiJr4JighWeMiYGTXhqeJDlvLET5Jt8l42
         gaXgAna4sRYkBo8GVkHEFD/F9FNpe7JBQCZYZEbIHkgBpc7Le/+IrmZs2l8Cyap/IF
         epI74ucDRKQl0P3RtReAUvT9fSct3NNGK+TwTZ1uXB3496hdIM3+A64Hc+Y1mzeSbI
         CUKUVCCrwhGynj9ZRdAFZyh5cXSVRzY18GJaQ4KxOvII7pLkOvV3a6Uvt7G2c+wjRE
         G45hf5velqdEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84E20E4522F;
        Wed, 13 Jul 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlogic: qed: fix clang -Wformat warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165768421353.12868.15963909501579730055.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 03:50:13 +0000
References: <20220711232404.2189257-1-justinstitt@google.com>
In-Reply-To: <20220711232404.2189257-1-justinstitt@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Jul 2022 16:24:04 -0700 you wrote:
> When building with Clang we encounter these warnings:
> | drivers/net/ethernet/qlogic/qed/qed_dev.c:416:30: error: format
> | specifies type 'char' but the argument has type 'u32' (aka 'unsigned
> | int') [-Werror,-Wformat] i);
> -
> | drivers/net/ethernet/qlogic/qed/qed_dev.c:630:13: error: format
> | specifies type 'char' but the argument has type 'int' [-Werror,-Wformat]
> | p_llh_info->num_ppfid - 1);
> 
> [...]

Here is the summary with links:
  - qlogic: qed: fix clang -Wformat warnings
    https://git.kernel.org/netdev/net-next/c/b6afeb87ad29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


