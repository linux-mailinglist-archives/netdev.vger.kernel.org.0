Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752F0117EDE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLJEQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:16:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfLJEQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:16:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 895AF154EF399;
        Mon,  9 Dec 2019 20:16:50 -0800 (PST)
Date:   Mon, 09 Dec 2019 20:16:49 -0800 (PST)
Message-Id: <20191209.201649.404230474226196154.davem@davemloft.net>
To:     stephan@gerhold.net
Cc:     clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH] NFC: nxp-nci: Fix probing without ACPI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209185343.215893-1-stephan@gerhold.net>
References: <20191209185343.215893-1-stephan@gerhold.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 20:16:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>
Date: Mon,  9 Dec 2019 19:53:43 +0100

> devm_acpi_dev_add_driver_gpios() returns -ENXIO if CONFIG_ACPI
> is disabled (e.g. on device tree platforms).
> In this case, nxp-nci will silently fail to probe.
> 
> The other NFC drivers only log a debug message if
> devm_acpi_dev_add_driver_gpios() fails.
> Do the same in nxp-nci to fix this problem.
> 
> Fixes: ad0acfd69add ("NFC: nxp-nci: Get rid of code duplication in ->probe()")
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>

Applied and queued up for v5.4 -stable, thanks.
