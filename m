Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F6D6D95E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 05:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfGSDen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 23:34:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGSDen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 23:34:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 893281405184F;
        Thu, 18 Jul 2019 20:34:42 -0700 (PDT)
Date:   Thu, 18 Jul 2019 20:34:38 -0700 (PDT)
Message-Id: <20190718.203438.2073335732713416227.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, o.rempel@pengutronix.de,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] ag71xx: fix error return code in ag71xx_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719012157.100396-1-weiyongjun1@huawei.com>
References: <20190717115215.22965-1-weiyongjun1@huawei.com>
        <20190719012157.100396-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 20:34:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Fri, 19 Jul 2019 01:21:57 +0000

> Fix to return error code -ENOMEM from the dmam_alloc_coherent() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied.
