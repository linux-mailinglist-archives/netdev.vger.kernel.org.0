Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1F26C3226
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCUNAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCUNAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EC31D936
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EBE61B87
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 837A9C433D2;
        Tue, 21 Mar 2023 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679403617;
        bh=i7Lt2yBcxqqjRBBkoZc9EgRf9ra0FqEFqfjEvCSEiIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZnjZcpHybebHOenZ20j94c1EC/AbTYsPkMhkv8jjhtL90bGiDv8lhok7bDhR5enO8
         9rWM88s63B5W7NcOBNcLZLXtOYmWpjIGMWGQYu1Je2qVmbTzmoR7tQcborX8xYvKFs
         G2qSJiXRtsHq+MSAXW0wNLrpKSeB9Fg/YGBvgCQvkDW26VZAvJmuJA/2Cf26IQ5rJ0
         61UooAxQRS2EaqqITiXufXtkOZ53DsnUOogjH22tY3DoKgYrEvEv0BCy9LKnjY9KBf
         qwKU3PVz8B4RHrS3GjKVoLpbsa7dh+kPRdUSRH+ZKWgpkXXo7nB3zWOBmngP1gWvA7
         D/H38/TqyLkDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EEE2E66C98;
        Tue, 21 Mar 2023 13:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pasemi: Fix return type of
 pasemi_mac_start_tx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167940361744.508.4471214158276958650.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 13:00:17 +0000
References: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
In-Reply-To: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 19 Mar 2023 16:41:08 -0700 you wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> warning in clang aims to catch these at compile time, which reveals:
> 
> [...]

Here is the summary with links:
  - [net-next] net: pasemi: Fix return type of pasemi_mac_start_tx()
    https://git.kernel.org/netdev/net-next/c/c8384d4a51e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


