Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E63B1E94DB
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 03:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgEaBIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 21:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaBIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 21:08:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA721C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 18:08:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B4AE128E0CA3;
        Sat, 30 May 2020 18:08:09 -0700 (PDT)
Date:   Sat, 30 May 2020 18:08:08 -0700 (PDT)
Message-Id: <20200530.180808.1733566688666559106.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: Re: [PATCH v2 net-next 00/13] New DSA driver for VSC9953 Seville
 switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530.180351.1434687967128631713.davem@davemloft.net>
References: <20200530115142.707415-1-olteanv@gmail.com>
        <20200530.180351.1434687967128631713.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 18:08:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 30 May 2020 18:03:51 -0700 (PDT)

> Looks good, series applied, thanks.

Actually, reverted, this doesn't build:

[davem@localhost net-next]$ make -s -j14
ld: drivers/net/dsa/ocelot/seville_vsc9953.o: in function `seville_driver_init':
seville_vsc9953.c:(.init.text+0x0): multiple definition of `init_module'; drivers/net/dsa/ocelot/felix_vsc9959.o:felix_vsc9959.c:(.init.text+0x0): first defined here
ld: drivers/net/dsa/ocelot/seville_vsc9953.o: in function `seville_driver_exit':
seville_vsc9953.c:(.exit.text+0x0): multiple definition of `cleanup_module'; drivers/net/dsa/ocelot/felix_vsc9959.o:felix_vsc9959.c:(.exit.text+0x0): first defined here
make[4]: *** [scripts/Makefile.build:422: drivers/net/dsa/ocelot/mscc_felix.o] Error 1
make[3]: *** [scripts/Makefile.build:488: drivers/net/dsa/ocelot] Error 2
make[2]: *** [scripts/Makefile.build:488: drivers/net/dsa] Error 2
