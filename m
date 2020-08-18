Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73820248F84
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHRUNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgHRUNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:13:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DB4C061389;
        Tue, 18 Aug 2020 13:13:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5467B127B291C;
        Tue, 18 Aug 2020 12:56:59 -0700 (PDT)
Date:   Tue, 18 Aug 2020 13:13:44 -0700 (PDT)
Message-Id: <20200818.131344.848165078661661080.davem@davemloft.net>
To:     sylphrenadin@gmail.com
Cc:     claudiu.manoil@nxp.com, kuba@kernel.org, Julia.Lawall@lip6.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: gianfar: Add of_node_put() before goto statement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818185241.22277-1-sylphrenadin@gmail.com>
References: <20200818185241.22277-1-sylphrenadin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:56:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sumera Priyadarsini <sylphrenadin@gmail.com>
Date: Wed, 19 Aug 2020 00:22:41 +0530

> Every iteration of for_each_available_child_of_node() decrements
> reference count of the previous node, however when control
> is transferred from the middle of the loop, as in the case of
> a return or break or goto, there is no decrement thus ultimately
> resulting in a memory leak.
> 
> Fix a potential memory leak in gianfar.c by inserting of_node_put()
> before the goto statement.
> 
> Issue found with Coccinelle.
> 
> Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>

These OF iterators are so error prone...

Applied, thanks.
