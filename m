Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1E6E9475
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 02:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfJ3BKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 21:10:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfJ3BKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 21:10:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA4321423AA93;
        Tue, 29 Oct 2019 18:10:38 -0700 (PDT)
Date:   Tue, 29 Oct 2019 18:10:38 -0700 (PDT)
Message-Id: <20191029.181038.1190737298290626895.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com
Subject: Re: [PATCH net 1/1] net/smc: fix refcounting for non-blocking
 connect()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029114126.59907-1-ubraun@linux.ibm.com>
References: <20191029114126.59907-1-ubraun@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 18:10:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Tue, 29 Oct 2019 12:41:26 +0100

> If a nonblocking socket is immediately closed after connect(),
> the connect worker may not have started. This results in a refcount
> problem, since sock_hold() is called from the connect worker.
> This patch moves the sock_hold in front of the connect worker
> scheduling.
> 
> Reported-by: syzbot+4c063e6dea39e4b79f29@syzkaller.appspotmail.com
> Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")
> Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>

Applied and queued up for -stable, thank you.
