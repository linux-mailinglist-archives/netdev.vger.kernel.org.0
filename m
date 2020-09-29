Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBBC27BA72
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgI2Bq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2Bq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:46:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76261C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:46:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CE87127A2A5E;
        Mon, 28 Sep 2020 18:29:38 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:46:25 -0700 (PDT)
Message-Id: <20200928.184625.1187203928205342651.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 1/1] l2tp: report rx cookie discards in
 netlink get
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928124634.21461-1-tparkin@katalix.com>
References: <20200928124634.21461-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:29:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Mon, 28 Sep 2020 13:46:34 +0100

> --- a/include/uapi/linux/l2tp.h
> +++ b/include/uapi/linux/l2tp.h
> @@ -143,6 +143,7 @@ enum {
>  	L2TP_ATTR_RX_SEQ_DISCARDS,	/* u64 */
>  	L2TP_ATTR_RX_OOS_PACKETS,	/* u64 */
>  	L2TP_ATTR_RX_ERRORS,		/* u64 */
> +	L2TP_ATTR_RX_COOKIE_DISCARDS,	/* u64 */
>  	L2TP_ATTR_STATS_PAD,
>  	__L2TP_ATTR_STATS_MAX,
>  };

You can't change the value of the L2TP_ATTR_STATS_PAD attribute.

Instead you must add new values strictly right before the
__L2TP_ATTR_STATS_MAX.
