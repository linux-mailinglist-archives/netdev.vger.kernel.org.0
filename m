Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F39A1E94D7
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 03:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgEaBD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 21:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaBDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 21:03:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71444C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 18:03:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9D21128E079B;
        Sat, 30 May 2020 18:03:52 -0700 (PDT)
Date:   Sat, 30 May 2020 18:03:51 -0700 (PDT)
Message-Id: <20200530.180351.1434687967128631713.davem@davemloft.net>
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
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 18:03:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 30 May 2020 14:51:29 +0300

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
> There is a trivial dependency patch on the regmap core which is in Mark
> Brown's for-next tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?h=for-next&id=8baebfc2aca26e3fa67ab28343671b82be42b22c
> I didn't know what to do with it, so I just added it here as well, as
> 01/13, so that net-next builds wouldn't break.

Looks good, series applied, thanks.
