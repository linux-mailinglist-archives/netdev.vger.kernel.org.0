Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8127A9C66
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbfIEH5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:57:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfIEH5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:57:53 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F8721538519F;
        Thu,  5 Sep 2019 00:57:52 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:57:51 -0700 (PDT)
Message-Id: <20190905.005751.1798664766004500473.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: pull-request: can-next 2019-09-03,pull-request: can-next
 2019-09-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a6751a50-f15d-612d-783b-a706098ea90e@pengutronix.de>
References: <a6751a50-f15d-612d-783b-a706098ea90e@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:57:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 3 Sep 2019 11:46:31 +0200

> this is a pull request for net-next/master consisting of 15 patches.
> 
> The first patch is by Christer Beskow, targets the kvaser_pciefd driver
> and fixes the PWM generator's frequency.
> 
> The next three patches are by Dan Murphy, the tcan4x5x is updated to use
> a proper interrupts/interrupt-parent DT binding to specify the devices
> IRQ line. Further the unneeded wake ups of the device is removed from
> the driver.
> 
> A patch by me for the mcp25xx driver removes the deprecated board file
> setup example. Three patches by Andy Shevchenko simplify clock handling,
> update the driver from OF to device property API and simplify the
> mcp251x_can_suspend() function.
> 
> The remaining 7 patches are by me and clean up checkpatch warnings in
> the generic CAN device infrastructure.

Pulled, thanks.
