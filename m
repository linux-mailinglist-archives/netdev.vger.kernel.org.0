Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7BC2B4989
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgKPPhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgKPPhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:37:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8C52076E;
        Mon, 16 Nov 2020 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605541031;
        bh=8yhQjmoi+yw8nJBQW5Zrxww4H7YLu7FDrE/Ns5Plccc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TnaHa4Ubs92EP+TI/go6N7IHUoDdgoHaetByqyGT4dumIdfZA5HY8aYyFJYNn7dys
         BofPGGtZccyY2ubdXmJbPyO8748c4IKU12YlCSXtRYcfEVxW0fKPnT8N7rpchj2GWi
         6nYGVaMz2XDaKnxlZlW9nNj2wDJJiRJdZBm5VLew=
Date:   Mon, 16 Nov 2020 07:37:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-15
Message-ID: <20201116073710.6170a2d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201115174131.2089251-1-mkl@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 18:41:16 +0100 Marc Kleine-Budde wrote:
> Anant Thazhemadam contributed two patches for the AF_CAN that prevent potential
> access of uninitialized member in can_rcv() and canfd_rcv().
> 
> The next patch is by Alejandro Concepcion Rodriguez and changes can_restart()
> to use the correct function to push a skb into the networking stack from
> process context.
> 
> Zhang Qilong's patch fixes a memory leak in the error path of the ti_hecc's
> probe function.
> 
> A patch by me fixes mcba_usb_start_xmit() function in the mcba_usb driver, to
> first fill the skb and then pass it to can_put_echo_skb().
> 
> Colin Ian King's patch fixes a potential integer overflow on shift in the
> peak_usb driver.
> 
> The next two patches target the flexcan driver, a patch by me adds the missing
> "req_bit" to the stop mode property comment (which was broken during net-next
> for v5.10). Zhang Qilong's patch fixes the failure handling of
> pm_runtime_get_sync().
> 
> The next seven patches target the m_can driver including the tcan4x5x spi
> driver glue code. Enric Balletbo i Serra's patch for the tcan4x5x Kconfig fix
> the REGMAP_SPI dependency handling. A patch by me for the tcan4x5x driver's
> probe() function adds missing error handling to for devm_regmap_init(), and in
> tcan4x5x_can_remove() the order of deregistration is fixed. Wu Bo's patch for
> the m_can driver fixes the state change handling in
> m_can_handle_state_change(). Two patches by Dan Murphy first introduce
> m_can_class_free_dev() and then make use of it to fix the freeing of the can
> device. A patch by Faiz Abbas add a missing shutdown of the CAN controller in
> the m_can_stop() function.

Pulled, thanks!
