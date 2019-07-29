Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D952B78FF2
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387654AbfG2P4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:56:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387583AbfG2P4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:56:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E76F81265A1E8;
        Mon, 29 Jul 2019 08:56:49 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:56:45 -0700 (PDT)
Message-Id: <20190729.085645.1391342135359241217.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        netdev@vger.kernel.org, sedat.dilek@credativ.de
Subject: Re: [PATCH v4 00/14] NFC: nxp-nci: clean up and new device support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 08:56:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 29 Jul 2019 16:35:00 +0300

> Few people reported that some laptops are coming with new ACPI ID for the
> devices should be supported by nxp-nci driver.
> 
> This series adds new ID (patch 2), cleans up the driver from legacy platform
> data and unifies GPIO request for Device Tree and ACPI (patches 3-6), removes
> dead or unneeded code (patches 7, 9, 11), constifies ID table (patch 8),
> removes comma in terminator line for better maintenance (patch 10) and
> rectifies Kconfig entry (patches 12-14).
> 
> It also contains a fix for NFC subsystem as suggested by Sedat.
> 
> Series has been tested by Sedat.
 ...

Series applied to net-next, thanks.
