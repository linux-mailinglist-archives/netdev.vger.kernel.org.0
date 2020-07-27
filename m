Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6F322F91C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgG0Tcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgG0Tcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:32:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA58C061794;
        Mon, 27 Jul 2020 12:32:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89A2812768D9F;
        Mon, 27 Jul 2020 12:15:46 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:32:30 -0700 (PDT)
Message-Id: <20200727.123230.568578775098761493.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     kuba@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        volodymyr.mytnyk@plvision.eu, taras.chornyi@plvision.eu,
        andrii.savka@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        mickeyr@marvell.com
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727122242.32337-2-vadym.kochan@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
        <20200727122242.32337-2-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:15:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Mon, 27 Jul 2020 15:22:37 +0300

> +	/* called by device driver to pass event up to the higher layer */
> +	int (*recv_msg)(struct prestera_device *dev, u8 *msg, size_t size);
> +
> +	/* called by higher layer to send request to the firmware */
> +	int (*send_req)(struct prestera_device *dev, u8 *in_msg,
> +			size_t in_size, u8 *out_msg, size_t out_size,
> +			unsigned int wait);

If you type "msg", "in_msg", and "out_msg" as (void *) you can remove
a lot of unnecessary casts in this driver.

Thank you.
