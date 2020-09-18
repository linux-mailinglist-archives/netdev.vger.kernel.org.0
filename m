Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088B726EA3A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgIRBEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgIRBEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:04:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C71C06174A;
        Thu, 17 Sep 2020 18:04:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73FB513680FCB;
        Thu, 17 Sep 2020 17:47:35 -0700 (PDT)
Date:   Thu, 17 Sep 2020 18:04:21 -0700 (PDT)
Message-Id: <20200917.180421.267575960727747646.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 1/1] net/smc: fix double kfree in
 smc_listen_work()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917204602.14586-2-kgraul@linux.ibm.com>
References: <20200917204602.14586-1-kgraul@linux.ibm.com>
        <20200917204602.14586-2-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 17:47:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Thu, 17 Sep 2020 22:46:02 +0200

> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> If smc_listen_rmda_finish() returns with an error, the storage
> addressed by 'buf' is freed a second time.
> Consolidate freeing under a common label and jump to that label.
> 
> Fixes: 6bb14e48ee8d ("net/smc: dynamic allocation of CLC proposal buffer")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied.
