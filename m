Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D2F4EA517
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiC2CV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiC2CVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:21:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BFB26AE5;
        Mon, 28 Mar 2022 19:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52775612E7;
        Tue, 29 Mar 2022 02:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D874C34116;
        Tue, 29 Mar 2022 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648520412;
        bh=7tCMCMPuUQttg9oTD+WAEzEg653WkNq0hmSvOYen7V8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=caMxr6fDV4u+cSaPojbk6/qE+Z/UZNfMD97IBPB8837y7t2BFO2lUDw9mKxUd5sWC
         qfEANuTKQCL+lfL4uVeTWVTz/gvV6K4/I3z+3N5S3RkiG6H29vvdqqOmeSwhtTgL4r
         cB6fVmfku5GytF6CKaK0EHL+S/NsdmSD6eP1G69Y0HqpFoIGvwSkK54Fo+R+Gz0ymc
         Y7MKJB0WxfuNj0TQHAev/lz/ERd05o4teaSw5yJNXiYFjsUGsu9fWoP0Qu2H7RDewe
         MpU8mXYG2qjNEKXvSLB6HcZZYQwcTow8+M4cVyeLxqwQzd+M208xukow19uRXmouVi
         K2qmzuOL6sc4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D707F0384C;
        Tue, 29 Mar 2022 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix maximum permitted number of arguments check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164852041251.3757.17634633994890271955.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Mar 2022 02:20:12 +0000
References: <20220324164238.1274915-1-ytcoode@gmail.com>
In-Reply-To: <20220324164238.1274915-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
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

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 25 Mar 2022 00:42:38 +0800 you wrote:
> Since the m->arg_size array can hold up to MAX_BPF_FUNC_ARGS argument
> sizes, it's ok that nargs is equal to MAX_BPF_FUNC_ARGS.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf: Fix maximum permitted number of arguments check
    https://git.kernel.org/bpf/bpf/c/c29a4920dfca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


