Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFCF254A43
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgH0QMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0QMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:12:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2449C061264;
        Thu, 27 Aug 2020 09:12:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1335127EA615;
        Thu, 27 Aug 2020 08:55:58 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:12:44 -0700 (PDT)
Message-Id: <20200827.091244.2116589061763488368.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, pshelar@ovn.org, fw@strlen.de,
        martin.varghese@nokia.com, edumazet@google.com,
        dcaratti@redhat.com, steffen.klassert@secunet.com,
        pabeni@redhat.com, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: exit immediately when encounter ipv6 fragment in
 skb_checksum_setup_ipv6()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827112159.43242-1-linmiaohe@huawei.com>
References: <20200827112159.43242-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 08:55:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 27 Aug 2020 07:21:59 -0400

> skb_checksum_setup_ipv6() always return -EPROTO if ipv6 packet is fragment.
> So we should not continue to parse other header type in this case. Also
> remove unnecessary local variable 'fragment'.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Again, this optimization is arguable at best.  The code functions fine and
correctly as-is.

I'm not applying this, sorry.
