Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7B62027A1
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgFUAdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUAdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:33:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9829C061794;
        Sat, 20 Jun 2020 17:33:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A262B120ED49C;
        Sat, 20 Jun 2020 17:33:33 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:33:33 -0700 (PDT)
Message-Id: <20200620.173333.2149618046503257387.davem@davemloft.net>
To:     rentao.bupt@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        taoren@fb.com
Subject: Re: [PATCH net-next] of: mdio: preserve phy dev_flags in
 of_phy_connect()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618220444.5064-1-rentao.bupt@gmail.com>
References: <20200618220444.5064-1-rentao.bupt@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:33:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rentao.bupt@gmail.com
Date: Thu, 18 Jun 2020 15:04:44 -0700

> From: Tao Ren <rentao.bupt@gmail.com>
> 
> Replace assignment "=" with OR "|=" for "phy->dev_flags" so "dev_flags"
> configured in phy probe() function can be preserved.
> 
> The idea is similar to commit e7312efbd5de ("net: phy: modify assignment
> to OR for dev_flags in phy_attach_direct").
> 
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>

Applied.
