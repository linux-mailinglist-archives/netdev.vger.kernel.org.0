Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770EE63E64C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiLAAQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiLAAPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:15:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8E3A6B4D;
        Wed, 30 Nov 2022 16:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08BB46192A;
        Thu,  1 Dec 2022 00:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 550A9C433C1;
        Thu,  1 Dec 2022 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669853416;
        bh=qeW6YmCmQEqb5puiAk9WH5DLery8lccNXgOuFI03zO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Js0EapugHS2fDeywvYZUJOLOobJBbkbnJx7zCRl6AQXlqz9V+RQ7t0iCH4fhQTzK7
         IbsCggy2fRRhYVT1JK+/p2ilIREak/irF1HzioaisNLzR5YaBFHXYV/jpoZkMJxY7v
         y/We/rir0r3bUfk4unTbqFNiDscOW4fd0zHzfm1oQCykla///H6HThaNU2/OUBfhRI
         gyxVWHHkVY0fmyj6gpk0qSMpSrlrcVQILDmSruWFrrYZ8gvdK2r5Lrc1y+RwaRsw6A
         /GtyXKG28U6hQH45oNElLfbfe2+jppTEaarHqaOOqAE3zLI5bz28dsU8eKBeAgLi6B
         tjMNk1baIb6FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 393DAC5C7C6;
        Thu,  1 Dec 2022 00:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v3 0/4] bpf,
 sockmap: Fix some issues with using apply_bytes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166985341622.23329.7544317946229323076.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 00:10:16 +0000
References: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 29 Nov 2022 18:40:37 +0800 you wrote:
> Patch 1~3 fixes three issues with using apply_bytes when redirecting.
> Patch 4 adds ingress tests for txmsg with apply_bytes in selftests.
> 
> Thanks to John Fastabend and Jakub Sitnicki for correct solution.
> 
> ---
> Changes in v3:
> *Patch 2: Rename 'flags', modify based on Jakub Sitnicki's patch
> 
> [...]

Here is the summary with links:
  - [bpf,v3,1/4] bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
    https://git.kernel.org/bpf/bpf-next/c/7a9841ca0252
  - [bpf,v3,2/4] bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
    https://git.kernel.org/bpf/bpf-next/c/a351d6087bf7
  - [bpf,v3,3/4] bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect
    https://git.kernel.org/bpf/bpf-next/c/9072931f020b
  - [bpf,v3,4/4] selftests/bpf: Add ingress tests for txmsg with apply_bytes
    https://git.kernel.org/bpf/bpf-next/c/89903dcb3c2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


