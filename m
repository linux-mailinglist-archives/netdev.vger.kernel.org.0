Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62687F26D4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfKGFUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:20:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfKGFUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:20:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B09B1510EE15;
        Wed,  6 Nov 2019 21:20:36 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:20:35 -0800 (PST)
Message-Id: <20191106.212035.656759378763676850.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     richardcochran@gmail.com, vincent.cheng.xh@renesas.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 -next] ptp: ptp_clockmatrix: Fix missing unlock on
 error in idtcm_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106143309.123196-1-weiyongjun1@huawei.com>
References: <20191106115308.112645-1-weiyongjun1@huawei.com>
        <20191106143309.123196-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:20:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 6 Nov 2019 14:33:09 +0000

> Add the missing unlock before return from function idtcm_probe()
> in the error handling case.
> 
> Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> ---
> v1 -> v2: fix prefix of subject

Applied, thanks.
