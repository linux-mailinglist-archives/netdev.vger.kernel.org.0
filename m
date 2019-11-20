Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3D104521
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKTUcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:32:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfKTUcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:32:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 177F914C1F41C;
        Wed, 20 Nov 2019 12:32:03 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:32:02 -0800 (PST)
Message-Id: <20191120.123202.2084602990658094538.davem@davemloft.net>
To:     gautamramk@gmail.com
Cc:     jhs@mojatatu.com, netdev@vger.kernel.org, lesliemonis@gmail.com,
        tahiliani@nitk.edu.in
Subject: Re: [PATCH net-next v2] net: sched: pie: enable timestamp based
 delay calculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120141354.17050-1-gautamramk@gmail.com>
References: <20191120141354.17050-1-gautamramk@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:32:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Ramakrishnan <gautamramk@gmail.com>
Date: Wed, 20 Nov 2019 19:43:54 +0530

> RFC 8033 suggests an alternative approach to calculate the queue
> delay in PIE by using a timestamp on every enqueued packet. This
> patch adds an implementation of that approach and sets it as the
> default method to calculate queue delay. The previous method (based
> on Little's law) to calculate queue delay is set as optional.
> 
> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> Acked-by: Dave Taht <dave.taht@gmail.com>
> ---
> Changes from v1 to v2:
> - Made timestamp feature default and made average dequeue
>   rate estimator optional as Recommended by Dave.
> - Changed the position of the timestamp qdelay calculation
>   inside pie_process_dequeue().

Applied.
