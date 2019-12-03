Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159441104E0
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfLCTPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:15:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51594 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfLCTPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:15:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45D9F1510318A;
        Tue,  3 Dec 2019 11:15:00 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:14:57 -0800 (PST)
Message-Id: <20191203.111457.631787255568854644.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2019-12-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203104703.14620-1-mkl@pengutronix.de>
References: <20191203104703.14620-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:15:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue,  3 Dec 2019 11:46:57 +0100

> this is a pull request of 6 patches for net/master.
> 
> The first two patches are against the MAINTAINERS file and adds Appana
> Durga Kedareswara rao as maintainer for the xilinx-can driver and Sriram
> Dash for the m_can (mmio) driver.
> 
> The next patch is by Jouni Hogander and fixes a use-after-free in the
> slcan driver.
> 
> Johan Hovold's patch for the ucan driver fixes the non-atomic allocation
> in the completion handler.
> 
> The last two patches target the xilinx-can driver. The first one is by
> Venkatesh Yadav Abbarapu and skips the error message on deferred probe,
> the second one is by Srinivas Neeli and fixes the usage of the skb after
> can_put_echo_skb().

Pulled, thanks Marc.
