Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56FD21E47E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGNA3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGNA3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:29:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69135C061755;
        Mon, 13 Jul 2020 17:29:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2901F12983237;
        Mon, 13 Jul 2020 17:29:33 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:29:32 -0700 (PDT)
Message-Id: <20200713.172932.834602346972307208.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bgolaszewski@baylibre.com,
        lkp@intel.com
Subject: Re: [PATCH] net: phy: fix mdio-mscc-miim build
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713151207.29451-1-brgl@bgdev.pl>
References: <20200713151207.29451-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:29:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 13 Jul 2020 17:12:07 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> PHYLIB is not selected by mdio-mscc-miim but it uses mdio devres helpers.
> Explicitly select MDIO_DEVRES in this driver's Kconfig entry.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1814cff26739 ("net: phy: add a Kconfig option for mdio_devres")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied to net-next, thanks.
