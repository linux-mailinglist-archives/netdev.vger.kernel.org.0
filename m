Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C696B234EAC
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGaXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGaXmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:42:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B20C06174A;
        Fri, 31 Jul 2020 16:42:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8061111D69C3E;
        Fri, 31 Jul 2020 16:26:04 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:42:48 -0700 (PDT)
Message-Id: <20200731.164248.1001767507572389803.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, jiri@mellanox.com, edumazet@google.com,
        ap420073@gmail.com, xiyou.wangcong@gmail.com, lukas@wunner.de,
        maximmi@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Pass NULL to skb_network_protocol() when we don't
 care about vlan depth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596106956-22054-1-git-send-email-linmiaohe@huawei.com>
References: <1596106956-22054-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:26:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Thu, 30 Jul 2020 19:02:36 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When we don't care about vlan depth, we could pass NULL instead of the
> address of a unused local variable to skb_network_protocol() as a param.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to net-next, thanks.
