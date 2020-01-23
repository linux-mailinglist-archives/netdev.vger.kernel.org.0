Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D275B146577
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAWKQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:16:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgAWKQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:16:18 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12CF4153D8CD2;
        Thu, 23 Jan 2020 02:16:12 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:16:01 +0100 (CET)
Message-Id: <20200123.111601.254361683807540052.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: rtnetlink: validate IFLA_MTU attribute in
 rtnl_create_link()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122064729.117730-1-edumazet@google.com>
References: <20200122064729.117730-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:16:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 21 Jan 2020 22:47:29 -0800

> rtnl_create_link() needs to apply dev->min_mtu and dev->max_mtu
> checks that we apply in do_setlink()
> 
> Otherwise malicious users can crash the kernel, for example after
> an integer overflow :
 ...
> Fixes: 61e84623ace3 ("net: centralize net_device min/max MTU checking")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
