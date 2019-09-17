Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FFAB4CDB
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 13:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfIQL0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 07:26:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33452 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfIQL0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 07:26:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4B93020504;
        Tue, 17 Sep 2019 13:26:50 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5pTmspKPJGtE; Tue, 17 Sep 2019 13:26:49 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E1056205CB;
        Tue, 17 Sep 2019 13:26:49 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 13:26:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8E42531803B6;
 Tue, 17 Sep 2019 13:26:49 +0200 (CEST)
Date:   Tue, 17 Sep 2019 13:26:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next v2 6/6] xfrm: add espintcp (RFC 8229)
Message-ID: <20190917112649.GE2879@gauss3.secunet.de>
References: <cover.1568192824.git.sd@queasysnail.net>
 <ce5eb26c12fa07e905b9d83ef8c07485c5516ffe.1568192824.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce5eb26c12fa07e905b9d83ef8c07485c5516ffe.1568192824.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 04:13:07PM +0200, Sabrina Dubroca wrote:
...
> diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
> index 51bb6018f3bf..e67044527fb7 100644
> --- a/net/xfrm/Kconfig
> +++ b/net/xfrm/Kconfig
> @@ -73,6 +73,16 @@ config XFRM_IPCOMP
>  	select CRYPTO
>  	select CRYPTO_DEFLATE
>  
> +config XFRM_ESPINTCP
> +	bool "ESP in TCP encapsulation (RFC 8229)"
> +	depends on XFRM && INET_ESP
> +	select STREAM_PARSER
> +	select NET_SOCK_MSG
> +	help
> +	  Support for RFC 8229 encapsulation of ESP and IKE over TCP sockets.
> +
> +	  If unsure, say N.
> +

One nitpick: This is IPv4 only, so please move this below the ESP
section in net/ipv4/Kconfig and use the naming convention there.
I.e. bool "IP: ESP in TCP encapsulation (RFC 8229)"

Everything else looks very good!
