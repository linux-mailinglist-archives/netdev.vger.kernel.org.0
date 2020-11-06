Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212382A8D22
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 03:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKFCuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 21:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgKFCuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 21:50:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604631006;
        bh=pC4X16sQ9JYiveXdFY9YjxwYqqqKoKT+A5BAJwoYdMk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=utXVrCKPsQ0wkPgoXmmm8tPsWFvyMI5jNYs8AVsCbKILkTREGjQPhZgxuBHsZfLJ0
         9dwG07T/ZysTEGGaVEsr3wI/PCAMYL8kKeADmpIEHi/gney8EyThF5NFUJ8E6PIQ5O
         10kiyltosRR8ZwzTe4FRPSN8Ufts8oAXjZ2g9K+Y=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 00/11] libbpf: split BTF support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160463100641.2359.15858910052445275847.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Nov 2020 02:50:06 +0000
References: <20201105043402.2530976-1-andrii@kernel.org>
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 4 Nov 2020 20:33:50 -0800 you wrote:
> This patch set adds support for generating and deduplicating split BTF. This
> is an enhancement to the BTF, which allows to designate one BTF as the "base
> BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
> kernel module BTF), which are building upon and extending base BTF with extra
> types and strings.
> 
> Once loaded, split BTF appears as a single unified BTF superset of base BTF,
> with continuous and transparent numbering scheme. This allows all the existing
> users of BTF to work correctly and stay agnostic to the base/split BTFs
> composition.  The only difference is in how to instantiate split BTF: it
> requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
> or btf__parse_xxx_split() "constructors" explicitly.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,01/11] libbpf: factor out common operations in BTF writing APIs
    https://git.kernel.org/bpf/bpf-next/c/c81ed6d81e05
  - [v2,bpf-next,02/11] selftest/bpf: relax btf_dedup test checks
    https://git.kernel.org/bpf/bpf-next/c/d9448f94962b
  - [v2,bpf-next,03/11] libbpf: unify and speed up BTF string deduplication
    https://git.kernel.org/bpf/bpf-next/c/88a82c2a9ab5
  - [v2,bpf-next,04/11] libbpf: implement basic split BTF support
    https://git.kernel.org/bpf/bpf-next/c/ba451366bf44
  - [v2,bpf-next,05/11] selftests/bpf: add split BTF basic test
    https://git.kernel.org/bpf/bpf-next/c/197389da2fbf
  - [v2,bpf-next,06/11] selftests/bpf: add checking of raw type dump in BTF writer APIs selftests
    https://git.kernel.org/bpf/bpf-next/c/1306c980cf89
  - [v2,bpf-next,07/11] libbpf: fix BTF data layout checks and allow empty BTF
    https://git.kernel.org/bpf/bpf-next/c/d8123624506c
  - [v2,bpf-next,08/11] libbpf: support BTF dedup of split BTFs
    https://git.kernel.org/bpf/bpf-next/c/f86524efcf9e
  - [v2,bpf-next,09/11] libbpf: accomodate DWARF/compiler bug with duplicated identical arrays
    https://git.kernel.org/bpf/bpf-next/c/6b6e6b1d09aa
  - [v2,bpf-next,10/11] selftests/bpf: add split BTF dedup selftests
    https://git.kernel.org/bpf/bpf-next/c/232338fa2fb4
  - [v2,bpf-next,11/11] tools/bpftool: add bpftool support for split BTF
    https://git.kernel.org/bpf/bpf-next/c/75fa1777694c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


