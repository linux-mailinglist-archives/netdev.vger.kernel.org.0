Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949F21FD60B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgFQU2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFQU2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:28:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA3FC06174E;
        Wed, 17 Jun 2020 13:28:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 251DA12976DB5;
        Wed, 17 Jun 2020 13:28:49 -0700 (PDT)
Date:   Wed, 17 Jun 2020 13:28:45 -0700 (PDT)
Message-Id: <20200617.132845.1193646686514004014.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-06-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200617201020.48276-1-alexei.starovoitov@gmail.com>
References: <20200617201020.48276-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 13:28:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 17 Jun 2020 13:10:20 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 10 non-merge commits during the last 2 day(s) which contain
> a total of 14 files changed, 158 insertions(+), 59 deletions(-).
> 
> The main changes are:
> 
> 1) Important fix for bpf_probe_read_kernel_str() return value, from Andrii.
> 
> 2) [gs]etsockopt fix for large optlen, from Stanislav.
> 
> 3) devmap allocation fix, from Toke.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Alexei.
