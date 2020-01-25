Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB6149415
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAYJQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:16:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:16:06 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A72415A1B0BE;
        Sat, 25 Jan 2020 01:16:04 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:16:03 +0100 (CET)
Message-Id: <20200125.101603.1339711364644203177.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: fddi: skfp: Use print_hex_dump() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123142729.56449-1-andriy.shevchenko@linux.intel.com>
References: <20200123142729.56449-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:16:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 23 Jan 2020 16:27:29 +0200

> Use the print_hex_dump() helper, instead of open-coding the same operations.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.
