Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA5E1415C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfEERRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:17:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEERRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:17:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B284014D9FAD1;
        Sun,  5 May 2019 10:17:48 -0700 (PDT)
Date:   Sun, 05 May 2019 10:17:48 -0700 (PDT)
Message-Id: <20190505.101748.916918403855488072.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     grygorii.strashko@ti.com, f.fainelli@gmail.com, arnd@arndb.de,
        andrew@lunn.ch, nsekhar@ti.com, fugang.duan@nxp.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] drivers: net: davinci_mdio: fix return value
 check in davinci_mdio_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503111859.1023-1-weiyongjun1@huawei.com>
References: <20190503111859.1023-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:17:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Fri, 3 May 2019 11:18:59 +0000

> In case of error, the function devm_ioremap() returns NULL pointer not
> ERR_PTR(). The IS_ERR() test in the return value check should be
> replaced with NULL test.
> 
> Fixes: 03f66f067560 ("net: ethernet: ti: davinci_mdio: use devm_ioremap()")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
