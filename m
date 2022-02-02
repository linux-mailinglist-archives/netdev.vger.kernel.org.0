Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6AF4A6EB8
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245554AbiBBKaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245479AbiBBKaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB75C061714;
        Wed,  2 Feb 2022 02:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25275B83080;
        Wed,  2 Feb 2022 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D45BEC340EC;
        Wed,  2 Feb 2022 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643797810;
        bh=2iKggoFWP/pSFvThOv+1gXnfFM0EtBmGzMus01UuI24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AvSa/dLF5Mi8+UFEKiUVXHrguSC6NkOZt4bmd80Dts1gKhXy76vo1+2BykMVrIFj2
         fq2nknrq+mKK5PiXjXgMyqBt7Mv61YIrBDquDQnFAp9kA0GlqjBC7JVlZ/GbXSuU08
         syqyIE+CDMyFEJJhYDV1/GUZS1YWQrU8lj7mESsXru+J/R4N+sgJ1bB8VihrJka9xS
         fmepolvx6QAzjm6zJ8E+/pB5GkMLTd70EHsSHflAhqKDW+aI3p4oNGDhp08Fwws0yS
         Bw9scZ24GR8Q3oj6CJWfDFGxoPr82q/qgwM9Jkv2dv0rcCziP3ZNG7GZj1VXaZXwEq
         EgdJFkPpofAhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7038E5D07E;
        Wed,  2 Feb 2022 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y +
 CONFIG_DEBUG_INFO_BTF=y
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164379781074.22256.810100339582105585.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 10:30:10 +0000
References: <20220201205624.652313-1-nathan@kernel.org>
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  1 Feb 2022 13:56:19 -0700 you wrote:
> Hi all,
> 
> This series allows CONFIG_DEBUG_INFO_DWARF5 to be selected with
> CONFIG_DEBUG_INFO_BTF=y by checking the pahole version.
> 
> The first four patches add CONFIG_PAHOLE_VERSION and
> scripts/pahole-version.sh to clean up all the places that pahole's
> version is transformed into a 3-digit form.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
    https://git.kernel.org/bpf/bpf-next/c/f67644b4f282
  - [bpf-next,2/5] kbuild: Add CONFIG_PAHOLE_VERSION
    https://git.kernel.org/bpf/bpf-next/c/613fe1692377
  - [bpf-next,3/5] scripts/pahole-flags.sh: Use pahole-version.sh
    https://git.kernel.org/bpf/bpf-next/c/2d6c9810eb89
  - [bpf-next,4/5] lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
    https://git.kernel.org/bpf/bpf-next/c/6323c81350b7
  - [bpf-next,5/5] lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
    https://git.kernel.org/bpf/bpf-next/c/42d9b379e3e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


