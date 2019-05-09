Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89504193C0
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEIUqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:46:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfEIUqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:46:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C315014DAD6D4;
        Thu,  9 May 2019 13:46:48 -0700 (PDT)
Date:   Thu, 09 May 2019 13:46:46 -0700 (PDT)
Message-Id: <20190509.134646.706587781958620517.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     willemb@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, maximmi@mellanox.com
Subject: Re: [PATCH v2] packet: Fix error path in packet_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509145220.37432-1-yuehaibing@huawei.com>
References: <20190508153241.30776-1-yuehaibing@huawei.com>
        <20190509145220.37432-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 13:46:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 9 May 2019 22:52:20 +0800

> kernel BUG at lib/list_debug.c:47!
 ...
> When modprobe af_packet, register_pernet_subsys
> fails and does a cleanup, ops->list is set to LIST_POISON1,
> but the module init is considered to success, then while rmmod it,
> BUG() is triggered in __list_del_entry_valid which is called from
> unregister_pernet_subsys. This patch fix error handing path in
> packet_init to avoid possilbe issue if some error occur.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: rework commit log

Applied and queued up for -stable, thank you.
