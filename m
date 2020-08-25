Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DA6251E20
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHYRUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:20:03 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626CEC061574;
        Tue, 25 Aug 2020 10:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=J0sCtfCRKI0PUi5IGIcZ/gUzI83eFMEqQ3PM5FwtjnU=; b=3dQF/4f0dY0Lx3K4jejK7ksnPs
        jAXQ8un2Eb6vaIXj7mboT6pCfFyq51VgHnlBq9iOio2foQH9p09N3qiBh8/wZA2Tswx5qTGQmlWSU
        U1n7V1ukJ+6fUnvIZNRGXmfQPQgnW8iZJzs3YnppULCjIjGShBVQVi88bXMTyDP74LGzWlf0+VYyx
        Hv6LdyaSh8MBiZiWSSri20H/0UsG4dewv4fo6N2FwxMUFmOQEvUKADfGOaH4xqCRKQoNWygHI1Vxb
        58xV/XZTak50R5yOXhncjrLF75qJuNmKgYgZEDzAk8oWWN+mX3hRA9FlNnN1jYWFRbR7whN6Vt4IT
        1gniMZzQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAcc1-0004rI-4Q; Tue, 25 Aug 2020 17:19:57 +0000
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
To:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     m.szyprowski@samsung.com, b.zolnierkie@samsung.com
References: <CGME20200825170322eucas1p2c6619aa3e02d2762e07da99640a2451c@eucas1p2.samsung.com>
 <20200825170311.24886-1-l.stelmach@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6062dc73-99bc-cde0-26a1-5c40ea1447bd@infradead.org>
Date:   Tue, 25 Aug 2020 10:19:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825170311.24886-1-l.stelmach@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/20 10:03 AM, Łukasz Stelmach wrote:
> diff --git a/drivers/net/ethernet/asix/Kconfig b/drivers/net/ethernet/asix/Kconfig
> new file mode 100644
> index 000000000000..4b127a4a659a
> --- /dev/null
> +++ b/drivers/net/ethernet/asix/Kconfig
> @@ -0,0 +1,20 @@
> +#
> +# Asix network device configuration
> +#
> +
> +config NET_VENDOR_ASIX
> +	bool "Asix devices"

Most vendor entries also have:
	default y
so that they will be displayed in the config menu.

> +	depends on SPI
> +	help
> +	  If you have a network (Ethernet) interface based on a chip from ASIX, say Y
> +
> +if NET_VENDOR_ASIX
> +
> +config SPI_AX88796C
> +	tristate "Asix AX88796C-SPI support"
> +	depends on SPI

That line is redundant (but not harmful).

> +	depends on GPIOLIB
> +	help
> +	  Say Y here if you intend to attach a Asix AX88796C as SPI mode
> +
> +endif # NET_VENDOR_ASIX


-- 
~Randy

