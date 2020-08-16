Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0328F2459E9
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgHPWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgHPWeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:34:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB372C061786;
        Sun, 16 Aug 2020 15:34:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C5C513605AC2;
        Sun, 16 Aug 2020 15:17:49 -0700 (PDT)
Date:   Sun, 16 Aug 2020 15:34:34 -0700 (PDT)
Message-Id: <20200816.153434.1972025769249325190.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, pshelar@ovn.org, fw@strlen.de,
        martin.varghese@nokia.com, edumazet@google.com,
        dcaratti@redhat.com, steffen.klassert@secunet.com,
        pabeni@redhat.com, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, jiri@mellanox.com, vyasevic@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix potential wrong skb->protocol in
 skb_vlan_untag()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815084431.16813-1-linmiaohe@huawei.com>
References: <20200815084431.16813-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 15:17:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Sat, 15 Aug 2020 04:44:31 -0400

> We may access the two bytes after vlan_hdr in vlan_set_encap_proto(). So
> we should pull VLAN_HLEN + sizeof(unsigned short) in skb_vlan_untag() or
> we may access the wrong data.
> 
> Fixes: 0d5501c1c828 ("net: Always untag vlan-tagged traffic on input.")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied, thank you.
