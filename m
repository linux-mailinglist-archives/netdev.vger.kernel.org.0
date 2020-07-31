Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A306234EB3
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgGaXqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaXqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:46:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F984C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 16:46:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 82B6B11E58FA1;
        Fri, 31 Jul 2020 16:29:54 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:46:39 -0700 (PDT)
Message-Id: <20200731.164639.1057940484908792298.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] hsr: Use %pM format specifier for MAC addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730150904.38588-1-andriy.shevchenko@linux.intel.com>
References: <20200730150904.38588-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:29:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 30 Jul 2020 18:09:04 +0300

> Convert to %pM instead of using custom code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied to net-next, thanks.
