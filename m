Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2362318E629
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgCVC6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:58:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVC6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:58:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D549415AC0C0B;
        Sat, 21 Mar 2020 19:58:15 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:58:14 -0700 (PDT)
Message-Id: <20200321.195814.502398615404881876.davem@davemloft.net>
To:     socketcan@hartkopp.net
Cc:     netdev@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH net] slcan: not call free_netdev before rtnl_unlock in
 slcan_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200321130829.12859-1-socketcan@hartkopp.net>
References: <20200321130829.12859-1-socketcan@hartkopp.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:58:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Sat, 21 Mar 2020 14:08:29 +0100

> As the description before netdev_run_todo, we cannot call free_netdev
> before rtnl_unlock, fix it by reorder the code.
> 
> This patch is a 1:1 copy of upstream slip.c commit f596c87005f7
> ("slip: not call free_netdev before rtnl_unlock in slip_open").
> 
> Reported-by: yangerkun <yangerkun@huawei.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied, thanks Oliver.
