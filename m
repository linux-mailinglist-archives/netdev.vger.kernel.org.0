Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A683D12F24A
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgACAlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:41:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgACAlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:41:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96DC4159B6441;
        Thu,  2 Jan 2020 16:41:13 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:41:13 -0800 (PST)
Message-Id: <20200102.164113.762444597958242363.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2020-01-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102160934.1524-1-mkl@pengutronix.de>
References: <20200102160934.1524-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:41:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu,  2 Jan 2020 17:09:25 +0100

> this is a pull request of 9 patches for net/master.
> 
> The first 5 patches target all the tcan4x5x driver. The first 3 patches
> of them are by Dan Murphy and Sean Nyekjaer and improve the device
> initialization (power on, reset and get device out of standby before
> register access). The next patch is by Dan Murphy and disables the INH
> pin device-state if the GPIO is unavailable. The last patch for the
> tcan4x5x driver is by Gustavo A. R. Silva and fixes an inconsistent
> PTR_ERR check in the tcan4x5x_parse_config() function.
> 
> The next patch is by Oliver Hartkopp and targets the generic CAN device
> infrastructure. It ensures that an initialized headroom in outgoing CAN
> sk_buffs (e.g. if injected by AF_PACKET).
> 
> The last 2 patches are by Johan Hovold and fix the kvaser_usb and gs_usb
> drivers by always using the current alternate setting not blindly the
> first one.

Pulled, thanks Marc.

 
