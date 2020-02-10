Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD5715719B
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 10:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgBJJZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 04:25:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgBJJZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 04:25:24 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 961E31489E0C3;
        Mon, 10 Feb 2020 01:25:22 -0800 (PST)
Date:   Mon, 10 Feb 2020 10:24:37 +0100 (CET)
Message-Id: <20200210.102437.1485352276466086047.davem@davemloft.net>
To:     chenwandun@huawei.com
Cc:     jon.maloy@ericsson.com, ying.xue@windreiver.com, kuba@kernel.org,
        tuong.t.lien@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] tipc: make three functions static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200210081109.10664-1-chenwandun@huawei.com>
References: <20200210081109.10664-1-chenwandun@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 01:25:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>
Date: Mon, 10 Feb 2020 16:11:09 +0800

> Fix the following sparse warning:
> 
> net/tipc/node.c:281:6: warning: symbol 'tipc_node_free' was not declared. Should it be static?
> net/tipc/node.c:2801:5: warning: symbol '__tipc_nl_node_set_key' was not declared. Should it be static?
> net/tipc/node.c:2878:5: warning: symbol '__tipc_nl_node_flush_key' was not declared. Should it be static?
> 
> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
> Fixes: e1f32190cf7d ("tipc: add support for AEAD key setting via netlink")
> 
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>

Applied.
