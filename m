Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599E2180BCA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgCJWlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:41:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:41:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28C4514C0FF11;
        Tue, 10 Mar 2020 15:41:15 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:41:14 -0700 (PDT)
Message-Id: <20200310.154114.1100646908686438492.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     leon@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net] net/smc: cancel event worker during device
 removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310083330.90427-1-kgraul@linux.ibm.com>
References: <20200310083330.90427-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:41:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Tue, 10 Mar 2020 09:33:30 +0100

> During IB device removal, cancel the event worker before the device
> structure is freed.
> 
> Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
> Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>

Applied and queued up for -stable, thank you.
