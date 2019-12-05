Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC8A113916
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfLEBBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:01:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfLEBBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:01:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6E7614F363AC;
        Wed,  4 Dec 2019 17:01:38 -0800 (PST)
Date:   Wed, 04 Dec 2019 17:01:38 -0800 (PST)
Message-Id: <20191204.170138.1879380922714895667.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frederic.danis@linux.intel.com, alexios.zavras@intel.com,
        eric.lapuyade@linux.intel.com
Subject: Re: [PATCH] NFC: NCI: use new `delay` structure for SPI transfer
 delays
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191204075809.31612-1-alexandru.ardelean@analog.com>
References: <20191204075809.31612-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 17:01:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Wed, 4 Dec 2019 09:58:09 +0200

> In a recent change to the SPI subsystem [1], a new `delay` struct was added
> to replace the `delay_usecs`. This change replaces the current `delay_secs`
> with `delay` for this driver.
> 
> The `spi_transfer_delay_exec()` function [in the SPI framework] makes sure
> that both `delay_usecs` & `delay` are used (in this order to preserve
> backwards compatibility).
> 
> [1] commit bebcfd272df6485 ("spi: introduce `delay` field for
> `spi_transfer` + spi_transfer_delay_exec()")
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Applied.
