Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B59069DBFB
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 09:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbjBUIdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 03:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjBUIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 03:33:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943DB7687
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:33:02 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pUO4q-0001xH-D0; Tue, 21 Feb 2023 09:32:44 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pUO4p-0003Ar-1R; Tue, 21 Feb 2023 09:32:43 +0100
Date:   Tue, 21 Feb 2023 09:32:43 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Bo Liu <liubo03@inspur.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rempel-privat.de, bagasdotme@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
Message-ID: <20230221083243.GE19238@pengutronix.de>
References: <20230221083036.2414-1-liubo03@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230221083036.2414-1-liubo03@inspur.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 03:30:36AM -0500, Bo Liu wrote:
> Remove the repeated word "for" in comments.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/ethtool/pse-pd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
> index a5b607b0a652..530b8b99e6df 100644
> --- a/net/ethtool/pse-pd.c
> +++ b/net/ethtool/pse-pd.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  //
> -// ethtool interface for for Ethernet PSE (Power Sourcing Equipment)
> +// ethtool interface for Ethernet PSE (Power Sourcing Equipment)
>  // and PD (Powered Device)
>  //
>  // Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
> -- 
> 2.27.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
