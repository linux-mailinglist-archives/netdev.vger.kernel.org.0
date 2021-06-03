Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AA539A2B0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhFCOBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhFCOBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 10:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B5F2461407;
        Thu,  3 Jun 2021 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622728803;
        bh=MdK4OlgBeSSHPp6pdWTpVt6fMjNhhl5wYGtwrdQ0mEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hd8fVFK14U3LNL0JOz76b72z5+fE8PWlE3mvAgVgKNIlpnDCUXVsCe/Z/UePIlVOX
         ZGCXeEKStpNNb9ynux9Ewhs3Qp1ZBpw1YF+vzCn28th3AJzJaHMJ4UcKz6ARMWABf2
         aCdysbs1SkRVmVosRn7bzBycdmCTMyx7IVsrQ49VjRzujrKSPQTKpcyi69C2grzHXO
         nRhiXTcfD/DDObHlCSGdtow6G86EjGFR9AwFwKNzITKT+R2mPEg0Z1DIA++qnRAvmB
         alX9+9CO7Y+xC7cy19Kh9/TO11x90LTVXrpc2t8iPaXK5kbFfc7dT5zedFVY2XAlvd
         zRQzjcHDEBmOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADC2E60A5C;
        Thu,  3 Jun 2021 14:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/4] Few small libbpf and selftests/bpf fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162272880370.29426.2025785721691622375.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 14:00:03 +0000
References: <20210603004026.2698513-1-andrii@kernel.org>
In-Reply-To: <20210603004026.2698513-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 2 Jun 2021 17:40:22 -0700 you wrote:
> Fix few small issues in libbpf and selftests/bpf:
>   - fix up libbpf.map and move few APIs that didn't make it into final 0.4
>     release;
>   - install skel_internal.h which is used by light skeleton;
>   - fix .gitignore for xdp_redirect_multi.
> 
> Andrii Nakryiko (4):
>   libbpf: move few APIs from 0.4 to 0.5 version
>   libbpf: refactor header installation portions of Makefile
>   libbpf: install skel_internal.h header used from light skeletons
>   selftests/bpf: add xdp_redirect_multi into .gitignore
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/4] libbpf: move few APIs from 0.4 to 0.5 version
    https://git.kernel.org/bpf/bpf-next/c/16cac0060680
  - [bpf-next,2/4] libbpf: refactor header installation portions of Makefile
    https://git.kernel.org/bpf/bpf-next/c/232c9e8bd5eb
  - [bpf-next,3/4] libbpf: install skel_internal.h header used from light skeletons
    https://git.kernel.org/bpf/bpf-next/c/7d8a819dd316
  - [bpf-next,4/4] selftests/bpf: add xdp_redirect_multi into .gitignore
    https://git.kernel.org/bpf/bpf-next/c/56b8b7f9533b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


