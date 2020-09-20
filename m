Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067B227182F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgITVSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgITVSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:18:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2CDC061755;
        Sun, 20 Sep 2020 14:18:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A48FE13BCDB70;
        Sun, 20 Sep 2020 14:01:41 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:18:28 -0700 (PDT)
Message-Id: <20200920.141828.2231994847752545633.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     kuba@kernel.org, linmiaohe@huawei.com, martin.varghese@nokia.com,
        fw@strlen.de, edumazet@google.com, dcaratti@redhat.com,
        steffen.klassert@secunet.com, pabeni@redhat.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: remove unnecessary NULL checking in
 napi_consume_skb()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600482287-46754-1-git-send-email-linyunsheng@huawei.com>
References: <1600482287-46754-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 14:01:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Sat, 19 Sep 2020 10:24:47 +0800

> When budget is non-zero, skb_unref() has already handled the
> NULL checking.
> 
> When budget is zero, the dev_consume_skb_any() has handled NULL
> checking in __dev_kfree_skb_irq(), or dev_kfree_skb() which also
> ultimately call skb_unref().
> 
> So remove the unnecessary checking in napi_consume_skb().
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Applied.
