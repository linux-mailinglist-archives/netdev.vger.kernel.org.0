Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36BD273530
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgIUVwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIUVwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:52:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5543C061755;
        Mon, 21 Sep 2020 14:52:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F92811E49F62;
        Mon, 21 Sep 2020 14:35:13 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:52:00 -0700 (PDT)
Message-Id: <20200921.145200.2255128901470643620.davem@davemloft.net>
To:     jingxiangfeng@huawei.com
Cc:     kuba@kernel.org, ktkhai@virtuozzo.com, pabeni@redhat.com,
        tklauser@distanz.ch, steffen.klassert@secunet.com, cai@lca.pw,
        pankaj.laxminarayan.bharadiya@intel.com, arnd@arndb.de,
        vcaputo@pengaru.com, edumazet@google.com, sd@queasysnail.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: unix: remove redundant assignment to variable
 'err'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921032952.99894-1-jingxiangfeng@huawei.com>
References: <20200921032952.99894-1-jingxiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:35:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Date: Mon, 21 Sep 2020 11:29:52 +0800

> After commit 37ab4fa7844a ("net: unix: allow bind to fail on mutex lock"),
> the assignment to err is redundant. So remove it.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
 ...
> @@ -878,7 +878,6 @@ static int unix_autobind(struct socket *sock)
>  	if (err)
>  		return err;
>  
> -	err = 0;
>  	if (u->addr)
>  		goto out;

Yes, err is always zero here in this code path.

Applied, thanks.
