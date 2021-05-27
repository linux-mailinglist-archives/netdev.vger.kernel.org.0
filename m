Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F8A39261E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhE0E0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhE0E0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEF6613BC;
        Thu, 27 May 2021 04:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622089469;
        bh=m0xdiI8Z3/YxvpgkWozBm4urKGTLDgouvOWa8+kxkuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QXzag4uWXLmTRMVf40CzQLAqk7dFh9p4OU//xOMo7H/5eV6Aj1WrCR401W38lmU+5
         x9uIih3bLY9PvXODwyOAaDm63A3VeUzcAgQGtShbBesyo5o3UrVS1J/VP0cvWuOmHG
         EAyVsbDvppMf2CyptGPXYaO/NM6UQEXUVy3DRWNU=
Date:   Thu, 27 May 2021 06:24:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [QUESTION] BPF kernel selftests failed in the LTS stable kernel
 4.19.x
Message-ID: <YK8e+iLPjkmuO793@kroah.com>
References: <2988ff60-2d79-b066-6c02-16e5fe8b69db@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2988ff60-2d79-b066-6c02-16e5fe8b69db@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 10:27:51AM +0800, Tiezhu Yang wrote:
> Hi all,
> 
> When update the following LTS stable kernel 4.19.x,
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y
> 
> and then run BPF selftests according to
> https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html#q-how-to-run-bpf-selftests
> 
> $ cd tools/testing/selftests/bpf/
> $ make
> $ sudo ./test_verifier
> $ sudo make run_tests
> 
> there exists many failures include verifier tests and run_tests,
> (1) is it necessary to make sure that there are no any failures in the LTS
> stable kernel 4.19.x?

Yes, it would be nice if that did not happen.

> (2) if yes, how to fix these failures in the LTS stable kernel 4.19.x?

Can you find the offending commits by using `git bisect` and find the
upstream commits that resolve this and let us know so we can backport
them?

thanks,

greg k-h
