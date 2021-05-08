Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192FB3772D6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhEHP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:58:52 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:56922 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229500AbhEHP6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:58:51 -0400
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 120E2100E7B45;
        Sat,  8 May 2021 15:57:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 91409B2793;
        Sat,  8 May 2021 15:57:47 +0000 (UTC)
Message-ID: <6ea0773df765ec4d261e5e3434060622ce48d8f1.camel@perches.com>
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
From:   Joe Perches <joe@perches.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 08 May 2021 08:57:46 -0700
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.40
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 91409B2793
X-Stat-Signature: 1h3gjuode6wyq67r57fp99bcyqmajug7
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19KSTGJVGvmPqzwYwCMA96QBCKLxc9d+d0=
X-HE-Tag: 1620489467-53897
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-05-08 at 02:28 +0200, Ansuel Smith wrote:
> Fix mixed whitespace and tab for define spacing.

Incomplete commit message here.

> diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
[]
> -#define MII_CLKRANGE_60_100M                    (0 << 2)
> -#define MII_CLKRANGE_100_150M                   (1 << 2)
> -#define MII_CLKRANGE_20_35M                     (2 << 2)
> -#define MII_CLKRANGE_35_60M                     (3 << 2)
> -#define MII_CLKRANGE_150_250M                   (4 << 2)
> -#define MII_CLKRANGE_250_300M                   (5 << 2)
[]
> +#define MII_CLKRANGE(x)				((x) << 2)
> +#define MII_CLKRANGE_60_100M			MII_CLKRANGE(0)
> +#define MII_CLKRANGE_100_150M			MII_CLKRANGE(1)
> +#define MII_CLKRANGE_20_35M			MII_CLKRANGE(2)
> +#define MII_CLKRANGE_35_60M			MII_CLKRANGE(3)
> +#define MII_CLKRANGE_150_250M			MII_CLKRANGE(4)
> +#define MII_CLKRANGE_250_300M			MII_CLKRANGE(5)

Adding a define and using it isn't just whitespace.


