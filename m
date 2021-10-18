Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C939F43188F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhJRMOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:14:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53158 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhJRMOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:14:48 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 434234D31A6D6;
        Mon, 18 Oct 2021 05:12:32 -0700 (PDT)
Date:   Mon, 18 Oct 2021 13:12:26 +0100 (BST)
Message-Id: <20211018.131226.1107812021372806461.davem@davemloft.net>
To:     asmaa@nvidia.com
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v5 0/2] gpio: mlxbf2: Introduce proper interrupt
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211015164809.22009-1-asmaa@nvidia.com>
References: <20211015164809.22009-1-asmaa@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 18 Oct 2021 05:12:34 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>
Date: Fri, 15 Oct 2021 12:48:07 -0400

> This is a follow up on a discussion regarding
> proper handling of GPIO interrupts within the
> gpio-mlxbf2.c driver.
> 
> Link to discussion:
> https://lore.kernel.org/netdev/20210816115953.72533-7-andriy.shevchenko@linux.intel.com/T/
> 
> Patch 1 adds support to a GPIO IRQ handler in gpio-mlxbf2.c.
> Patch 2 is a follow up removal of custom GPIO IRQ handling
> from the mlxbf_gige driver and replacing it with a simple
> IRQ request. The ACPI table for the mlxbf_gige driver is
> responsible for instantiating the PHY GPIO interrupt via
> GpioInt.
> 
> Andy Shevchenko, could you please review this patch series.
> David Miller, could you please ack the changes in the
> mlxbf_gige driver.

Acked-by: David S. Miller <davem@davemloft.net>
