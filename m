Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D9DD5844
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 23:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfJMVP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 17:15:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfJMVPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 17:15:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 763CE14A8C12A;
        Sun, 13 Oct 2019 14:15:25 -0700 (PDT)
Date:   Sun, 13 Oct 2019 14:15:22 -0700 (PDT)
Message-Id: <20191013.141522.129979750557733725.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: Fix error handling in nsim_fib_init and
 nsim_fib_exit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011094653.18796-1-yuehaibing@huawei.com>
References: <20191011094653.18796-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 14:15:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 11 Oct 2019 17:46:53 +0800

> In nsim_fib_init(), if register_fib_notifier failed, nsim_fib_net_ops
> should be unregistered before return.
> 
> In nsim_fib_exit(), unregister_fib_notifier should be called before
> nsim_fib_net_ops be unregistered, otherwise may cause use-after-free:
 ...
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 59c84b9fcf42 ("netdevsim: Restore per-network namespace accounting for fib entries")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied and queued up for -stable.
