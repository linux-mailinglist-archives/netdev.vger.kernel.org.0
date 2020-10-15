Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02CF28F7C9
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgJORtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgJORtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 13:49:04 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E886CC061755;
        Thu, 15 Oct 2020 10:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=IBDBfcB9UF38XCuy7sjNIvLeFBIX/xu0ZtYdH8cOzAQ=; b=oai4ij/gYzQ7yf7ANBlexuUl4l
        epDB934iV9Uo103BQxT4i2WEWw3fU4fZ4jg0MibRjWYUPx/jCUR9V+ZR/KwlPdCNQU1LG4E5kLkwl
        hgHuxW0dOVj8tfr+ukir83nDfQ2LH2YcBq9RBLopIZXD3Q0wwwX/5kjR8o3OPqMAG20r3y8d+R9bq
        aqfU1d5RgocahSEXN2Eiz1hgFmX1W9XwEOGM688mn1rl0qRxR/Gzo+UoQ/VUzUieYRUfslrk9gwvu
        JjzaG5fUjEj6rasjEMxx9Y3nNslIGRTyOKbbnFdJNBN1i54XlCxwrZEC4SQI9b4U28vctg+cbqFVa
        6MBFu1Pw==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kT7N6-0000w2-LT; Thu, 15 Oct 2020 17:49:00 +0000
Subject: Re: linux-next: Tree for Oct 15 (drivers/net/pcs/pcs-xpcs.o)
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201015182859.7359c7be@canb.auug.org.au>
 <e507b1ec-a3ae-0eaa-8fed-6c77427325c3@infradead.org>
 <BN6PR12MB17798590707177F08FD60653D3020@BN6PR12MB1779.namprd12.prod.outlook.com>
 <20201015170204.bnnpgogczjiwntyc@skbuf>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3418cac1-eff7-d06a-6ba7-9877f0f266e9@infradead.org>
Date:   Thu, 15 Oct 2020 10:48:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201015170204.bnnpgogczjiwntyc@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/20 10:02 AM, Ioana Ciornei wrote:
> On Thu, Oct 15, 2020 at 03:06:42PM +0000, Jose Abreu wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>> Date: Oct/15/2020, 15:45:57 (UTC+00:00)
>>
>>> On 10/15/20 12:28 AM, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Since the merge window is open, please do not add any v5.11 material to
>>>> your linux-next included branches until after v5.10-rc1 has been released.
>>>>
>>>> News: there will be no linux-next releases next Monday or Tuesday.
>>>>
>>>> Changes since 20201013:
>>>>
>>>
>>> on i386:
>>>
>>> ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_read':
>>> pcs-xpcs.c:(.text+0x29): undefined reference to `mdiobus_read'
>>> ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_soft_reset.constprop.7':
>>> pcs-xpcs.c:(.text+0x80): undefined reference to `mdiobus_write'
>>> ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_config_aneg':
>>> pcs-xpcs.c:(.text+0x318): undefined reference to `mdiobus_write'
>>> ld: pcs-xpcs.c:(.text+0x38e): undefined reference to `mdiobus_write'
>>> ld: pcs-xpcs.c:(.text+0x3eb): undefined reference to `mdiobus_write'
>>> ld: pcs-xpcs.c:(.text+0x437): undefined reference to `mdiobus_write'
>>> ld: drivers/net/pcs/pcs-xpcs.o:pcs-xpcs.c:(.text+0xb1e): more undefined references to `mdiobus_write' follow
>>>
>>>
> 
> I think this stems from the fact that PHYLIB is configured as a module
> which leads to MDIO_BUS being a module as well while the XPCS is still
> built-in. What should happen in this configuration is that PCS_XPCS
> should be forced to build as module. However, that select only acts in
> the opposite way so we should turn it into a depends.
> 
> Is the below patch acceptable? If it is, I can submit it properly.

Hi,
Did you copy-paste this patch?  It contains spaces instead of tabs
so it doesn't apply cleanly/easily, but I managed to apply and test it, so

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
> index 074fb3f5db18..22ba7b0b476d 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -7,8 +7,7 @@ menu "PCS device drivers"
> 
>  config PCS_XPCS
>         tristate "Synopsys DesignWare XPCS controller"
> -       select MDIO_BUS
> -       depends on MDIO_DEVICE
> +       depends on MDIO_DEVICE && MDIO_BUS
>         help
>           This module provides helper functions for Synopsys DesignWare XPCS
>           controllers.
> 
> Ioana

thanks.

-- 
~Randy
