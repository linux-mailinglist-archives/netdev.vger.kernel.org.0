Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED844F87B8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 21:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiDGTMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 15:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiDGTMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 15:12:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A1617E36;
        Thu,  7 Apr 2022 12:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B00CCB82979;
        Thu,  7 Apr 2022 19:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63C19C385A0;
        Thu,  7 Apr 2022 19:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649358612;
        bh=hBd815vHLe1VUTlBg62x1qBzYqrJi14WHZY28x9o0AQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4Wy6N3/7GnB2H7/Vyf5Fw1jZeaFUtNHCd4UT9//3+1eT3bEp5E7hLiTSIL4cKh1L
         AMF8PDmMs0lZ49vEQY41y8Ftxki00gnaT2NpUxEoLxf+oksukIdcm1NCT8AO6YPMNJ
         M2eO0qyfhYtNm1L7X2xefkAKrQV+3Cku211mLMGno/iRGt3Xqc3jMk+exJiHIaQQLB
         8m9GCcu+fYgKpXsKQgTZDfOMAQowcaM5Dsxcyvg48XLnOMcfyctogULsryUC2KXirq
         xVMVzI89Kswj3Q+FOxDIhbyWxZTgjpUuk2cQDdgFv71vDelkSUM1TdDhqmDJ+L4xVJ
         gXmOkKDNSynBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 452BAE85D53;
        Thu,  7 Apr 2022 19:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: potential NULL dereference in
 usdt_manager_attach_usdt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164935861227.15263.23714590437746578.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Apr 2022 19:10:12 +0000
References: <1649299098-2069-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1649299098-2069-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 7 Apr 2022 10:38:17 +0800 you wrote:
> link could be null but still dereference bpf_link__destroy(&link->link)
> and it will lead to a null pointer access.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  tools/lib/bpf/usdt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - libbpf: potential NULL dereference in usdt_manager_attach_usdt()
    https://git.kernel.org/bpf/bpf-next/c/e58c5c971746

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


