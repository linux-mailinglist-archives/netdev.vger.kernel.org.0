Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C82120FE9C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgF3VVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgF3VVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:21:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89B4C061755;
        Tue, 30 Jun 2020 14:21:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B6A51278E9B6;
        Tue, 30 Jun 2020 14:21:12 -0700 (PDT)
Date:   Tue, 30 Jun 2020 14:21:09 -0700 (PDT)
Message-Id: <20200630.142109.2120779545197804579.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-06-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630210008.16989-1-daniel@iogearbox.net>
References: <20200630210008.16989-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 14:21:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 30 Jun 2020 23:00:08 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 28 non-merge commits during the last 9 day(s) which contain
> a total of 35 files changed, 486 insertions(+), 232 deletions(-).
> 
> The main changes are:
 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
