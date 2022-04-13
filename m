Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385AB500276
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 01:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiDMXWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 19:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239255AbiDMXWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 19:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919CB23BC5;
        Wed, 13 Apr 2022 16:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4426EB827B6;
        Wed, 13 Apr 2022 23:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED42CC385A8;
        Wed, 13 Apr 2022 23:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649892012;
        bh=5R/Ql6nUWlubaSJoDrexvl54CKfH/1QZCH5YDJ2gAGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L0ZqrdTuTDyTVuvZPWS41CI7OLHbUO5yRXEjpErM6XDh3F6b5TcvIzcatHhJG7Pgc
         pxefgYVJFJK81C+5Qz6sDENGvKNIc8+rcF6b7Xt5to2UIXEqDp/iHlf73jYfHmWVJ4
         gLAtm8XFujVAaUPbagxasRYJLi+Str1MpZewZf1ns56+dK0io3+Qafpw+D+Isq+snP
         6cMMYXEfgD9DK7QItH21YMP4btSH0zyQ3GP8BHs6F8had8kTXP91sIutan70oNRftw
         nkBcMY0rapHOV5NTyJ0Mo4MJMq7M7RzNIAxYDnGwdmDm4cruvcyR7QeE/3TGVXkClW
         88ndNGXVK44eQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0B5DE8DD5E;
        Wed, 13 Apr 2022 23:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: remove unnecessary type castings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164989201185.8845.18106759702805707773.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 23:20:11 +0000
References: <20220413015048.12319-1-yuzhe@nfschina.com>
In-Reply-To: <20220413015048.12319-1-yuzhe@nfschina.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 12 Apr 2022 18:50:48 -0700 you wrote:
> remove unnecessary void* type castings.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  kernel/bpf/bpf_struct_ops.c | 4 ++--
>  kernel/bpf/hashtab.c        | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - bpf: remove unnecessary type castings
    https://git.kernel.org/bpf/bpf-next/c/241d50ec5d79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


