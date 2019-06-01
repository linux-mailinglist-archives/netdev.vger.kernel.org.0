Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86ACE319BD
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 07:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfFAFS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 01:18:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfFAFS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 01:18:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D54F1504E8A4;
        Fri, 31 May 2019 22:18:56 -0700 (PDT)
Date:   Fri, 31 May 2019 22:18:52 -0700 (PDT)
Message-Id: <20190531.221852.406352613460324482.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2019-05-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190601033813.2166995-1-ast@kernel.org>
References: <20190601033813.2166995-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 22:18:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Fri, 31 May 2019 20:38:13 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> Lots of exciting new features in the first PR of this developement cycle!
> The main changes are:
> 
> 1) misc verifier improvements, from Alexei.
> 
> 2) bpftool can now convert btf to valid C, from Andrii.
> 
> 3) verifier can insert explicit ZEXT insn when requested by 32-bit JITs.
>    This feature greatly improves BPF speed on 32-bit architectures. From Jiong.
> 
> 4) cgroups will now auto-detach bpf programs. This fixes issue of thousands
>    bpf programs got stuck in dying cgroups. From Roman.
> 
> 5) new bpf_send_signal() helper, from Yonghong.
> 
> 6) cgroup inet skb programs can signal CN to the stack, from Lawrence.
> 
> 7) miscellaneous cleanups, from many developers.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks a lot!
