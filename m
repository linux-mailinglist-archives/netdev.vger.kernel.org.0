Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E698864A948
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiLLVLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiLLVLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:11:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9121900F;
        Mon, 12 Dec 2022 13:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC5BB80E20;
        Mon, 12 Dec 2022 21:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC747C433EF;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670879472;
        bh=RRlcH87ksVVq5Lt5ulwY/+jO5YHDmOYluWme/dr/tz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ClEVotUG3PjbrXTHgvYqkmNTWkIUrsdglY5SR9fW2NgP0eSbr9NjEc7GyMcjATg4z
         i8wqd6cT7Yd5C26xpOfFM54VvnzED7YOsWt+gGrBdj99irLEDgoqS2YcX1IBqzznG8
         eL1XRLx3I7uELHQhgzldAYFT3lXTdlQCHllOvXeZSabMhduuwlVvO8knxC0aDlP545
         ezf4Qqikc0HVxqStSJ8GD0T/NYkQonptZvDtU/1wnGpNq5lRp6kA3ups6i6CrBBVJp
         c4fMVfVakXo2STIFrr4LjasF/L5ss1fZNezsyD3xWwMQLxk9+bsq1uJGaxL+RvRJQn
         PZcqDaXGHaRQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACE73E21EF1;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH_net-next=5D_net=3A_hns3=3A_use_strscpy=28=29_to_?=
        =?utf-8?q?instead_of_strncpy=28=29?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087947270.28989.12353681511402483668.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:11:12 +0000
References: <202212091538591375035@zte.com.cn>
In-Reply-To: <202212091538591375035@zte.com.cn>
To:     Yang Yang <yang.yang29@zte.com.cn>
Cc:     salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brianvv@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 9 Dec 2022 15:38:59 +0800 (CST) you wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: use strscpy() to instead of strncpy()
    https://git.kernel.org/bpf/bpf-next/c/80a464d83f08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


