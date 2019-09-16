Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C3CB4150
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbfIPTpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:45:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50616 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfIPTpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:45:52 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4CB9153F4343;
        Mon, 16 Sep 2019 12:45:50 -0700 (PDT)
Date:   Mon, 16 Sep 2019 21:45:49 +0200 (CEST)
Message-Id: <20190916.214549.77520800522293464.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com, elfring@users.sourceforge.net
Subject: Re: [PATCH net-next] s390/ctcm: Delete unnecessary checks before
 the macro call =?iso-2022-jp?B?GyRCIUgbKEJkZXZfa2ZyZWVfc2tiGyRCIUkbKEI=?=
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190915172105.42024-1-jwi@linux.ibm.com>
References: <20190915172105.42024-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 12:45:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Sun, 15 Sep 2019 19:21:05 +0200

> From: Markus Elfring <elfring@users.sourceforge.net>
> 
> The dev_kfree_skb() function performs also input parameter validation.
> Thus the test around the shown calls is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied.
