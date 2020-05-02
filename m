Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80B11C21C5
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 02:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgEBAC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 20:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEBAC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 20:02:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6713FC061A0C;
        Fri,  1 May 2020 17:02:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FCCC1513DD1E;
        Fri,  1 May 2020 17:02:57 -0700 (PDT)
Date:   Fri, 01 May 2020 17:02:54 -0700 (PDT)
Message-Id: <20200501.170254.1758105493257680742.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-05-01 (v2)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501235518.78512-1-alexei.starovoitov@gmail.com>
References: <20200501235518.78512-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 17:02:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri,  1 May 2020 16:55:18 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 61 non-merge commits during the last 6 day(s) which contain
> a total of 153 files changed, 6739 insertions(+), 3367 deletions(-).
> 
> The main changes are:
 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks.
