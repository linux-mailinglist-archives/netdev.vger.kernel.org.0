Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B62250BE2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgHXWtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgHXWtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:49:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14E7C061574;
        Mon, 24 Aug 2020 15:49:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC7AA1290D468;
        Mon, 24 Aug 2020 15:32:17 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:49:02 -0700 (PDT)
Message-Id: <20200824.154902.1388669182717688782.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, martin.varghese@nokia.com, pshelar@ovn.org,
        fw@strlen.de, dcaratti@redhat.com, edumazet@google.com,
        steffen.klassert@secunet.com, pabeni@redhat.com,
        shmulik@metanetworks.com, kyk.segfault@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Check the expect of skb->data at mac header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820122822.46608-1-linmiaohe@huawei.com>
References: <20200820122822.46608-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:32:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 20 Aug 2020 08:28:22 -0400

> skb_mpls_push() and skb_mpls_pop() expect skb->data at mac header. Check
> this assumption or we would get wrong mac_header and network_header.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Both openvswitch and act_mpls.c seem to adhere to this constraint.

I don't see real value to these extra checks, sorry.
