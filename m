Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95406130A38
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAEWYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:24:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40594 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:24:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D46841573FC02;
        Sun,  5 Jan 2020 14:24:19 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:24:19 -0800 (PST)
Message-Id: <20200105.142419.337045213193368192.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, paweldembicki@gmail.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: vsc73xx: Remove dependency on
 CONFIG_OF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102233445.12764-1-f.fainelli@gmail.com>
References: <20200102233445.12764-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:24:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu,  2 Jan 2020 15:34:45 -0800

> There is no build time dependency on CONFIG_OF, but we do need to make
> sure we gate the initialization of the gpio_chip::of_node member with a
> proper check on CONFIG_OF_GPIO. This enables the driver to build on
> platforms that do not have CONFIG_OF enabled.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks.

Maybe if this becomes common enough we can have a helper like the
ones we have for network namespaces, something like of_node_set().
