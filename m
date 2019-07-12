Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF606767E
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfGLWZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:25:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfGLWZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:25:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 596BD14E01C0C;
        Fri, 12 Jul 2019 15:25:39 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:25:38 -0700 (PDT)
Message-Id: <20190712.152538.1282305452397171244.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, saeedm@mellanox.com
Subject: Re: [PATCH net-next] net: sched: Fix NULL-pointer dereference in
 tc_indr_block_ing_cmd()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710171229.26900-1-vladbu@mellanox.com>
References: <20190710171229.26900-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:25:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Wed, 10 Jul 2019 20:12:29 +0300

> After recent refactoring of block offlads infrastructure, indr_dev->block
> pointer is dereferenced before it is verified to be non-NULL. Example stack
> trace where this behavior leads to NULL-pointer dereference error when
> creating vxlan dev on system with mlx5 NIC with offloads enabled:
 ...
> Introduce new function tcf_block_non_null_shared() that verifies block
> pointer before dereferencing it to obtain index. Use the function in
> tc_indr_block_ing_cmd() to prevent NULL pointer dereference.
> 
> Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied.
