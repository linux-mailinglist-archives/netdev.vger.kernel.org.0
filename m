Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7866D319321
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhBKTau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhBKTar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 14:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CBB6264E42;
        Thu, 11 Feb 2021 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613071806;
        bh=tZZCBz4Kktiv1zTVTF0hcFeqZ3MUADme97t/fKlwNwI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qW4yukOGlsTeWDuCr/nNI2lBPDj+yzMHF7TjePrO7VMOMmSe767xF5bhLFDAMzsDf
         y9twpZt3W/+Asq5PXqi6Ua5X6wWaVEQdH55paHKgG2oTcrbUa3R3tj5DFCLYlaNMrH
         lNZo7SNQQhiayZi2/9x2NuZqRceEomfYz/hKqPosZNrZt7XM2StnlRRVeyUffYt4W1
         UCg/gPGut3kSlzybdn6Q9Nn3M4YszW8G0VOC01blpgKzuEhLwuouAaprZEePSaGy8V
         HvWJHAeittavb3pJHD74k2MKaRg1dnC3OOvAOE2jcDIR76BV41F9Vx7lKjrfa2qkmi
         glaCO9C/aMBnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B5C1E600E8;
        Thu, 11 Feb 2021 19:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] kbuild: Do not clean resolve_btfids if the output
 does not exist
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161307180674.24457.7910798840196422022.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 19:30:06 +0000
References: <20210211124004.1144344-1-jolsa@kernel.org>
In-Reply-To: <20210211124004.1144344-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        nathan@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        linux-kbuild@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 11 Feb 2021 13:40:04 +0100 you wrote:
> Nathan reported issue with cleaning empty build directory:
> 
>   $ make -s O=build distclean
>   ../../scripts/Makefile.include:4: *** \
>   O=/ho...build/tools/bpf/resolve_btfids does not exist.  Stop.
> 
> The problem that tools scripts require existing output
> directory, otherwise it fails.
> 
> [...]

Here is the summary with links:
  - [bpf-next] kbuild: Do not clean resolve_btfids if the output does not exist
    https://git.kernel.org/bpf/bpf-next/c/0e1aa629f1ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


