Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17715170A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgBDI2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:28:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgBDI2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:28:22 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71E781554649D;
        Tue,  4 Feb 2020 00:28:21 -0800 (PST)
Date:   Tue, 04 Feb 2020 09:28:17 +0100 (CET)
Message-Id: <20200204.092817.704234794848111610.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: hsr: fix possible NULL deref in
 hsr_handle_frame()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200203181507.257696-1-edumazet@google.com>
References: <20200203181507.257696-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 00:28:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  3 Feb 2020 10:15:07 -0800

> hsr_port_get_rcu() can return NULL, so we need to be careful.
 ...
> Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
