Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6E9167E6
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 18:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEGQ3d convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 May 2019 12:29:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfEGQ3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 12:29:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87E981478BDA8;
        Tue,  7 May 2019 09:29:32 -0700 (PDT)
Date:   Tue, 07 May 2019 09:29:32 -0700 (PDT)
Message-Id: <20190507.092932.293198732805725041.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2019-05-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190506151822.19628-1-daniel@iogearbox.net>
References: <20190506151822.19628-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 09:29:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Mon,  6 May 2019 17:18:22 +0200

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> The main changes are:
> 
> 1) Two AF_XDP libbpf fixes for socket teardown; first one an invalid
>    munmap and the other one an invalid skmap cleanup, both from Björn.
> 
> 2) More graceful CONFIG_DEBUG_INFO_BTF handling when pahole is not
>    present in the system to generate vmlinux btf info, from Andrii.
> 
> 3) Fix libbpf and thus fix perf build error with uClibc on arc
>    architecture, from Vineet.
> 
> 4) Fix missing libbpf_util.h header install in libbpf, from William.
> 
> 5) Exclude bash-completion/bpftool from .gitignore pattern, from Masahiro.
> 
> 6) Fix up rlimit in test_libbpf_open kselftest test case, from Yonghong.
> 
> 7) Minor misc cleanups.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks.
