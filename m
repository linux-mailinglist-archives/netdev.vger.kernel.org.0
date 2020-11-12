Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEBA2B0008
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 08:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKLHGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 02:06:47 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:55529 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgKLHGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 02:06:46 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kd6gr-00073C-OT; Thu, 12 Nov 2020 08:06:41 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kd6gq-0004Kh-N8; Thu, 12 Nov 2020 08:06:40 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E420B24004B;
        Thu, 12 Nov 2020 08:06:39 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 6059A240049;
        Thu, 12 Nov 2020 08:06:39 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B0A1220D08;
        Thu, 12 Nov 2020 08:06:37 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Nov 2020 08:06:37 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next RFC] MAINTAINERS: Add Martin Schiller as a
 maintainer for the X.25 stack
Organization: TDT AG
In-Reply-To: <20201111213608.27846-1-xie.he.0141@gmail.com>
References: <20201111213608.27846-1-xie.he.0141@gmail.com>
Message-ID: <7baa879ed48465e7af27d4cbbe41c3e6@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1605164801-000013A4-3E0AC6AD/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-11 22:36, Xie He wrote:
> Hi Martin Schiller, would you like to be a maintainer for the X.25 
> stack?
> 
> As we know the linux-x25 mail list has stopped working for a long time.
> Adding you as a maintainer may make you be Cc'd for new patches so that
> you can review them.

About 1 year ago I was asked by Arnd Bergmann if I would like to become
the maintainer for the X.25 stack:

https://patchwork.ozlabs.org/project/netdev/patch/20191209151256.2497534-4-arnd@arndb.de/#2320767

Yes, I would agree to be listed as a maintainer.

But I still think it is important that we either repair or delete the
linux-x25 mailing list. The current state that the messages are going
into nirvana is very unpleasant.

> 
> The original maintainer of X.25 network layer (Andrew Hendry) has 
> stopped
> sending emails to the netdev mail list since 2013. So there is 
> practically
> no maintainer for X.25 code currently.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  MAINTAINERS | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2a0fde12b650..9ebcb0708d5d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9832,13 +9832,6 @@ S:	Maintained
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
> @@ -18979,12 +18972,19 @@ L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  N:	axp[128]
> 
> -X.25 NETWORK LAYER
> -M:	Andrew Hendry <andrew.hendry@gmail.com>
> +X.25 STACK
> +M:	Martin Schiller <ms@dev.tdt.de>
>  L:	linux-x25@vger.kernel.org
> -S:	Odd Fixes
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/networking/lapb-module.txt
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
