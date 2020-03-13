Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4F184E6D
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCMSOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:14:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMSOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:14:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53AAA159D143B;
        Fri, 13 Mar 2020 11:14:13 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:14:12 -0700 (PDT)
Message-Id: <20200313.111412.1176021811942628133.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-03-12
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313020649.1133477-1-ast@kernel.org>
References: <20200313020649.1133477-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:14:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Thu, 12 Mar 2020 19:06:49 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 12 non-merge commits during the last 8 day(s) which contain
> a total of 12 files changed, 161 insertions(+), 15 deletions(-).
 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks.
