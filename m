Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B461B4D36
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDVTUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725913AbgDVTUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:20:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D828C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 12:20:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBDB8120ED563;
        Wed, 22 Apr 2020 12:20:18 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:20:17 -0700 (PDT)
Message-Id: <20200422.122017.1465452641535232301.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: add device-managed
 devm_mdiobus_register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
References: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:20:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 20 Apr 2020 23:28:19 +0200

> If there's no special ordering requirement for mdiobus_unregister(),
> then driver code can be simplified by using a device-managed version
> of mdiobus_register(). Prerequisite is that bus allocation has been
> done device-managed too. Else mdiobus_free() may be called whilst
> bus is still registered, resulting in a BUG_ON(). Therefore let
> devm_mdiobus_register() return -EPERM if bus was allocated
> non-managed.
> 
> First user of the new functionality is r8169 driver.

Series applied, thanks Heiner.
