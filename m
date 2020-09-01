Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F6025A010
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgIAUds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgIAUdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:33:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB68EC061244;
        Tue,  1 Sep 2020 13:33:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E09D81364EC37;
        Tue,  1 Sep 2020 13:16:58 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:33:44 -0700 (PDT)
Message-Id: <20200901.133344.1745405974184516242.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-09-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901194950.13591-1-daniel@iogearbox.net>
References: <20200901194950.13591-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 13:16:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue,  1 Sep 2020 21:49:50 +0200

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> There are two small conflicts when pulling, resolve as follows:
 ...
> We've added 133 non-merge commits during the last 14 day(s) which contain
> a total of 246 files changed, 13832 insertions(+), 3105 deletions(-).
 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled and thanks so much for the conflict guidance.
