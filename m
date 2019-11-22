Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172CA107680
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKVRg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:36:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:36:58 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A474A1527B1C2;
        Fri, 22 Nov 2019 09:36:57 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:36:57 -0800 (PST)
Message-Id: <20191122.093657.95680289541075120.davem@davemloft.net>
To:     bot@kernelci.org
Cc:     hulkci@huawei.com, tomeu.vizoso@collabora.com,
        guillaume.tucker@collabora.com, broonie@kernel.org,
        khilman@baylibre.com, mgalka@collabora.com,
        enric.balletbo@collabora.com, yuehaibing@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: net-next/master bisection: boot on beaglebone-black
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5dd7d181.1c69fb81.64fbc.cd8a@mx.google.com>
References: <5dd7d181.1c69fb81.64fbc.cd8a@mx.google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:36:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "kernelci.org bot" <bot@kernelci.org>
Date: Fri, 22 Nov 2019 04:16:01 -0800 (PST)

>     mdio_bus: Fix PTR_ERR applied after initialization to constant
>     
>     Fix coccinelle warning:
>     
>     ./drivers/net/phy/mdio_bus.c:67:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62
>     ./drivers/net/phy/mdio_bus.c:68:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62

The kernelci.org bot has posted at least a half dozen of these bisection
results for the same exact bug, which we've fixed two days ago....

This is becomming more like spam and not very useful....
