Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B3D28A88B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388320AbgJKRkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 13:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388298AbgJKRkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 13:40:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602438004;
        bh=NKz78TByLz+sVp9xE+GLPCyjNXq9cSglR5JJGSkhLtE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VmUIMGMIUfmO7U8kDEyMlv2+Sgp343K9ZSfCw/0ChMtCpEgJaXBasW9cDS4if4ZVv
         Nex14nPDcq7Yb40YwGgG79IvNYJpgkKDhRxwQVuhiZMdPgFAlsG/1F3Qku16vH8jVG
         0CkQzNcdbqmB8VgOCBf6OiTl907E1UbAHyNRvFhA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v6 0/6] Follow-up BPF helper improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160243800397.19397.2897008510559646665.git-patchwork-notify@kernel.org>
Date:   Sun, 11 Oct 2020 17:40:03 +0000
References: <20201010234006.7075-1-daniel@iogearbox.net>
In-Reply-To: <20201010234006.7075-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Sun, 11 Oct 2020 01:40:00 +0200 you wrote:
> This series addresses most of the feedback [0] that was to be followed
> up from the last series, that is, UAPI helper comment improvements and
> getting rid of the ifindex obj file hacks in the selftest by using a
> BPF map instead. The __sk_buff data/data_end pointer work, I'm planning
> to do in a later round as well as the mem*() BPF improvements we have
> in Cilium for libbpf. Next, the series adds two features, i) a helper
> called redirect_peer() to improve latency on netns switch, and ii) to
> allow map in map with dynamic inner array map sizes. Selftests for each
> are added as well. For details, please check individual patches, thanks!
> 
> [...]

Here is the summary with links:
  - [bpf-next,v6,1/6] bpf: improve bpf_redirect_neigh helper description
    https://git.kernel.org/bpf/bpf-next/c/dd2ce6a5373c
  - [bpf-next,v6,2/6] bpf: add redirect_peer helper
    https://git.kernel.org/bpf/bpf-next/c/9aa1206e8f48
  - [bpf-next,v6,3/6] bpf: allow for map-in-map with dynamic inner array map entries
    https://git.kernel.org/bpf/bpf-next/c/4a8f87e60f6d
  - [bpf-next,v6,4/6] bpf, selftests: add test for different array inner map size
    https://git.kernel.org/bpf/bpf-next/c/6775dab73bdc
  - [bpf-next,v6,5/6] bpf, selftests: make redirect_neigh test more extensible
    https://git.kernel.org/bpf/bpf-next/c/57a73fe7c198
  - [bpf-next,v6,6/6] bpf, selftests: add redirect_peer selftest
    https://git.kernel.org/bpf/bpf-next/c/9f4c53ca23a2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


