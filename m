Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70C1E50BB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgE0VzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgE0VzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:55:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D79C05BD1E;
        Wed, 27 May 2020 14:55:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 662E8128CE433;
        Wed, 27 May 2020 14:54:57 -0700 (PDT)
Date:   Wed, 27 May 2020 14:54:54 -0700 (PDT)
Message-Id: <20200527.145454.1350015384207485081.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 0/2] net: mscc: allow forwarding ioctl
 operations to attached PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526150149.456719-1-antoine.tenart@bootlin.com>
References: <20200526150149.456719-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 14:54:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Tue, 26 May 2020 17:01:47 +0200

> These two patches allow forwarding ioctl to the PHY MII implementation,
> and support is added for offloading timestamping operations to
> compatible attached PHYs.

Series applied, thanks.
