Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84A32B31CE
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 02:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgKOBfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 20:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOBfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 20:35:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF6A824137;
        Sun, 15 Nov 2020 01:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605404102;
        bh=nJ2pAhnfufkVuSnXmJrq/HKSIhB8oN2ve/0CprH8c2w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sFOvmBEVvKOk/G5AUeQ2IG0HUIXLsCjj/seOlxS8c/qs+PeMAD9mzEdvQj/YcPk+1
         6soBI+ZqgJ5xN4aZzAZQq8Usk/2jkPIjPLKqyEKVGgGbrtQpJfENGkqohihb9XCt+Y
         cLlvdu4BKkjxyeyUSdczwIAsRdGYY2CePYIy77B0=
Date:   Sat, 14 Nov 2020 17:35:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-14
Message-ID: <20201114173501.023b5e49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114173358.2058600-1-mkl@pengutronix.de>
References: <20201114173358.2058600-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 18:33:44 +0100 Marc Kleine-Budde wrote:
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

Two invalid fixes tags here, do you want to respin or should I pull?
