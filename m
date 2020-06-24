Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685BD207EA2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgFXVdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403906AbgFXVdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:33:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09359C061573;
        Wed, 24 Jun 2020 14:33:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02C89127249CF;
        Wed, 24 Jun 2020 14:33:40 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:33:37 -0700 (PDT)
Message-Id: <20200624.143337.2058889098376110329.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v4 0/8] net: phy: mscc: PHC and timestamping
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623143014.47864-1-antoine.tenart@bootlin.com>
References: <20200623143014.47864-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:33:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Tue, 23 Jun 2020 16:30:06 +0200

> This series aims at adding support for PHC and timestamping operations
> in the MSCC PHY driver, for the VSC858x and VSC8575. Those PHYs are
> capable of timestamping in 1-step and 2-step for both L2 and L4 traffic.
 ...

Series applied to net-next, thank you.
