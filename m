Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8D5EBE08
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 11:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiI0JKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 05:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiI0JKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 05:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E796E6D9DB;
        Tue, 27 Sep 2022 02:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 842FB61765;
        Tue, 27 Sep 2022 09:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE02EC433D7;
        Tue, 27 Sep 2022 09:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664269813;
        bh=HrqAsjtCCTfOpqKuvarQVRgA4LgzPa5pLIthBQL0w4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eqz95eD0M413YvOzO6hwpWmdEDNsg9EQJFGafeFrB8Ie+qphV/94yic/FDdawLRbA
         Nc+STwFUYilAeiw19IavixMKuDB7dOLxqr8M5RaadJDge/Q7S0ZWVYScDG2L8gJH2n
         3Pxx35Vqk9u7MbUuMPVvVklRsV89iN+IL7L6dsjqCGlbpR6dBMAkhTXlLYoV8bZCWX
         V+Kiq9+Wyh7DHrO4DS3nmU9d0kiZOjgmUweTMEoforSRZ9J+H7kkxkuVCqhIgcY19P
         mzlkmEZ+91HSi8ZLLohe/bfFj1FOL7da4FPKig8zMqmTzsuI2p3eamxrWCW8UH2iyl
         +lM4Ly4WU7/NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2925C04E59;
        Tue, 27 Sep 2022 09:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2] selftests: Fix the if conditions of in
 test_extra_filter()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166426981379.9788.6307412483003792088.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 09:10:13 +0000
References: <1663916557-10730-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1663916557-10730-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 23 Sep 2022 15:02:37 +0800 you wrote:
> The socket 2 bind the addr in use, bind should fail with EADDRINUSE. So
> if bind success or errno != EADDRINUSE, testcase should be failed.
> 
> Fixes: 3ca8e4029969 ("soreuseport: BPF selection functional test")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
> v1 -> v2: add a Fixes tag
>  tools/testing/selftests/net/reuseport_bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,v2] selftests: Fix the if conditions of in test_extra_filter()
    https://git.kernel.org/netdev/net/c/bc7a31984489

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


