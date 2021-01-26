Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C70304DB5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbhAZXOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbhAZWUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C4F9C20679;
        Tue, 26 Jan 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611699609;
        bh=SXdI3hX81sRjw5CNvfOJjL2uiOE/h4sxjnFi+ilr8WQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C+c6wuRZ9Glv+6ZLdJu9C9Lkd0EcQIGzdoBRPsVO3X9Y7PKyYwrfbYMx1j+AKH5NX
         4VGHAoT6WSWzBzZ2/Hj6VJ386KVSR8im2wEt6ZIYfoZFwEn0/ov6jHzF+kEZwTPTIC
         mzwvVMMNfNuR/Y0HOP6PanMoRpO8FGbet2uRoTaQtIAA/uOTVi2qw4dKdkGElbwrjL
         x9KhEJDao9pEY52UszcsnfJQUZiLIS1oMWfi4xMXskaSy8R/1DVWyBKTYc70jdg7QQ
         0ZOcbDo7L6v12rNNeQMA6uq32ExqlDt7Z7zKZ80+p/1Z7Kia/hWKQosUSmEHwTPoPo
         0hBXzz19yxhfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B90D761E3F;
        Tue, 26 Jan 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: fix build for BPF preload when $(O) points to a
 relative path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161169960975.2711.17738606271589282615.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 22:20:09 +0000
References: <20210126161320.24561-1-quentin@isovalent.com>
In-Reply-To: <20210126161320.24561-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii.nakryiko@gmail.com,
        brendanhiggins@google.com, davidgow@google.com,
        masahiroy@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 26 Jan 2021 16:13:20 +0000 you wrote:
> Building the kernel with CONFIG_BPF_PRELOAD, and by providing a relative
> path for the output directory, may fail with the following error:
> 
>   $ make O=build bindeb-pkg
>   ...
>   /.../linux/tools/scripts/Makefile.include:5: *** O=build does not exist.  Stop.
>   make[7]: *** [/.../linux/kernel/bpf/preload/Makefile:9: kernel/bpf/preload/libbpf.a] Error 2
>   make[6]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf/preload] Error 2
>   make[5]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf] Error 2
>   make[4]: *** [/.../linux/Makefile:1799: kernel] Error 2
>   make[4]: *** Waiting for unfinished jobs....
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: fix build for BPF preload when $(O) points to a relative path
    https://git.kernel.org/bpf/bpf/c/150a27328b68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


