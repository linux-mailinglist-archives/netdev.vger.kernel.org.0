Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE6618E622
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgCVCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:50:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbgCVCu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:50:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F9A115ABF013;
        Sat, 21 Mar 2020 19:50:56 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:50:55 -0700 (PDT)
Message-Id: <20200321.195055.1377172913948344277.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] hsr: fix general protection fault in
 hsr_addr_is_self()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200321064650.32174-1-ap420073@gmail.com>
References: <20200321064650.32174-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:50:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat, 21 Mar 2020 06:46:50 +0000

> The port->hsr is used in the hsr_handle_frame(), which is a
> callback of rx_handler.
> hsr master and slaves are initialized in hsr_add_port().
> This function initializes several pointers, which includes port->hsr after
> registering rx_handler.
> So, in the rx_handler routine, un-initialized pointer would be used.
> In order to fix this, pointers should be initialized before
> registering rx_handler.
> 
> Test commands:
...
> Reported-by: syzbot+fcf5dd39282ceb27108d@syzkaller.appspotmail.com
> Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
