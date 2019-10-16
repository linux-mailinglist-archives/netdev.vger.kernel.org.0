Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4DD8644
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390855AbfJPDSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:18:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfJPDSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:18:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23A93128F386E;
        Tue, 15 Oct 2019 20:18:30 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:18:29 -0700 (PDT)
Message-Id: <20191015.201829.835677207710018271.davem@davemloft.net>
To:     dmitry.torokhov@gmail.com
Cc:     linus.walleij@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:18:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 14 Oct 2019 10:40:19 -0700

> This series switches phy drivers form using fwnode_get_named_gpiod() and
> gpiod_get_from_of_node() that are scheduled to be removed in favor
> of fwnode_gpiod_get_index() that behaves more like standard
> gpiod_get_index() and will potentially handle secondary software
> nodes in cases we need to augment platform firmware.
> 
> Linus, as David would prefer not to pull in the immutable branch but
> rather route the patches through the tree that has the new API, could
> you please take them with his ACKs?

Indeed, please do, also for series:

Acked-by: David S. Miller <davem@davemloft.net>
