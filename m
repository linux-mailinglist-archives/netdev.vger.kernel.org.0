Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3768410036
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 22:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244366AbhIQUJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 16:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235575AbhIQUJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 16:09:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1908B60F92;
        Fri, 17 Sep 2021 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631909274;
        bh=d1IphPdsb5CIGGduK0oEPgVjcSyrbO2o0sn+VcEDI/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VU72y7NVmREyxMvsSOX0JEUNjHkWjSzkdp4HiltBFN0VB0Cd4cTfFWqPZiUdl9pHA
         lh72Cne7GjJXBsjB6gjdAMWKy+OqZUSNxLKl9SGx6O6dPHYtsAZ8Kgc6VQXsJQdNdo
         FpwE/+Eaz+rf813hZQMTj7S2wVympXGJ9Elkzw7+93ZisiE3bETOYeG81U5IeQ/V9s
         MfZeQ6vibcOshvbfG3/ohPLjSHq/Bne2M8QqLPMeV24uG/ON/SjsumtZDQju2TYiAv
         wlQZCm10PPYHsMkK4ztw9N5aBzbaEn+T/7+nChGu4uJVW/BBmVZ5YmwXwhehtL1Uie
         IJZO494kHZqOQ==
Date:   Fri, 17 Sep 2021 13:07:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: pull-request: bpf-next 2021-09-17
Message-ID: <20210917130753.15cee563@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917173738.3397064-1-ast@kernel.org>
References: <20210917173738.3397064-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 10:37:38 -0700 Alexei Starovoitov wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 63 non-merge commits during the last 12 day(s) which contain
> a total of 65 files changed, 2653 insertions(+), 751 deletions(-).
> 
> The main changes are:
> 
> 1) Streamline internal BPF program sections handling and
>    bpf_program__set_attach_target() in libbpf, from Andrii.
> 
> 2) Add support for new btf kind BTF_KIND_TAG, from Yonghong.
> 
> 3) Introduce bpf_get_branch_snapshot() to capture LBR, from Song.
> 
> 4) IMUL optimization for x86-64 JIT, from Jie.
> 
> 5) xsk selftest improvements, from Magnus.
> 
> 6) Introduce legacy kprobe events support in libbpf, from Rafael.
> 
> 7) Access hw timestamp through BPF's __sk_buff, from Vadim.

Pulled, thanks!


Hi Konstantin, I was meaning to ask for a while - what are the rules on
the patchwork bot sending its automatic notifications? I noticed that it
will notify (again) when we fast-forward the trees after Linus pulls,
but when we merge bpf into net it never sends anything.
