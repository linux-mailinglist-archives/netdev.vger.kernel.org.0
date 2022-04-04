Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED954F1F16
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344730AbiDDW0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238861AbiDDWYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F2F37BDF;
        Mon,  4 Apr 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968836153E;
        Mon,  4 Apr 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBF50C36AE5;
        Mon,  4 Apr 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649109013;
        bh=3FSVR1gaPHw2CpaItXo7Rc3Ul8x+MLb99vUHUHlprxw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RnWJSgbgCVC9haovV7rScJS2xD+f0d8vWJdL0DEPJdZ6tT6act5L85uPhiChdsvUr
         9Jpl02ThHvCdGtMknC57sX66XnOrKxUGToJt1uHGcI43QnsxaQ1CXGi1wdA6zP8VcK
         cd8xFfowGQKk3QGJ8gmLzCUa7fl4qiyL9BNStIbmt6YT8FtK9jw/qhVa6+tCIfh5ir
         XtDdhoFHAsvW0SSi3xxnGgJnE3veY7ri6LsDGyxz2AMcOjvk0LBo2xCzxcqXh/rqz+
         PQEzI7PExyij0w0eQJ8h6GKZdHFk/UxDWE6pecADInqD/XRvb0yLD9c4VybdWWuXJu
         Pf3zTN6lttu9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE0C0E85D15;
        Mon,  4 Apr 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix parsing of prog types in UAPI hdr
 for bpftool sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164910901283.3906.14745115962249131566.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 21:50:12 +0000
References: <20220404140944.64744-1-quentin@isovalent.com>
In-Reply-To: <20220404140944.64744-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, milan@mdaverde.com
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

On Mon,  4 Apr 2022 15:09:44 +0100 you wrote:
> The script for checking that various lists of types in bpftool remain in
> sync with the UAPI BPF header uses a regex to parse enum bpf_prog_type.
> If this enum contains a set of values different from the list of program
> types in bpftool, it complains.
> 
> This script should have reported the addition, some time ago, of the new
> BPF_PROG_TYPE_SYSCALL, which was not reported to bpftool's program types
> list. It failed to do so, because it failed to parse that new type from
> the enum. This is because the new value, in the BPF header, has an
> explicative comment on the same line, and the regex does not support
> that.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync
    https://git.kernel.org/bpf/bpf-next/c/4eeebce6ac4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


