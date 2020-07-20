Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA722587C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgGTHaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:30:46 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:45164 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTHap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 03:30:45 -0400
Received: from localhost.localdomain (p200300e9d7371614ec13d59c95910a08.dip0.t-ipconnect.de [IPv6:2003:e9:d737:1614:ec13:d59c:9591:a08])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 3004EC237B;
        Mon, 20 Jul 2020 09:30:43 +0200 (CEST)
Subject: Re: [PATCH for v5.9] net: ieee802154: adf7242: Replace HTTP links
 with HTTPS ones
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        michael.hennerich@analog.com, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200719113142.58304-1-grandmaster@al2klimov.de>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <03503036-0f13-7bde-5d11-6d7f61fad37e@datenfreihafen.org>
Date:   Mon, 20 Jul 2020 09:30:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200719113142.58304-1-grandmaster@al2klimov.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.07.20 13:31, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>    If not .svg:
>      For each line:
>        If doesn't contain `\bxmlns\b`:
>          For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>              If both the HTTP and HTTPS versions
>              return 200 OK and serve the same content:
>                Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>   Continuing my work started at 93431e0607e5.
>   See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>   (Actually letting a shell for loop submit all this stuff for me.)
> 
>   If there are any URLs to be removed completely
>   or at least not (just) HTTPSified:
>   Just clearly say so and I'll *undo my change*.
>   See also: https://lkml.org/lkml/2020/6/27/64
> 
>   If there are any valid, but yet not changed URLs:
>   See: https://lkml.org/lkml/2020/6/26/837
> 
>   If you apply the patch, please let me know.
> 
>   Sorry again to all maintainers who complained about subject lines.
>   Now I realized that you want an actually perfect prefixes,
>   not just subsystem ones.
>   I tried my best...
>   And yes, *I could* (at least half-)automate it.
>   Impossible is nothing! :)
> 
> 
>   drivers/net/ieee802154/adf7242.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
> index 5a37514e4234..60a016a6806a 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -4,7 +4,7 @@
>    *
>    * Copyright 2009-2017 Analog Devices Inc.
>    *
> - * http://www.analog.com/ADF7242
> + * https://www.analog.com/ADF7242
>    */
>   
>   #include <linux/kernel.h>
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
