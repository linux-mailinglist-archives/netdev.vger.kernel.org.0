Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15095170FD9
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgB0E5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:57:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgB0E5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:57:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBA4715B47E30;
        Wed, 26 Feb 2020 20:57:06 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:57:06 -0800 (PST)
Message-Id: <20200226.205706.235234689411895706.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: check for valid ib_client_data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226165246.3426-1-kgraul@linux.ibm.com>
References: <20200226165246.3426-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:57:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Wed, 26 Feb 2020 17:52:46 +0100

> In smc_ib_remove_dev() check if the provided ib device was actually
> initialized for SMC before.
> 
> Reported-by: syzbot+84484ccebdd4e5451d91@syzkaller.appspotmail.com
> Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied and queued up for -stable, thanks.
