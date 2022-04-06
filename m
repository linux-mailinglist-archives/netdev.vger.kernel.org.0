Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1D24F6A62
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiDFTvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiDFTuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:50:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4362E216A56;
        Wed,  6 Apr 2022 10:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6C15B824E6;
        Wed,  6 Apr 2022 17:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FAAAC385A3;
        Wed,  6 Apr 2022 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649265612;
        bh=Mo8HirllIynk/z8CgfkYFr8U2nZhqSzLoJnSPMEkdKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PeKFiO72mWGWyUeFzVUOvAhDJ1IQt8fp0nSbB/BY5edlC2n4AiR1okEfvfImJtCbD
         7oSEsIeAzWcfiItk+Okk0aEiMFwaXWlitF1IXmvJi3TfzsfawdqV1rkhORDa3GIU1A
         S/8WZdgi8lBDW6MLjNBBDzMaJROw3COQJnhTTLBBgaD30S8ZoYdt/1e6mAwIbal+R+
         f029O143joNsXcBWh7EpaBUTTkinQhSIdrrBuMSrJuMS0kfsx3SELZ56c04ZTLpHOT
         asuEOUdwOCoFA+QAoQk81p082YhCJOhmunmJdwOPe+Uum1xHtoPVKDcy/qlnXz1shJ
         J4sLX+8iF6w7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5252BE85D53;
        Wed,  6 Apr 2022 17:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] libbpf: Fix spelling mistake "libaries" -> "libraries"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164926561233.23950.5713179481350505645.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 17:20:12 +0000
References: <20220406080835.14879-1-colin.i.king@gmail.com>
In-Reply-To: <20220406080835.14879-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed,  6 Apr 2022 09:08:35 +0100 you wrote:
> There is a spelling mistake in a pr_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  tools/lib/bpf/usdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] libbpf: Fix spelling mistake "libaries" -> "libraries"
    https://git.kernel.org/bpf/bpf-next/c/a8d600f6bcd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


