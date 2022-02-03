Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3134A7EC1
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 05:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349308AbiBCEyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 23:54:01 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:56388 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiBCEyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 23:54:00 -0500
Received: from [172.16.68.165] (unknown [49.255.141.98])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id DFD6A20164;
        Thu,  3 Feb 2022 12:53:48 +0800 (AWST)
Message-ID: <17bcd4cf0b983578325715f89d98c3e3f85c5a4e.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next] net: don't include ndisc.h from ipv6.h
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, oliver@neukum.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, stefan@datenfreihafen.org,
        matt@codeconstruct.com.au, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Date:   Thu, 03 Feb 2022 12:53:48 +0800
In-Reply-To: <20220203043457.2222388-1-kuba@kernel.org>
References: <20220203043457.2222388-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> Nothing in ipv6.h needs ndisc.h, drop it.

Looks good, we lose the ARPHRD definitions without ndisc.h, but your
change to add if_arp.h addresses that:

> --- a/net/mctp/device.c
> +++ b/net/mctp/device.c
> @@ -6,6 +6,7 @@
>   * Copyright (c) 2021 Google
>   */
>  
> +#include <linux/if_arp.h>
>  #include <linux/if_link.h>
>  #include <linux/mctp.h>
>  #include <linux/netdevice.h>

So, for the net/mctp part:

Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>

Cheers,


Jeremy

