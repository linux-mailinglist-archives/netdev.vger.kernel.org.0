Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0E4F53CB
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574214AbiDFEXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584007AbiDEX5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:57:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B067E15AAFF;
        Tue,  5 Apr 2022 15:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F891B81FF1;
        Tue,  5 Apr 2022 22:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A36FC385A5;
        Tue,  5 Apr 2022 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649196613;
        bh=413WPoWJxK5FtCbvBY6deUOHmDqE/X/cMye095WXlJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pzEjk5eE/E87tq1YG8HsafcBcz62Q1wvTmKmIUP+FNmKKuLYixYDn8qiS2XzHLbW/
         vTltkqQxNSSeAFM7ZfXvjGbtMsAA67hIGf5DsgRRXQ4qL/msicIPLsgEl/57MUzkRT
         AT/q0aqgiLXv89xPAbBUB6/r7OFpfXA8w8+2dOKX3RTNeYg78NmSPZw3r5xXIFtsuU
         fxaT46sJ5L0aNYcGVh+NPdKkojXC7a8wCuILGAfK/NkBSuRwIkYl36Y2+c0uBttL3c
         qOHZMj2H+Ontnsz6Gd5dt+vDMuqtQ+yYgaGuqqAodYdKJSTuBFYSS2GjGkA1C7l7lY
         XOX4Hxf0/aS8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B9A5E85BCB;
        Tue,  5 Apr 2022 22:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf, arm64: Sign return address for jited code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164919661303.14188.16221204846341071276.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 22:10:13 +0000
References: <20220402073942.3782529-1-xukuohai@huawei.com>
In-Reply-To: <20220402073942.3782529-1-xukuohai@huawei.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
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

On Sat, 2 Apr 2022 03:39:42 -0400 you wrote:
> Sign return address for jited code when the kernel is built with pointer
> authentication enabled.
> 
> 1. Sign LR with paciasp instruction before LR is pushed to stack. Since
>    paciasp acts like landing pads for function entry, no need to insert
>    bti instruction before paciasp.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf, arm64: Sign return address for jited code
    https://git.kernel.org/bpf/bpf-next/c/042152c27c3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


