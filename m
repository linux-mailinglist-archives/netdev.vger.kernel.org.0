Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF45159E7D
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgBLBFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:05:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgBLBFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:05:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA54915167B3B;
        Tue, 11 Feb 2020 17:05:29 -0800 (PST)
Date:   Tue, 11 Feb 2020 17:05:29 -0800 (PST)
Message-Id: <20200211.170529.1525657879668637958.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ubraun@linux.vnet.ibm.com
Subject: Re: [PATCH net] net/smc: fix leak of kernel memory to user space
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200210193613.59360-1-edumazet@google.com>
References: <20200210193613.59360-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Feb 2020 17:05:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 10 Feb 2020 11:36:13 -0800

> As nlmsg_put() does not clear the memory that is reserved,
> it this the caller responsability to make sure all of this
> memory will be written, in order to not reveal prior content.
> 
> While we are at it, we can provide the socket cookie even
> if clsock is not set.
> 
> syzbot reported :
 ...
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>

Applied and queued up for -stable, thanks.
