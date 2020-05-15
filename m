Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AFE1D4431
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 05:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgEODzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 23:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726665AbgEODzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 23:55:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF7FC061A0C;
        Thu, 14 May 2020 20:55:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16E59153A4B8D;
        Thu, 14 May 2020 20:55:52 -0700 (PDT)
Date:   Thu, 14 May 2020 20:55:49 -0700 (PDT)
Message-Id: <20200514.205549.2014910642598957644.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-05-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515020321.31979-1-alexei.starovoitov@gmail.com>
References: <20200515020321.31979-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 20:55:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 14 May 2020 19:03:21 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> The main changes are:
> 
> 1) Merged tag 'perf-for-bpf-2020-05-06' from tip tree that includes CAP_PERFMON.
> 
> 2) support for narrow loads in bpf_sock_addr progs and additional
>    helpers in cg-skb progs, from Andrey.
> 
> 3) bpf benchmark runner, from Andrii.
> 
> 4) arm and riscv JIT optimizations, from Luke.
> 
> 5) bpf iterator infrastructure, from Yonghong.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks Alexei.
