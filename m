Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF467214F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbfGWVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:09:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbfGWVJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:09:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CB0E153BF442;
        Tue, 23 Jul 2019 14:09:54 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:09:54 -0700 (PDT)
Message-Id: <20190723.140954.1162767455885272582.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     sgoutham@cavium.com, rric@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: thunderx: Use fwnode_get_mac_address()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723200344.69864-1-andriy.shevchenko@linux.intel.com>
References: <20190723200344.69864-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:09:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 23 Jul 2019 23:03:43 +0300

> Replace the custom implementation with fwnode_get_mac_address,
> which works on both DT and ACPI platforms.
> 
> While here, replace memcpy() by ether_addr_copy().
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.
