Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26BCF2479
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbfKGBqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:46:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfKGBqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:46:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DB3A150306A8;
        Wed,  6 Nov 2019 17:46:01 -0800 (PST)
Date:   Wed, 06 Nov 2019 17:46:01 -0800 (PST)
Message-Id: <20191106.174601.340921510977427928.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: fix ethernet interface refcounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106094957.94521-1-kgraul@linux.ibm.com>
References: <20191106094957.94521-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 17:46:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Wed,  6 Nov 2019 10:49:57 +0100

> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> If a pnet table entry is to be added mentioning a valid ethernet
> interface, but an invalid infiniband or ISM device, the dev_put()
> operation for the ethernet interface is called twice, resulting
> in a negative refcount for the ethernet interface, which disables
> removal of such a network interface.
> 
> This patch removes one of the dev_put() calls.
> 
> Fixes: 890a2cb4a966 ("net/smc: rework pnet table")
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied and queued up for -stable, thanks.
