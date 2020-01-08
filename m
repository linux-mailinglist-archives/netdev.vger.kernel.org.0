Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9F4134FBA
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgAHXCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:02:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAHXCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:02:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3348A1585B0BD;
        Wed,  8 Jan 2020 15:02:43 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:02:40 -0800 (PST)
Message-Id: <20200108.150240.1372285867204858318.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     ktkhai@virtuozzo.com, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        willemb@google.com, deepa.kernel@gmail.com,
        johannes.berg@intel.com, pctammela@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] [v2] socket: fix unused-function warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108214454.3950090-1-arnd@arndb.de>
References: <20200108214454.3950090-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:02:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed,  8 Jan 2020 22:44:43 +0100

> When procfs is disabled, the fdinfo code causes a harmless
> warning:
> 
> net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
>  static void sock_show_fdinfo(struct seq_file *m, struct file *f)
> 
> Move the function definition up so we can use a single #ifdef
> around it.
> 
> Fixes: b4653342b151 ("net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]")
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks Arnd.
