Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18975149414
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAYJPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:15:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:15:17 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DDF6015A1B0B1;
        Sat, 25 Jan 2020 01:15:15 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:15:14 +0100 (CET)
Message-Id: <20200125.101514.103793361203338602.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: atm: use %*ph to print small buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123142002.51239-1-andriy.shevchenko@linux.intel.com>
References: <20200123142002.51239-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:15:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 23 Jan 2020 16:20:02 +0200

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied, thanks.
