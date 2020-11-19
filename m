Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB472B89CD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgKSBwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgKSBwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:52:03 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F11F4246B0;
        Thu, 19 Nov 2020 01:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605750723;
        bh=MB24IZaExrsK4Rzul7nPnkTzjyE07BB/s1BFWrYk4+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ct4LN/ipyY6E+W8xPHxFV3gZu/xQ7r1jjMS7RsiYEm7Bcw9xe4O4rVE7Q4gkAsCBl
         F5VWVhFKy2AmlVHvHy44fHds2U34mj3CHnVJsElnwrIlJ8CZz93oOZhzX4nWaluhbt
         ogmOYRw3Jk9lu6mqAeD2OqJYSlCPxSWARlrOnzEY=
Date:   Wed, 18 Nov 2020 17:52:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-18
Message-ID: <20201118175202.6bee925e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118160414.2731659-1-mkl@pengutronix.de>
References: <20201118160414.2731659-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 17:04:10 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> here's a pull request for net/master consisting of 4 patches for net/master,
> 
> Jimmy Assarsson provides two patches for the kvaser_pciefd and kvaser_usb
> drivers, where the can_bittiming_const are fixed.
> 
> The next patch is by me and fixes an erroneous flexcan_transceiver_enable()
> during bus-off recovery in the flexcan driver.
> 
> Jarkko Nikula's patch for the m_can driver fixes the IRQ handler to only
> process the interrupts if the device is not suspended.

Pulled, thanks!

> P.S.: Can you merge net/master into net-next/master after merging this pull
> request?

That usually happens after Linus pulls from net, I will send a PR to him
tomorrow, and then merge net -> net-next. Hope that works for you!
