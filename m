Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913EDA3F2D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfH3Uzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:55:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbfH3Uzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:55:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AB31154FD908;
        Fri, 30 Aug 2019 13:55:36 -0700 (PDT)
Date:   Fri, 30 Aug 2019 13:55:35 -0700 (PDT)
Message-Id: <20190830.135535.690331861133879813.davem@davemloft.net>
To:     tbogendoerfer@suse.de
Cc:     ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/15] ioc3-eth improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830092539.24550-1-tbogendoerfer@suse.de>
References: <20190830092539.24550-1-tbogendoerfer@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 13:55:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date: Fri, 30 Aug 2019 11:25:23 +0200

> In my patch series for splitting out the serial code from ioc3-eth
> by using a MFD device there was one big patch for ioc3-eth.c,
> which wasn't really usefull for reviews. This series contains the
> ioc3-eth changes splitted in smaller steps and few more cleanups.
> Only the conversion to MFD will be done later in a different series.
> 
> Changes in v3:
> - no need to check skb == NULL before passing it to dev_kfree_skb_any
> - free memory allocated with get_page(s) with free_page(s)
> - allocate rx ring with just GFP_KERNEL
> - add required alignment for rings in comments
> 
> Changes in v2:
> - use net_err_ratelimited for printing various ioc3 errors
> - added missing clearing of rx buf valid flags into ioc3_alloc_rings
> - use __func__ for printing out of memory messages

Series applied, thanks.

I might be nice to use get_order() instead of hardcoding the page size
when "2" is passed into the page alloc/free calls.  Just FYI...
