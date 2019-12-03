Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F381104F5
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLCTTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:19:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfLCTTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:19:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93D87151031AE;
        Tue,  3 Dec 2019 11:19:51 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:19:51 -0800 (PST)
Message-Id: <20191203.111951.52254124666913970.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jiri@mellanox.com, wharms@bfs.de, idosch@mellanox.com,
        petrm@mellanox.com, pabeni@redhat.com, edumazet@google.com,
        ap420073@gmail.com, stephen@networkplumber.org, alobakin@dlink.ru,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] net: fix a leak in register_netdevice()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203141239.hztnqxtsa67ramsh@kili.mountain>
References: <5DE6663F.40803@bfs.de>
        <20191203141239.hztnqxtsa67ramsh@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:19:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 3 Dec 2019 17:12:39 +0300

> We have to free "dev->name_node" on this error path.
> 
> Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> Reported-by: syzbot+6e13e65ffbaa33757bcb@syzkaller.appspotmail.com
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: dev->name_node can't be NULL so we can remove the check for that
>     in the cleanup code.

Applied, thanks Dan.
