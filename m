Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04094FC7C3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244079AbiDKWma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiDKWm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:42:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5315B1CFFD;
        Mon, 11 Apr 2022 15:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBA49B81999;
        Mon, 11 Apr 2022 22:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BB9EC385A3;
        Mon, 11 Apr 2022 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649716811;
        bh=EqPr3eaKwSvay7nBktB9TAed+U/S+CSGOJ43QdASMoA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R1ut5HwmRpb7dJcQW5HPfLezxY8fuiEQ/RIRhwLVMztXZOpLnrt+XY2mCS3HHodjb
         xIRJuBn5S3ZilorIB45gG4bNKWjbsrfxhhRnilXN7GvzkcqWCQAJfhCUA9Ogjb3QWf
         GHbhW2zPVI4R1Ct8MPxSj6HZeLkGwdLxvbPn3+a+lk7WX1oqZeadUTeU3M8zT0Z0T3
         NslNykboYsMfTPZ2d2yJMgT59D89CD947rogvSuKkBf6+S1uCXJsMNxDQpqEvba7vg
         +lezahUkc4hVMmCYbRnI4dj9rscxEqzajaw8aC2Nmjs3IT+ANj3V921vtInmXF8JVi
         z82HrbxrMvsOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F368E85B76;
        Mon, 11 Apr 2022 22:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] libbpf: usdt aarch64 arg parsing support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164971681145.17829.8903474117381404711.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 22:40:11 +0000
References: <1649690496-1902-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1649690496-1902-2-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        iii@linux.ibm.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Mon, 11 Apr 2022 16:21:36 +0100 you wrote:
> Parsing of USDT arguments is architecture-specific; on aarch64 it is
> relatively easy since registers used are x[0-31], sp.  Format is
> slightly different compared to x86_64; forms are
> 
> - "size @ [ reg[,offset] ]" for dereferences, for example
>   "-8 @ [ sp, 76 ]" ; " -4 @ [ sp ]"
> - "size @ reg" for register values; for example
>   "-4@x0"
> - "size @ value" for raw values; for example
>   "-8@1"
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] libbpf: usdt aarch64 arg parsing support
    https://git.kernel.org/bpf/bpf-next/c/0f8619929c57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


