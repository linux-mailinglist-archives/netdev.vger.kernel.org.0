Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B085C2D6923
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404683AbgLJUvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:51:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43572 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404583AbgLJUvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 15:51:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 68C594D2ED6E6;
        Thu, 10 Dec 2020 12:50:26 -0800 (PST)
Date:   Thu, 10 Dec 2020 12:50:26 -0800 (PST)
Message-Id: <20201210.125026.34307921940137816.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can-next 2020-12-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210095507.1551220-1-mkl@pengutronix.de>
References: <20201210095507.1551220-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 12:50:26 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 10 Dec 2020 10:55:00 +0100

> Hello Jakub, hello David,
> 
> here's a pull request of 7 patches for net-next/master.
> 
> The first patch is by Oliver Hartkopp for the CAN ISOTP, which adds support for
> functional addressing.
> 
> A patch by Antonio Quartulli removes an unneeded unlikely() annotation from the
> rx-offload helper.
> 
> The next three patches target the m_can driver. Sean Nyekjaers's patch removes
> a double clearing of clock stop request bit, Patrik Flykt's patch moves the
> runtime PM enable/disable to m_can_platform and Jarkko Nikula's patch adds a
> PCI glue code driver.
> 
> Fabio Estevam's patch converts the flexcan driver to DT only.
> 
> And Manivannan Sadhasivam's patchd for the mcp251xfd driver adds internal
> loopback mode support.

Pulled, thanks Marc.
