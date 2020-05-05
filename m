Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1161C606A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgEESsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEESs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:48:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B955CC061A0F;
        Tue,  5 May 2020 11:48:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC5A7127F9DC3;
        Tue,  5 May 2020 11:48:26 -0700 (PDT)
Date:   Tue, 05 May 2020 11:48:25 -0700 (PDT)
Message-Id: <20200505.114825.1476000329624313198.davem@davemloft.net>
To:     sjpark@amazon.com
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org,
        gregkh@linuxfoundation.org, edumazet@google.com,
        sj38.park@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sjpark@amazon.de
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505081035.7436-1-sjpark@amazon.com>
References: <20200505081035.7436-1-sjpark@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:48:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.com>
Date: Tue, 5 May 2020 10:10:33 +0200

> From: SeongJae Park <sjpark@amazon.de>
> 
> The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
> socket_sq with socket itself") made those to have same life cycle.
> 
> The changes made the code much more simple, but also made 'socket_alloc'
> live longer than before.  For the reason, user programs intensively
> repeating allocations and deallocations of sockets could cause memory
> pressure on recent kernels.
> 
> To avoid the problem, this commit reverts the changes.

Series applied and queued up for -stable, thanks.
