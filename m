Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AFD2699C1
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgINXhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINXhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:37:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDC3C06174A;
        Mon, 14 Sep 2020 16:37:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BD0E128BC946;
        Mon, 14 Sep 2020 16:20:20 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:37:06 -0700 (PDT)
Message-Id: <20200914.163706.1002264196277641638.davem@davemloft.net>
To:     yepeilin.cs@gmail.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        hdanton@sina.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] tipc: Fix memory leak in
 tipc_group_create_member()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913080605.1542170-1-yepeilin.cs@gmail.com>
References: <20200912102230.1529402-1-yepeilin.cs@gmail.com>
        <20200913080605.1542170-1-yepeilin.cs@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:20:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>
Date: Sun, 13 Sep 2020 04:06:05 -0400

> tipc_group_add_to_tree() returns silently if `key` matches `nkey` of an
> existing node, causing tipc_group_create_member() to leak memory. Let
> tipc_group_add_to_tree() return an error in such a case, so that
> tipc_group_create_member() can handle it properly.
> 
> Fixes: 75da2163dbb6 ("tipc: introduce communication groups")
> Reported-and-tested-by: syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com
> Cc: Hillf Danton <hdanton@sina.com>
> Link: https://syzkaller.appspot.com/bug?id=048390604fe1b60df34150265479202f10e13aff
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Change in v2:
>     - let tipc_group_add_to_tree() return a real error code instead of -1.
>       (Suggested by David Miller <davem@davemloft.net>)

Applied and queued up for -stable, thank you.
