Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61E0A9FBC
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387570AbfIEKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:33:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732586AbfIEKdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:33:50 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B1FC15388124;
        Thu,  5 Sep 2019 03:33:49 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:33:47 +0200 (CEST)
Message-Id: <20190905.123347.232298073032499918.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     mitch@sfgoth.com, netdev@vger.kernel.org
Subject: Re: [PATCH v1] pppoatm: use %*ph to print small buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190904174459.77067-1-andriy.shevchenko@linux.intel.com>
References: <20190904174459.77067-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:33:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed,  4 Sep 2019 20:44:59 +0300

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied to net-next.
