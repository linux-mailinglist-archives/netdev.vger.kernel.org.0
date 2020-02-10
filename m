Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B5E157197
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 10:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgBJJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 04:25:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgBJJZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 04:25:04 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C4E514878415;
        Mon, 10 Feb 2020 01:25:01 -0800 (PST)
Date:   Mon, 10 Feb 2020 10:24:58 +0100 (CET)
Message-Id: <20200210.102458.1980916355586297612.davem@davemloft.net>
To:     chenwandun@huawei.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, fw@strlen.de, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] mptcp: make the symbol 'mptcp_sk_clone_lock'
 static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200210082759.12157-1-chenwandun@huawei.com>
References: <20200210082759.12157-1-chenwandun@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 01:25:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>
Date: Mon, 10 Feb 2020 16:27:59 +0800

> Fix the following sparse warning:
> net/mptcp/protocol.c:646:13: warning: symbol 'mptcp_sk_clone_lock' was not declared. Should it be static?
> 
> Fixes: b0519de8b3f1 ("mptcp: fix use-after-free for ipv6")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>

Applied.
