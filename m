Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251F124913F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHRWz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:55:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9B2C061389;
        Tue, 18 Aug 2020 15:55:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9D0D127E2315;
        Tue, 18 Aug 2020 15:39:07 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:55:53 -0700 (PDT)
Message-Id: <20200818.155553.1033674052040628878.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, pshelar@ovn.org, martin.varghese@nokia.com,
        fw@strlen.de, dcaratti@redhat.com, edumazet@google.com,
        steffen.klassert@secunet.com, pabeni@redhat.com,
        shmulik@metanetworks.com, kyk.segfault@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815084853.20216-1-linmiaohe@huawei.com>
References: <20200815084853.20216-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 15:39:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Sat, 15 Aug 2020 04:48:53 -0400

> The frags of skb_shared_info of the data is assigned in following loop. It
> is meaningless to do a memcpy of frags here.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied, thank you.
