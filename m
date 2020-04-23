Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8051B5290
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDWCeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWCeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:34:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976EFC03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:34:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE75F127AB84E;
        Wed, 22 Apr 2020 19:34:01 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:34:00 -0700 (PDT)
Message-Id: <20200422.193400.634370651127465511.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     edumazet@google.com, gustavo@embeddedor.com, ap420073@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] macvlan: silence RCU list debugging warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422021135.114561-1-weiyongjun1@huawei.com>
References: <20200422021135.114561-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:34:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 22 Apr 2020 10:11:35 +0800

> macvlan_hash_lookup() uses list_for_each_entry_rcu() for traversing
> should either under RCU in fast path or the protection of rtnl_mutex.
> 
> In the case of holding RTNL, we should add the corresponding lockdep
> expression to silence the following false-positive warning:
> 
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc1-next-20200416-00003-ga3b8d28bc #1 Not tainted
> -----------------------------
> drivers/net/macvlan.c:126 RCU-list traversed in non-reader section!!
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thanks Wei.
