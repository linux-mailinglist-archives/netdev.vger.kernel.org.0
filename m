Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB5F4F1F19
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbiDDW0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239598AbiDDWYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:24:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851039802;
        Mon,  4 Apr 2022 14:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 627E9B81A3C;
        Mon,  4 Apr 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFB33C340F2;
        Mon,  4 Apr 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649109012;
        bh=apcdBOwPSwlNDjpKpm9MrbnDJAMsqs6n+Z5ahNlaoS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k7UuwIFqDgkAatyuvtsUJmuVhxg4yUk6lp4wvP4f8b19XNxcWWkSzc0KWehxfKZQm
         o+pPC0HPl3qA94PDam8ceCO6Bcjs26A4cftO9kt+hlBvPkjqEEc9y5fkxyH1y31weB
         lsWUic+ONm8AT/LaR/URTMvQWErfIiNQanLlPochd3TvTVYQp2wT6wyd3TG00Nlr30
         /kv93yKpDP3NXmQzhOPKyvdLdrYTRBciow7u9f5ZEXJ2/VaB+vfbh+54ojppZSidwO
         Fzn5VjWl2voAXMk6zZrrU9/gxslGy1M8E/lW1wOOV184Pg4WqSVCUp3Bzfxubd9NQZ
         8RSmXXM8LkagA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACD5CE85B8C;
        Mon,  4 Apr 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] sample: bpf: syscall_tp_user: print result of verify_map
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164910901268.3906.17789076980869665552.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 21:50:12 +0000
References: <1648889828-12417-1-git-send-email-chensong_2000@189.cn>
In-Reply-To: <1648889828-12417-1-git-send-email-chensong_2000@189.cn>
To:     Song Chen <chensong_2000@189.cn>
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

On Sat,  2 Apr 2022 16:57:08 +0800 you wrote:
> At the end of the test, we already print out
>     prog <prog number>: map ids <...> <...>
> Value is the number read from kernel through bpf map, further print out
>     verify map:<map id> val:<...>
> will help users to understand the program runs successfully.
> 
> Signed-off-by: Song Chen <chensong_2000@189.cn>
> 
> [...]

Here is the summary with links:
  - [v2] sample: bpf: syscall_tp_user: print result of verify_map
    https://git.kernel.org/bpf/bpf-next/c/35f91d1fe106

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


