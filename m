Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8AA249142
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHRW5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRW5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:57:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65C9C061389;
        Tue, 18 Aug 2020 15:57:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAF9C127E56E3;
        Tue, 18 Aug 2020 15:40:30 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:57:16 -0700 (PDT)
Message-Id: <20200818.155716.1040301879924529140.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, martin.varghese@nokia.com, fw@strlen.de,
        pshelar@ovn.org, dcaratti@redhat.com, edumazet@google.com,
        steffen.klassert@secunet.com, pabeni@redhat.com,
        shmulik@metanetworks.com, kyk.segfault@gmail.com,
        sowmini.varadhan@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: handle the return value of pskb_carve_frag_list()
 correctly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815084641.18417-1-linmiaohe@huawei.com>
References: <20200815084641.18417-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 15:40:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Sat, 15 Aug 2020 04:46:41 -0400

> pskb_carve_frag_list() may return -ENOMEM in pskb_carve_inside_nonlinear().
> we should handle this correctly or we would get wrong sk_buff.
> 
> Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied, thanks.
