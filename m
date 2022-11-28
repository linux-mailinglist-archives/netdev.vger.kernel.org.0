Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E563A80F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiK1MTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiK1MSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:18:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1521C127
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:10:29 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcxo-0000U9-Ib; Mon, 28 Nov 2022 13:10:20 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcxn-0006XW-MB; Mon, 28 Nov 2022 13:10:19 +0100
Date:   Mon, 28 Nov 2022 13:10:19 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v1 00/26] net: dsa: microchip: stats64, fdb, error
Message-ID: <20221128121019.GA23860@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 01:00:08PM +0100, Oleksij Rempel wrote:

Sorry, I double send this series by accident. Please ignore the second
one.

> This patch series is a result of maintaining work on ksz8 part of
> microchip driver. It includes stats64 and fdb support. Error handling.
> Loopback fix and so on...
> 
> Oleksij Rempel (26):
>   net: dsa: microchip: add stats64 support for ksz8 series of switches
>   net: dsa: microchip: ksz8: ksz8_fdb_dump: fix port validation and VID
>     information
>   net: dsa: microchip: ksz8: ksz8_fdb_dump: fix not complete fdb
>     extraction
>   net: dsa: microchip: ksz8: ksz8_fdb_dump: fix time stamp extraction
>   net: dsa: microchip: ksz8: ksz8_fdb_dump: do not extract ghost entry
>     from empty table
>   net: dsa: microchip: ksz8863_smi: fix bulk access
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): remove timestamp support
>   net: dsa: microchip: make ksz8_r_dyn_mac_table() static
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): remove fid support
>   net: dsa: microchip: ksz8: refactor ksz8_fdb_dump()
>   net: dsa: microchip: ksz8: ksz8_fdb_dump: dump static MAC table
>   net: dsa: microchip: ksz8: move static mac table operations to a
>     separate functions
>   net: dsa: microchip: ksz8: add fdb_add/del support
>   net: dsa: microchip: KSZ88x3 fix loopback support
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): move main part of the
>     code out of if statement
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): use ret instead of rc
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): ksz: do not return EAGAIN
>     on timeout
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): return read/write error
>     if we got any
>   net: dsa: microchip: ksz8_r_dyn_mac_table(): use entries variable to
>     signal 0 entries
>   net: dsa: microchip: make ksz8_r_sta_mac_table() static
>   net: dsa: microchip: ksz8_r_sta_mac_table(): do not use error code for
>     empty entries
>   net: dsa: microchip: ksz8_r_sta_mac_table(): make use of error values
>     provided by read/write functions
>   net: dsa: microchip: make ksz8_w_sta_mac_table() static
>   net: dsa: microchip: ksz8_w_sta_mac_table(): make use of error values
>     provided by read/write functions
>   net: dsa: microchip: remove ksz_port:on variable
>   net: dsa: microchip: ksz8: do not force flow control by default
> 
>  drivers/net/dsa/microchip/ksz8.h        |  14 +-
>  drivers/net/dsa/microchip/ksz8795.c     | 440 +++++++++++++++---------
>  drivers/net/dsa/microchip/ksz8795_reg.h |   2 +
>  drivers/net/dsa/microchip/ksz8863_smi.c |  10 +-
>  drivers/net/dsa/microchip/ksz_common.c  | 100 +++++-
>  drivers/net/dsa/microchip/ksz_common.h  |   2 +-
>  6 files changed, 377 insertions(+), 191 deletions(-)
> 
> -- 
> 2.30.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
