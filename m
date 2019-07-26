Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088887735A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfGZVXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:23:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfGZVXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:23:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32CD012B8C6E4;
        Fri, 26 Jul 2019 14:23:47 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:23:46 -0700 (PDT)
Message-Id: <20190726.142346.407773857500139523.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        netdev@vger.kernel.org, sedat.dilek@credativ.de,
        sedat.dilek@gmail.com
Subject: Re: [PATCH v3 11/14] NFC: nxp-nci: Remove unused macro pr_fmt()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725193511.64274-11-andriy.shevchenko@linux.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
        <20190725193511.64274-11-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:23:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 25 Jul 2019 22:35:08 +0300

> The macro had never been used.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
 ...
> @@ -12,8 +12,6 @@
>   * Copyright (C) 2012  Intel Corporation. All rights reserved.
>   */
>  
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

If there are any kernel log messages generated, which is the case in
this file, this is used.

Also, please resubmit this series with a proper header posting containing
a high level description of what this patch series does, how it is doing it,
and why it is doing it that way.  Also include a changelog.

Thank you.
