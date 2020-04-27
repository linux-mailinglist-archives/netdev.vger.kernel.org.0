Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88D1BAF7B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgD0U23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726486AbgD0U23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:28:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E67C0610D5;
        Mon, 27 Apr 2020 13:28:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0067F15D6F68C;
        Mon, 27 Apr 2020 13:28:28 -0700 (PDT)
Date:   Mon, 27 Apr 2020 13:28:27 -0700 (PDT)
Message-Id: <20200427.132827.1256740159726999330.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     grygorii.strashko@ti.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: fix return value check in
 k3_cppi_desc_pool_create_name()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427093343.157119-1-weiyongjun1@huawei.com>
References: <20200427093343.157119-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 13:28:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 27 Apr 2020 09:33:43 +0000

> In case of error, the function gen_pool_create() returns NULL pointer
> not ERR_PTR(). The IS_ERR() test in the return value check should be
> replaced with NULL test.
> 
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
