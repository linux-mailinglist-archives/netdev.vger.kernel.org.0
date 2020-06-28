Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797DA20C519
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 03:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgF1BDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 21:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgF1BDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 21:03:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DF7C061794;
        Sat, 27 Jun 2020 18:03:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6E29140AD8DC;
        Sat, 27 Jun 2020 18:03:39 -0700 (PDT)
Date:   Sat, 27 Jun 2020 18:03:38 -0700 (PDT)
Message-Id: <20200627.180338.2167394599747071444.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dsahern@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: Fix wrong type conversion from hint to rt
 in ip_route_use_hint()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593244071-28291-1-git-send-email-linmiaohe@huawei.com>
References: <1593244071-28291-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jun 2020 18:03:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Sat, 27 Jun 2020 15:47:51 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> We can't cast sk_buff to rtable by (struct rtable *)hint. Use skb_rtable().
> 
> Fixes: 02b24941619f ("ipv4: use dst hint for ipv4 list receive")
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Please do not put empty lines between Fixes: and other tags.  All of the
tags belong together in a continuous uninterrupted sequence.

Applied and queued up for -stable, thank you.
