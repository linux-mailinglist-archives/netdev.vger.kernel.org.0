Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98650263868
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIIVXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIIVW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:22:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716CC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:22:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1BC31298AC01;
        Wed,  9 Sep 2020 14:06:10 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:22:56 -0700 (PDT)
Message-Id: <20200909.142256.1069951789695312454.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        richardcochran@gmail.com, andre.przywara@arm.com, kuba@kernel.org,
        mcroce@redhat.com, netdev@vger.kernel.org,
        sven.auhagen@voleatech.de
Subject: Re: [PATCH net-next v4 0/6] Marvell PP2.2 PTP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909162501.GB1551@shell.armlinux.org.uk>
References: <20200909162501.GB1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:06:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Wed, 9 Sep 2020 17:25:02 +0100

> This series adds PTP support for PP2.2 hardware to the mvpp2 driver.
> Tested on the Macchiatobin eth1 port.
> 
> Note that on the Macchiatobin, eth0 uses a separate TAI block from
> eth1, and there is no hardware synchronisation between the two.

Series applied, thank you.
