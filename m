Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC71788D3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbgCDDA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:00:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgCDDA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 22:00:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9767B15B02CE1;
        Tue,  3 Mar 2020 19:00:58 -0800 (PST)
Date:   Tue, 03 Mar 2020 19:00:58 -0800 (PST)
Message-Id: <20200303.190058.61735471646710154.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix checks for max queues to allocate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583126653-12859-1-git-send-email-vishal@chelsio.com>
References: <1583126653-12859-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 19:00:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Mon,  2 Mar 2020 10:54:13 +0530

> Hardware can support more than 8 queues currently limited by
> netif_get_num_default_rss_queues(). So, rework and fix checks for max
> number of queues to allocate. The checks should be based on how many are
> actually supported by hardware, OR the number of online cpus; whichever
> is lower.
> 
> Fixes: 5952dde72307 ("cxgb4: set maximal number of default RSS queues")
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"

Applied, thank you.
