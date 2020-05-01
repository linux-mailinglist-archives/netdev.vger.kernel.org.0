Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630A21C0C99
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgEAD2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEAD2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:28:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCC3C035494;
        Thu, 30 Apr 2020 20:28:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAA6812773B06;
        Thu, 30 Apr 2020 20:28:47 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:28:47 -0700 (PDT)
Message-Id: <20200430.202847.1797161927869340111.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-pf: Fix error return code in
 otx2_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427121110.8446-1-weiyongjun1@huawei.com>
References: <20200427121110.8446-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:28:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 27 Apr 2020 12:11:10 +0000

> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 5a6d7c9daef3 ("octeontx2-pf: Mailbox communication with AF")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thanks.
