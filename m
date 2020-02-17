Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78CA16085A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQCxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:53:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgBQCxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:53:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23FFB153DC115;
        Sun, 16 Feb 2020 18:53:14 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:53:13 -0800 (PST)
Message-Id: <20200216.185313.2089845162456995802.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, jiri@mellanox.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213045826.181478-1-edumazet@google.com>
References: <20200213045826.181478-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:53:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 12 Feb 2020 20:58:26 -0800

> Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
> guarantee it is nul terminated.
> 
> We should use nla_strdup() instead of kstrdup(), since this
> helper will make sure not accessing out-of-bounds data.
 ...
> Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
