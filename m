Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E323B048
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgHCWjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:39:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6325DC06174A;
        Mon,  3 Aug 2020 15:39:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E12A12777739;
        Mon,  3 Aug 2020 15:22:16 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:39:01 -0700 (PDT)
Message-Id: <20200803.153901.846172620543023423.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, pshelar@ovn.org, martin.varghese@nokia.com,
        fw@strlen.de, pabeni@redhat.com, edumazet@google.com,
        dcaratti@redhat.com, steffen.klassert@secunet.com,
        shmulik@metanetworks.com, kyk.segfault@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Pass NULL to skb_network_protocol() when we don't
 care about vlan depth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596274565-24655-1-git-send-email-linmiaohe@huawei.com>
References: <1596274565-24655-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:22:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Sat, 1 Aug 2020 17:36:05 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When we don't care about vlan depth, we could pass NULL instead of the
> address of a unused local variable to skb_network_protocol() as a param.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
