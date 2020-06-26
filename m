Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF96420BA6E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgFZUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:40:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24DBC03E979;
        Fri, 26 Jun 2020 13:40:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45D0511F5F637;
        Fri, 26 Jun 2020 13:40:36 -0700 (PDT)
Date:   Fri, 26 Jun 2020 13:40:35 -0700 (PDT)
Message-Id: <20200626.134035.2092614267932258749.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bgolaszewski@baylibre.com
Subject: Re: [PATCH 0/6] net: phy: relax PHY and MDIO reset handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626155325.7021-1-brgl@bgdev.pl>
References: <20200626155325.7021-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 13:40:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 26 Jun 2020 17:53:19 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Previously these patches were submitted as part of a larger series[1]
> but since the approach in it will have to be reworked I'm resending
> the ones that were non-controversial and have been reviewed for upstream.
> 
> Florian suggested a better solution for managing multiple resets. While
> I will definitely try to implement something at the driver model's bus
> level (together with regulator support), the 'resets' and 'reset-gpios'
> DT property is a stable ABI defined in mdio.yaml so improving its support
> is in order as we'll have to stick with it anyway. Current implementation
> contains an unnecessary limitation where drivers without probe() can't
> define resets.
> 
> Changes from the previous version:
> - order forward declarations in patch 4 alphabetically
> - collect review tags
> 
> [1] https://lkml.org/lkml/2020/6/22/253

Series applied, thank you.
