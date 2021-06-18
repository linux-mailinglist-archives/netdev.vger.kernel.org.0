Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895E73ACE56
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhFRPMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhFRPMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 11:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AF5561351;
        Fri, 18 Jun 2021 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624029003;
        bh=TeRn2QkbF2kguwnHcINAQRPilPWW+nOy3FfndhAX1FM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q3t8hCjW0inyMxPRxuGuEkBXmY5FlntseEpcKHxRgsFButa2mnlnLMf4YrbTQpGDJ
         U+WQ0UEfHErpgKAhjykroxU2STOPARNMLZlVofAQDugJmGSK5jjhmKn31kViWF3TFO
         NtvSQat+PiWtRzpOgG6qDg15pNO9pup5ZmpQBsaSC+MF/f8P6DxrA/MsvU6WSB79vc
         NTEW8OkHgP1m27b+t3GDuaK35FUIn4MEQRIQ5Eu9JzaOOvNYLY3pgTU8+lUlWBiuvN
         mB0qmJ/NCnA/wlYrQbhIOIOiZTkH0ZSppt4zf41T9jBlOp5oGRY+Rla5mH56r4pVN1
         BrJXd5oABVS9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D8F9608B8;
        Fri, 18 Jun 2021 15:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: fix libelf endian handling in resolv_btfids
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162402900350.14256.7811206211874890348.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 15:10:03 +0000
References: <20210618061404.818569-1-Tony.Ambardar@gmail.com>
In-Reply-To: <20210618061404.818569-1-Tony.Ambardar@gmail.com>
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        Tony.Ambardar@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        stable@vger.kernel.org, fche@redhat.com, mark@klomp.org,
        jolsa@kernel.org, yhs@fb.com, jolsa@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 17 Jun 2021 23:14:04 -0700 you wrote:
> The vmlinux ".BTF_ids" ELF section is declared in btf_ids.h to hold a list
> of zero-filled BTF IDs, which is then patched at link-time with correct
> values by resolv_btfids. The section is flagged as "allocable" to preclude
> compression, but notably the section contents (BTF IDs) are untyped.
> 
> When patching the BTF IDs, resolve_btfids writes in host-native endianness
> and relies on libelf for any required translation on reading and updating
> vmlinux. However, since the type of the .BTF_ids section content defaults
> to ELF_T_BYTE (i.e. unsigned char), no translation occurs. This results in
> incorrect patched values when cross-compiling to non-native endianness,
> and can manifest as kernel Oops and test failures which are difficult to
> troubleshoot [1].
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: fix libelf endian handling in resolv_btfids
    https://git.kernel.org/bpf/bpf/c/61e8aeda9398

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


