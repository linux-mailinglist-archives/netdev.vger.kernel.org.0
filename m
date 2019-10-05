Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C221BCC718
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJEBIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:08:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:08:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07598155695BD;
        Fri,  4 Oct 2019 18:08:24 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:08:19 -0700 (PDT)
Message-Id: <20191004.180819.285974760905355287.davem@davemloft.net>
To:     andrea.merello@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: allow for reset line to be tied to a sleepy
 GPIO controller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004135332.5746-1-andrea.merello@gmail.com>
References: <20191004135332.5746-1-andrea.merello@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:08:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Merello <andrea.merello@gmail.com>
Date: Fri,  4 Oct 2019 15:53:32 +0200

> mdio_device_reset() makes use of the atomic-pretending API flavor for
> handling the PHY reset GPIO line.
> 
> I found no hint that mdio_device_reset() is called from atomic context
> and indeed it uses usleep_range() since long time, so I would assume that
> it is OK to sleep there.
> 
> This patch switch to gpiod_set_value_cansleep() in mdio_device_reset().
> This is relevant if e.g. the PHY reset line is tied to a I2C GPIO
> controller.
> 
> This has been tested on a ZynqMP board running an upstream 4.19 kernel and
> then hand-ported on current kernel tree.
> 
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

Applied.
