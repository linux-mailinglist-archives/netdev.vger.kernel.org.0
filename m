Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AE1C0C95
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgEAD2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEAD2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:28:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71EBC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:28:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B22212772F79;
        Thu, 30 Apr 2020 20:28:07 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:28:06 -0700 (PDT)
Message-Id: <20200430.202806.326255312382467500.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com
Subject: Re: [PATCH v1] net: macb: Fix runtime PM refcounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
References: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:28:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 27 Apr 2020 13:51:20 +0300

> The commit e6a41c23df0d, while trying to fix an issue,
> 
>     ("net: macb: ensure interface is not suspended on at91rm9200")
> 
> introduced a refcounting regression, because in error case refcounter
> must be balanced. Fix it by calling pm_runtime_put_noidle() in error case.
> 
> While here, fix the same mistake in other couple of places.
> 
> Fixes: e6a41c23df0d ("net: macb: ensure interface is not suspended on at91rm9200")
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied, thank you.
