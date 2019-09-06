Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F09AB91D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392900AbfIFNS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:18:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbfIFNS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:18:57 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04601152F7023;
        Fri,  6 Sep 2019 06:18:55 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:18:54 +0200 (CEST)
Message-Id: <20190906.151854.949486901037977928.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        mcoquelin.stm32@gmail.com, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v1] stmmac: platform: adjust messages and move to dev
 level
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905130053.84703-1-andriy.shevchenko@linux.intel.com>
References: <20190905130053.84703-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:18:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu,  5 Sep 2019 16:00:53 +0300

> This patch amends the error and warning messages across the platform driver.
> It includes the following changes:
>  - append \n to the end of messages
>  - change pr_* macros to dev_*
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied to net-next.
