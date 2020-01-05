Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0903130A40
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgAEW1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:27:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40670 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEW1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:27:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EF1F1573FC16;
        Sun,  5 Jan 2020 14:27:20 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:27:19 -0800 (PST)
Message-Id: <20200105.142719.2267255724230212968.davem@davemloft.net>
To:     dmitry.torokhov@gmail.com
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH v3 0/3] net: phy: switch to using fwnode_gpiod_get_index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
References: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:27:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu,  2 Jan 2020 17:03:17 -0800

> This series switches phy drivers form using fwnode_get_named_gpiod() and
> gpiod_get_from_of_node() that are scheduled to be removed in favor
> of fwnode_gpiod_get_index() that behaves more like standard
> gpiod_get_index() and will potentially handle secondary software
> nodes in cases we need to augment platform firmware.
> 
> Now that the dependencies have been merged into networking tree the
> patches can be applied there as well.
> 
> v3:
>         - rebased on top of net-next
> 
> v2:
>         - rebased on top of Linus' W devel branch
>         - added David's ACKs

Series applied, thanks.
