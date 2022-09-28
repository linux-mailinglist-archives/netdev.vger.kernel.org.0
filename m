Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932C65ED80E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiI1InJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiI1IlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D4A9250;
        Wed, 28 Sep 2022 01:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C881B81F12;
        Wed, 28 Sep 2022 08:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23A41C433B5;
        Wed, 28 Sep 2022 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664354416;
        bh=PFpp0GXJncWhj+hTMRYAaVPUKjGFNmtQJ/xlMjoioBs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZKrcrJV/aOX8NUIU0fErUEBM6pHFDabZhU6uDd5H3WgzGl0KYG8g6ef22Y6e4v8xM
         tM5JKdtFqb4aXxR44EbVKYCh5DYFDy0jHd3DOaxdQlU3KjINFbYXSUcBgqOIHvw9k2
         JpZgCPeBhs1p/t7IRsloTs2Y1UNhDhr0BP5XXiSIFfK14Ruxvql8tmE4MSSlmoolFx
         hqRZbbue+RM9kfGpU3nOT8h6eZN+R670Xxe5oQPZyN0zFpNBPQJo9V+9XEznrx9ZNH
         0Tg98kAtfprNHcibmXcrT/nsEzbFgqGkr2/8ng90bOM6EGiz0SvRXD6VSm9ckPzNdF
         Lq2tT4uF6L9HA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0674DE4D035;
        Wed, 28 Sep 2022 08:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: act_bpf: simplify code logic in
 tcf_bpf_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166435441601.12187.11569664957745082198.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 08:40:16 +0000
References: <20220926102158.78658-1-shaozhengchao@huawei.com>
In-Reply-To: <20220926102158.78658-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        martin.lau@linux.dev, daniel@iogearbox.net, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Sep 2022 18:21:58 +0800 you wrote:
> Both is_bpf and is_ebpf are boolean types, so
> (!is_bpf && !is_ebpf) || (is_bpf && is_ebpf) can be reduced to
> is_bpf == is_ebpf in tcf_bpf_init().
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/act_bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sched: act_bpf: simplify code logic in tcf_bpf_init()
    https://git.kernel.org/netdev/net-next/c/8fff09effb07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


