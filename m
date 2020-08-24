Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E874524FE90
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHXNJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgHXNJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:09:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8BCC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:09:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B75B51281D77A;
        Mon, 24 Aug 2020 05:52:40 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:09:26 -0700 (PDT)
Message-Id: <20200824.060926.429831991235819793.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, xiyou.wangcong@gmail.com, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: openvswitch: refactor flow free
 function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824073602.70812-3-xiangxia.m.yue@gmail.com>
References: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
        <20200824073602.70812-3-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 05:52:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Mon, 24 Aug 2020 15:36:01 +0800

> To avoid a bug when deleting flows in the future, add
> BUG_ON in flush flows function.

BUG_ON() is too severe, I think WARN_ON() or similar are sufficient
because the kernel can try to continue operating if this condition is
detected.

And you can force the values to zero in such a situation.

Thank you.
