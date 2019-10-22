Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A8BDFD89
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbfJVGK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 02:10:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfJVGK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 02:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B6AH70ZBqgtLx0kFQk1RVKIXF77SHd+j+wHyRoQQppM=; b=E35IkevnJRlH//2pPhthVoGCf
        DwV1C6o7i488Gmwp0jRbs24uKrWtWh9cE5FdD2rrdDN1IpZyh0Gb4LSDMHoJnmmv+wdQeoCETC2fk
        YjUmtNj8yLDVJRv/qH0bcl3K1lROlaTHO1AhBUu/Hnr4FdO4C1lACwx/BMrNhFcBfIA+Ugf91pkYa
        8GIFJiHDEg0P91TLnITFQ4jT2t7TK5I/BStK9zypPRsL02dvunoiwHoaQ8NnkJBKZvQ+dOznN95OG
        A9eJz9yjPOKuQbuZEHJAFemkwOtweLF8urR2XrKGa0gnYoBgMoNhQRjQ4WB9hEnieREJQ8gT6izRw
        J9jYe7Gag==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iMnNB-0008GE-Cx; Tue, 22 Oct 2019 06:10:25 +0000
Subject: Re: [PATCH v4 5/5] net: dsa: add support for Atheros AR9331 build-in
 switch
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-6-o.rempel@pengutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <84867591-e4a2-cda5-d85c-f3c65b6a2668@infradead.org>
Date:   Mon, 21 Oct 2019 23:10:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191022055743.6832-6-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 10:57 PM, Oleksij Rempel wrote:
> Provide basic support for Atheros AR9331 build-in switch. So far it

                                           built-in

> works as port multiplexer without any hardware offloading support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

> diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> new file mode 100644
> index 000000000000..7e4978f46642
> --- /dev/null
> +++ b/drivers/net/dsa/qca/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NET_DSA_AR9331
> +	tristate "Atheros AR9331 Ethernet switch support"
> +	depends on NET_DSA
> +	select NET_DSA_TAG_AR9331
> +	select REGMAP
> +	---help---
> +	  This enables support for the Atheros AR9331 build-in Ethernet

	                                              built-in

> +	  switch.
> +
> +

Thanks.
-- 
~Randy

