Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5CB2B3F4D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgKPJBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:01:31 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:35337 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgKPJBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:01:31 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keaO6-0000yG-Se; Mon, 16 Nov 2020 10:01:26 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keaO5-0002tn-Pu; Mon, 16 Nov 2020 10:01:25 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 2D69F240049;
        Mon, 16 Nov 2020 10:01:25 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id A01B9240047;
        Mon, 16 Nov 2020 10:01:24 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 8BC1F20438;
        Mon, 16 Nov 2020 10:01:20 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Nov 2020 10:01:20 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [PATCH net-next] MAINTAINERS: Add Martin Schiller as a maintainer
 for the X.25 stack
Organization: TDT AG
In-Reply-To: <20201114111029.326972-1-xie.he.0141@gmail.com>
References: <20201114111029.326972-1-xie.he.0141@gmail.com>
Message-ID: <3a556cae7d869059fa3b30c921a91658@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1605517286-000074F7-6B5C9E26/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-14 12:10, Xie He wrote:
> Martin Schiller is an active developer and reviewer for the X.25 code.
> His company is providing products based on the Linux X.25 stack.
> So he is a good candidate for maintainers of the X.25 code.
> 
> The original maintainer of the X.25 network layer (Andrew Hendry) has
> not sent any email to the netdev mail list since 2013. So he is 
> probably
> inactive now.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  MAINTAINERS | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index af9f6a3ab100..ab8b2c9ad00e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9842,13 +9842,6 @@ S:	Maintained
>  F:	arch/mips/lantiq
>  F:	drivers/soc/lantiq
> 
> -LAPB module
> -L:	linux-x25@vger.kernel.org
> -S:	Orphan
> -F:	Documentation/networking/lapb-module.rst
> -F:	include/*/lapb.h
> -F:	net/lapb/
> -
>  LASI 53c700 driver for PARISC
>  M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>  L:	linux-scsi@vger.kernel.org
> @@ -18986,12 +18979,18 @@ L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  N:	axp[128]
> 
> -X.25 NETWORK LAYER
> -M:	Andrew Hendry <andrew.hendry@gmail.com>
> +X.25 STACK
> +M:	Martin Schiller <ms@dev.tdt.de>
>  L:	linux-x25@vger.kernel.org
> -S:	Odd Fixes
> +S:	Maintained
> +F:	Documentation/networking/lapb-module.rst
>  F:	Documentation/networking/x25*
> +F:	drivers/net/wan/hdlc_x25.c
> +F:	drivers/net/wan/lapbether.c
> +F:	include/*/lapb.h
>  F:	include/net/x25*
> +F:	include/uapi/linux/x25.h
> +F:	net/lapb/
>  F:	net/x25/
> 
>  X86 ARCHITECTURE (32-BIT AND 64-BIT)

Acked-by: Martin Schiller <ms@dev.tdt.de>
