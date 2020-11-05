Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDD82A786D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 09:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgKEIAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 03:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbgKEIAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 03:00:18 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EB3C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 00:00:18 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kaaBh-00065B-1j; Thu, 05 Nov 2020 09:00:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kaaAB-004eo7-DZ; Thu, 05 Nov 2020 08:58:31 +0100
Date:   Thu, 5 Nov 2020 08:58:31 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next v2 06/10] gtp: switch to dev_get_tstats64
Message-ID: <20201105075831.GD1078888@nataraja>
References: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
 <52d228fe-9ed3-7cd0-eebc-051c38b5e45f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52d228fe-9ed3-7cd0-eebc-051c38b5e45f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good to me.

On Wed, Nov 04, 2020 at 03:27:47PM +0100, Heiner Kallweit wrote:
> Replace ip_tunnel_get_stats64() with the new identical core fucntion
> dev_get_tstats64().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
