Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BEA6373C7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKXIUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiKXIUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9891BEAD2;
        Thu, 24 Nov 2022 00:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC495B825F3;
        Thu, 24 Nov 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C92BC433D7;
        Thu, 24 Nov 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669278016;
        bh=X32JTPYRJMxhErnYPnzKq45BMq7dyhDObQUBJXOiB6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h58r5Q8pkQgZq4oyQqbXc4foVpZGGR+OjqFzH87a/pw95nGjyWsohTQ/XqanAJKEA
         +X5DNge0zMIfi90kYTFGFTemaFIx1Nr+lup0+1upTlJobB5SaY6bImW98VDfauP6+Z
         pM0qYkQu7ob+SulAyenllQhRZAGYo3+QsE+rkrNUKLNFl2kwxJqL9ma1sXxcIE8XKF
         xyJc5dDHG1RqhknvbmSUPWigTcaYLQjmZsu/lCpZKYlaPW0MjGmBs3sDmPb9M66PF/
         73HPveNhjI85Z0WAHktWxptU/md2RVv5ADpli/Lu/5xLbrkVVSkAocXHppGiUbYw69
         XxuOUnK/7vtqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E0CFC5C7C6;
        Thu, 24 Nov 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: t7xx: Fix the ACPI memory leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166927801631.21134.5563511038557206086.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 08:20:16 +0000
References: <1669119580-28977-1-git-send-email-guohanjun@huawei.com>
In-Reply-To: <1669119580-28977-1-git-send-email-guohanjun@huawei.com>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     chandrashekar.devegowda@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Nov 2022 20:19:40 +0800 you wrote:
> The ACPI buffer memory (buffer.pointer) should be freed as the
> buffer is not used after acpi_evaluate_object(), free it to
> prevent memory leak.
> 
> Fixes: 13e920d93e37 ("net: wwan: t7xx: Add core components")
> Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: wwan: t7xx: Fix the ACPI memory leak
    https://git.kernel.org/netdev/net/c/08e8a949f684

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


