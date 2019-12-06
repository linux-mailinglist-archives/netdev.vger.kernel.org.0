Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A73114D1F
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 09:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfLFIEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 03:04:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfLFIEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 03:04:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3258514BA38AE;
        Fri,  6 Dec 2019 00:04:36 -0800 (PST)
Date:   Fri, 06 Dec 2019 00:04:31 -0800 (PST)
Message-Id: <20191206.000431.1823406760870683874.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2019-12-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206061857.3660737-1-ast@kernel.org>
References: <20191206061857.3660737-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 00:04:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Thu, 5 Dec 2019 22:18:57 -0800

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 6 non-merge commits during the last 1 day(s) which contain
> a total of 14 files changed, 116 insertions(+), 37 deletions(-).
> 
> The main changes are:
> 
> 1) three selftests fixes, from Stanislav.
> 
> 2) one samples fix, from Jesper.
> 
> 3) one verifier fix, from Yonghong.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Alexei.
