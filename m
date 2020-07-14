Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934CB21E4A1
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGNAkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGNAkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:40:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2F7C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:40:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 107771298575F;
        Mon, 13 Jul 2020 17:40:38 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:40:37 -0700 (PDT)
Message-Id: <20200713.174037.991231492779820841.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: Re: [PATCH v4 net-next 00/11] New DSA driver for VSC9953 Seville
 switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:40:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 13 Jul 2020 19:57:00 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Looking at the Felix and Ocelot drivers, Maxim asked if it would be
> possible to use them as a base for a new driver for the Seville switch
> inside NXP T1040. Turns out, it is! The result is that the mscc_felix
> driver was extended to probe on Seville.
> 
> The biggest challenge seems to be getting register read/write API
> generic enough to cover such wild bitfield variations between hardware
> generations.
> 
> Currently, both felix and seville are built under the same kernel config
> option (NET_DSA_MSCC_FELIX). This has both some advantages (no need to
> duplicate the Lynx PCS code from felix_vsc9959.c) and some disadvantages
> (Seville needs to depend on PCI and on ENETC_MDIO). This will be further
> refined as time progresses.
> 
> The driver has been completely reviewed. Previous submission was here,
> it wasn't accepted due to a conflict with Mark Brown's tree, very late
> in the release cycle:
> 
> https://patchwork.ozlabs.org/project/netdev/cover/20200531122640.1375715-1-olteanv@gmail.com/
> 
> So this is more of a repost, with the only changes being related to
> rebasing on top of the cleanup I had to do in Ocelot.

Series applied, thank you.
