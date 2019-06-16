Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249B3472B4
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 03:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfFPBWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 21:22:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfFPBWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 21:22:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1438C14FBD222;
        Sat, 15 Jun 2019 18:22:05 -0700 (PDT)
Date:   Sat, 15 Jun 2019 18:22:04 -0700 (PDT)
Message-Id: <20190615.182204.2054894325791126260.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2019-06-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615234138.3313038-1-ast@kernel.org>
References: <20190615234138.3313038-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 18:22:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Sat, 15 Jun 2019 16:41:38 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) fix stack layout of JITed x64 bpf code, from Alexei.
> 
> 2) fix out of bounds memory access in bpf_sk_storage, from Arthur.
> 
> 3) fix lpm trie walk, from Jonathan.
> 
> 4) fix nested bpf_perf_event_output, from Matt.
> 
> 5) and several other fixes.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Alexei.
