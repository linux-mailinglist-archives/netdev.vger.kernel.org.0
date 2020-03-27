Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AAE1961CD
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgC0XTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:19:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgC0XTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:19:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DBA6815BEE76C;
        Fri, 27 Mar 2020 16:19:12 -0700 (PDT)
Date:   Fri, 27 Mar 2020 16:19:11 -0700 (PDT)
Message-Id: <20200327.161911.1633165125671428741.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-03-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327215405.29657-1-daniel@iogearbox.net>
References: <20200327215405.29657-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 16:19:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 27 Mar 2020 22:54:05 +0100

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 3 non-merge commits during the last 4 day(s) which contain
> a total of 4 files changed, 25 insertions(+), 20 deletions(-).
> 
> The main changes are:
> 
> 1) Explicitly memset the bpf_attr structure on bpf() syscall to avoid
>    having to rely on compiler to do so. Issues have been noticed on
>    some compilers with padding and other oddities where the request was
>    then unexpectedly rejected, from Greg Kroah-Hartman.
> 
> 2) Sanitize the bpf_struct_ops TCP congestion control name in order to
>    avoid problematic characters such as whitespaces, from Martin KaFai Lau.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
