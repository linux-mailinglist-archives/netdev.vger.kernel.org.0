Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF521176F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgGBAtN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Jul 2020 20:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgGBAtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:49:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABADC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:49:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C66F14E5284A;
        Wed,  1 Jul 2020 17:49:11 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:49:11 -0700 (PDT)
Message-Id: <20200701.174911.118957461892336534.davem@davemloft.net>
To:     helmut.grohne@intenta.de
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH] net: dsa: microchip: enable ksz9893 via i2c in the
 ksz9477 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701112216.GA8098@laureti-dev>
References: <20200701112216.GA8098@laureti-dev>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:49:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>
Date: Wed, 1 Jul 2020 13:22:20 +0200

> The KSZ9893 3-Port Gigabit Ethernet Switch can be controlled via SPI,
> I²C or MDIO (very limited and not supported by this driver). While there
> is already a compatible entry for the SPI bus, it was missing for I²C.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Applied, thank you.
