Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0E424C62D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgHTTJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgHTTJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:09:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BACC061385;
        Thu, 20 Aug 2020 12:09:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5A3912816F4A;
        Thu, 20 Aug 2020 11:52:54 -0700 (PDT)
Date:   Thu, 20 Aug 2020 12:09:40 -0700 (PDT)
Message-Id: <20200820.120940.1305816593609644793.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, kgraul@linux.ibm.com,
        raspl@linux.ibm.com, yepeilin.cs@gmail.com
Subject: Re: [PATCH net 1/1] net/smc: Prevent kernel-infoleak in
 __smc_diag_dump()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820143052.99114-1-ubraun@linux.ibm.com>
References: <20200820143052.99114-1-ubraun@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 11:52:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Thu, 20 Aug 2020 16:30:52 +0200

> From: Peilin Ye <yepeilin.cs@gmail.com>
> 
> __smc_diag_dump() is potentially copying uninitialized kernel stack memory
> into socket buffers, since the compiler may leave a 4-byte hole near the
> beginning of `struct smcd_diag_dmbinfo`. Fix it by initializing `dinfo`
> with memset().
> 
> Cc: stable@vger.kernel.org

Please do not CC: stable for networking patches as per the netdev FAQ.

> Fixes: 4b1b7d3b30a6 ("net/smc: add SMC-D diag support")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>

Applied and queued up for -stable, thank you.
