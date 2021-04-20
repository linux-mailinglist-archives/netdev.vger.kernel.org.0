Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EC236620A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 00:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhDTWKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 18:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233961AbhDTWKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 18:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 874C161400;
        Tue, 20 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618956609;
        bh=Rz12YJpv+3tROxhp6GWQJ5OtjyFvcDGLYDCngvMK8uA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NE9Swv2daearajWN+nunpNiyXCqAVStHc4nmbTKFZ85ZG8J2MAxlO870hxhIs8ds6
         PRu5VKQ8qerS1zR5sWcEW80xOcfx83upixFS7e9KwdizXpjrkv+shaGq1Kvot9QG3e
         WTIgI1ZTbaAjo98/X4MIlLL1PHerXIucQACEXL2o7WW8OZIzqEtzIXB3qx/uYs3uIj
         ooJxDSrtlhHw9U9jZCWdSK5RojymfRdbvkp/uOIgz+ou/S6yX2Agq3DcGDyCziuM8c
         H9TJyhpjunV0XZNPCob+bBh0IzSYuATOWpKYwCEsTI+4evLGlEeJgKZ/H08XxzvY1p
         +0e0fjWpf6sIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7945460A39;
        Tue, 20 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Add docs target as all dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161895660949.21288.9287565520057967278.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 22:10:09 +0000
References: <20210420132428.15710-1-jolsa@kernel.org>
In-Reply-To: <20210420132428.15710-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        joe@cilium.io, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 20 Apr 2021 15:24:28 +0200 you wrote:
> Currently docs target is make dependency for TEST_GEN_FILES,
> which makes tests to be rebuilt every time you run make.
> 
> Adding docs as all target dependency, so when running make
> on top of built selftests it will show just:
> 
>   $ make
>   make[1]: Nothing to be done for 'docs'.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Add docs target as all dependency
    https://git.kernel.org/bpf/bpf-next/c/d044d9fc1380

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


