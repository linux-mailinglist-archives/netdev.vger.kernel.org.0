Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE482C38B0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 06:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgKYFaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 00:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgKYFaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 00:30:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606282206;
        bh=xTozRZAvnolZtYhGtJu2OgFVAhlDXReBsN3m/WAepQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a9gGUIUyMuZMJbSG58v3SWYjGCBTfAGUWIb8qh6Jn3ZCcuIGdN4VUmrBLvYaEAPg3
         m2/Kppd4eQeO87Y6lXFwu1dYtgC/plyKDjV52zTmeRfEFj5Uo8mdJepHbs9JZqTH9x
         eMouo4Mqc0XcvcDdGPBcpso6PG10alMZJitxQBVU=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv6 iproute2-next 0/5] iproute2: add libbpf support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160628220619.29769.15253343700006760034.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Nov 2020 05:30:06 +0000
References: <20201123131201.4108483-1-haliu@redhat.com>
In-Reply-To: <20201123131201.4108483-1-haliu@redhat.com>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, davem@davemloft.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, jbenc@redhat.com, toke@redhat.com,
        brouer@redhat.com, alexei.starovoitov@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (refs/heads/main):

On Mon, 23 Nov 2020 21:11:56 +0800 you wrote:
> This series converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available. This means that iproute2 will
> correctly process BTF information and support the new-style BTF-defined
> maps, while keeping compatibility with the old internal map definition
> syntax.
> 
> This is achieved by checking for libbpf at './configure' time, and using
> it if available. By default the system libbpf will be used, but static
> linking against a custom libbpf version can be achieved by passing
> LIBBPF_DIR to configure. LIBBPF_FORCE can be set to on to force configure
> abort if no suitable libbpf is found (useful for automatic packaging
> that wants to enforce the dependency), or set off to disable libbpf check
> and build iproute2 with legacy bpf.
> 
> [...]

Here is the summary with links:
  - [PATCHv6,iproute2-next,1/5] iproute2: add check_libbpf() and get_libbpf_version()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=503e9229b054
  - [PATCHv6,iproute2-next,2/5] lib: make ipvrf able to use libbpf and fix function name conflicts
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=dc800a4ed4f3
  - [PATCHv6,iproute2-next,3/5] lib: add libbpf support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=6d61a2b55799
  - [PATCHv6,iproute2-next,4/5] examples/bpf: move struct bpf_elf_map defined maps to legacy folder
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1ac8285a692e
  - [PATCHv6,iproute2-next,5/5] examples/bpf: add bpf examples with BTF defined maps
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=71c7c1fb4ff0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


