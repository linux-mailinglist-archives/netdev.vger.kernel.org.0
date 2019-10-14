Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5698D69FF
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 21:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388332AbfJNTR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 15:17:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbfJNTR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 15:17:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7067146DA145;
        Mon, 14 Oct 2019 12:17:58 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:17:56 -0700 (PDT)
Message-Id: <20191014.121756.12312306435084737.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2019-10-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014190620.1588663-1-ast@kernel.org>
References: <20191014190620.1588663-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Oct 2019 12:17:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Mon, 14 Oct 2019 12:06:20 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> 12 days of development and
> 85 files changed, 1889 insertions(+), 1020 deletions(-)

This is nice, do you have a script which generates this?

> The main changes are:
> 
> 1) auto-generation of bpf_helper_defs.h, from Andrii.
> 
> 2) split of bpf_helpers.h into bpf_{helpers, helper_defs, endian, tracing}.h
>    and move into libbpf, from Andrii.
> 
> 3) Track contents of read-only maps as scalars in the verifier, from Andrii.
> 
> 4) small x86 JIT optimization, from Daniel.
> 
> 5) cross compilation support, from Ivan.
> 
> 6) bpf flow_dissector enhancements, from Jakub and Stanislav.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks.

> Note there will be a conflict in tools/lib/bpf/Makefile
> that should be resolved the way Stephen did in:
> https://lore.kernel.org/lkml/20191014103232.09c09e53@canb.auug.org.au/

Ok.
