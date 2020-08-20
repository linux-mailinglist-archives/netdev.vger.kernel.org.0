Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AE24C8BA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgHTXkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgHTXkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:40:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB6C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:40:39 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15A9A1287CB8E;
        Thu, 20 Aug 2020 16:23:51 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:40:36 -0700 (PDT)
Message-Id: <20200820.164036.1350126703880055200.davem@davemloft.net>
To:     alaa@mellanox.com
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        marcelo.leitner@gmail.com, roid@mellanox.com
Subject: Re: [PATCH net] net/sched: act_ct: Fix skb double-free in
 tcf_ct_handle_fragments() error flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819152410.1152049-1-alaa@mellanox.com>
References: <20200819152410.1152049-1-alaa@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:23:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>
Date: Wed, 19 Aug 2020 18:24:10 +0300

> tcf_ct_handle_fragments() shouldn't free the skb when ip_defrag() call
> fails. Otherwise, we will cause a double-free bug.
> In such cases, just return the error to the caller.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>

Applied and queued up for -stable, thank you.
