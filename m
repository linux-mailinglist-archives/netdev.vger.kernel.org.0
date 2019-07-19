Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C85C6D960
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 05:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfGSDes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 23:34:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGSDes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 23:34:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A22F14051852;
        Thu, 18 Jul 2019 20:34:48 -0700 (PDT)
Date:   Thu, 18 Jul 2019 20:34:47 -0700 (PDT)
Message-Id: <20190718.203447.802057574398577206.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, o.rempel@pengutronix.de,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] ag71xx: fix return value check in ag71xx_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719012206.100478-1-weiyongjun1@huawei.com>
References: <20190717115225.23047-1-weiyongjun1@huawei.com>
        <20190719012206.100478-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 20:34:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Fri, 19 Jul 2019 01:22:06 +0000

> In case of error, the function of_get_mac_address() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied.
