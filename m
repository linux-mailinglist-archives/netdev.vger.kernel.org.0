Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA935997D3
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347003AbiHSIpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347774AbiHSIpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:45:35 -0400
X-Greylist: delayed 84 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Aug 2022 01:45:34 PDT
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0597DBFAB1
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:45:33 -0700 (PDT)
X-Envelope-From: thomas@x-berg.in-berlin.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 27J8hdYm2632683
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:43:39 +0200
Received: from thomas by x-berg.in-berlin.de with local (Exim 4.94.2)
        (envelope-from <thomas@x-berg.in-berlin.de>)
        id 1oOxbO-0005Fh-V0; Fri, 19 Aug 2022 10:43:38 +0200
Date:   Fri, 19 Aug 2022 10:43:38 +0200
From:   Thomas Osterried <thomas@osterried.de>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     netdev@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-hams@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Thomas Osterried <thomas@osterried.de>
Subject: Re: [PATCH net-next 1/1] MAINTAINERS: update amateur radio status.
Message-ID: <Yv9NOmXjRLf6WSCB@x-berg.in-berlin.de>
References: <Yv6fCCB3vW++EGaP@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv6fCCB3vW++EGaP@electric-eye.fr.zoreil.com>
Sender: Thomas Osterried <thomas@x-berg.in-berlin.de>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I disagree.

I hoped Ralf will come back and waited with my offer to do the maintainership.

A question for the process: What needs to be done to get listet as maintainer?

vy 73,
	- Thomas  dl9sau


On Thu, Aug 18, 2022 at 10:20:24PM +0200, Francois Romieu wrote:
> There is still useful work in the linux kernel amateur radio area but
> it should not hurt to align advertised expectations in MAINTAINERS file
> with Ralf Baechle's stance from 2021/07/17.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> Link: https://marc.info/?l=linux-hams&m=162651322506623
> ---
>  MAINTAINERS | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f2d64020399b..691aa4e84537 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3436,7 +3436,7 @@ F:	drivers/iio/adc/hx711.c
>  AX.25 NETWORK LAYER
>  M:	Ralf Baechle <ralf@linux-mips.org>
>  L:	linux-hams@vger.kernel.org
> -S:	Maintained
> +S:	Odd Fixes
>  W:	http://www.linux-ax25.org/
>  F:	include/net/ax25.h
>  F:	include/uapi/linux/ax25.h
> @@ -14074,7 +14074,7 @@ F:	net/netfilter/
>  NETROM NETWORK LAYER
>  M:	Ralf Baechle <ralf@linux-mips.org>
>  L:	linux-hams@vger.kernel.org
> -S:	Maintained
> +S:	Odd Fixes
>  W:	http://www.linux-ax25.org/
>  F:	include/net/netrom.h
>  F:	include/uapi/linux/netrom.h
> @@ -17640,7 +17640,7 @@ F:	include/linux/mfd/rohm-shared.h
>  ROSE NETWORK LAYER
>  M:	Ralf Baechle <ralf@linux-mips.org>
>  L:	linux-hams@vger.kernel.org
> -S:	Maintained
> +S:	Odd Fixes
>  W:	http://www.linux-ax25.org/
>  F:	include/net/rose.h
>  F:	include/uapi/linux/rose.h
> -- 
> 2.37.1
> 
> 
