Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0B3399CA2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFCIgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:36:11 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:56558 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFCIgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 04:36:11 -0400
X-Greylist: delayed 791 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2021 04:36:10 EDT
Received: from [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504] (p200300e9d72228a192405b8af0370504.dip0.t-ipconnect.de [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id E8697C0183;
        Thu,  3 Jun 2021 10:34:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1622709265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oauhH3Ixt97LDuDikBnAm6GsqUl3zbClERjs993Fk2I=;
        b=A0F3+WPm4XPjnrnkbXdkKlPdCWQNBoecFzV6Rqh+hLlZI6kX/hYZ6KunETx7qKqehJFzYp
        1WY1uxKcygpyT+TZ0B6bIh8w1S4CqAnSGTsf+e9ASOMOvBDOBe8iZwZ0JXp90mAm0FctEy
        pKEe+GQ9O+4B1EWmTBbQA4PV3YvLzIOq6ExO1oVgPFDkIJ/uQYATz6AQMU+PSVamypNuCc
        d8ksBRFBAnK+fA73Of8+QmwitMKVgWnbncCR7sePUvVqOQD7EJFjlZa3PSvtvZUPVct0p3
        kV3PObiHRhU3B8dGS+9UYd2xwu3ZF9P5xmIhd9bC88zv3bjuYXzeaofdbmqdWg==
Subject: Re: [PATCH v1 1/1] mrf29j40: Drop unneeded of_match_ptr()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alan Ott <alan@signal11.us>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210531132226.47081-1-andriy.shevchenko@linux.intel.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <5dd2a42d-b218-0b23-aa14-7e5681e0fb3a@datenfreihafen.org>
Date:   Thu, 3 Jun 2021 10:34:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531132226.47081-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 31.05.21 15:22, Andy Shevchenko wrote:
> Driver can be used in different environments and moreover, when compiled
> with !OF, the compiler may issue a warning due to unused mrf24j40_of_match
> variable. Hence drop unneeded of_match_ptr() call.
> 
> While at it, update headers block to reflect above changes.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/net/ieee802154/mrf24j40.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
> index b9be530b285f..ff83e00b77af 100644
> --- a/drivers/net/ieee802154/mrf24j40.c
> +++ b/drivers/net/ieee802154/mrf24j40.c
> @@ -8,8 +8,8 @@
>   
>   #include <linux/spi/spi.h>
>   #include <linux/interrupt.h>
> +#include <linux/mod_devicetable.h>
>   #include <linux/module.h>
> -#include <linux/of.h>
>   #include <linux/regmap.h>
>   #include <linux/ieee802154.h>
>   #include <linux/irq.h>
> @@ -1388,7 +1388,7 @@ MODULE_DEVICE_TABLE(spi, mrf24j40_ids);
>   
>   static struct spi_driver mrf24j40_driver = {
>   	.driver = {
> -		.of_match_table = of_match_ptr(mrf24j40_of_match),
> +		.of_match_table = mrf24j40_of_match,
>   		.name = "mrf24j40",
>   	},
>   	.id_table = mrf24j40_ids,
> 

I took the freedom to fix the typo in the subject line and add a better 
prefix:

net: ieee802154: mrf24j40: Drop unneeded of_match_ptr()

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
