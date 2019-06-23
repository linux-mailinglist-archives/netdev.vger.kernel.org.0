Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339F64FADC
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfFWJGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:06:15 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:40584 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFWJGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:06:15 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 05:06:12 EDT
Received: from smtp6.infomaniak.ch (smtp6.infomaniak.ch [83.166.132.19])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5N8v4C2028859
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jun 2019 10:57:04 +0200
Received: from [192.168.1.25] (lin67-1-82-227-56-158.fbx.proxad.net [82.227.56.158])
        (authenticated bits=0)
        by smtp6.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5N8v2i0004973
        (version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO);
        Sun, 23 Jun 2019 10:57:03 +0200
Subject: Re: [PATCH] sis900: increment revision number
To:     Sergej Benilov <sergej.benilov@googlemail.com>,
        netdev@vger.kernel.org
References: <20190623074707.6348-1-sergej.benilov@googlemail.com>
From:   Daniele Venzano <venza@brownhat.org>
Message-ID: <1a676bde-9a76-d2d9-65b4-9ff32ad2ae9c@brownhat.org>
Date:   Sun, 23 Jun 2019 10:57:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190623074707.6348-1-sergej.benilov@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry to be late in replying, I am ok also with the previous changes.

Signed-off-by: Daniele Venzano <venza@brownhat.org>

On 23/06/2019 09:47, Sergej Benilov wrote:
> Increment revision number to 1.08.11 (TX completion fix).
>
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
> ---
>   drivers/net/ethernet/sis/sis900.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
> index abb9b42e..09b4e1c5 100644
> --- a/drivers/net/ethernet/sis/sis900.c
> +++ b/drivers/net/ethernet/sis/sis900.c
> @@ -1,6 +1,6 @@
>   /* sis900.c: A SiS 900/7016 PCI Fast Ethernet driver for Linux.
>      Copyright 1999 Silicon Integrated System Corporation
> -   Revision:	1.08.10 Apr. 2 2006
> +   Revision:	1.08.11 Jun. 23 2019
>   
>      Modified from the driver which is originally written by Donald Becker.
>   
> @@ -16,7 +16,8 @@
>      preliminary Rev. 1.0 Nov. 10, 1998
>      SiS 7014 Single Chip 100BASE-TX/10BASE-T Physical Layer Solution,
>      preliminary Rev. 1.0 Jan. 18, 1998
> -
> +
> +   Rev 1.08.11 Jun. 23 2019 Sergej Benilov TX completion fix
>      Rev 1.08.10 Apr.  2 2006 Daniele Venzano add vlan (jumbo packets) support
>      Rev 1.08.09 Sep. 19 2005 Daniele Venzano add Wake on LAN support
>      Rev 1.08.08 Jan. 22 2005 Daniele Venzano use netif_msg for debugging messages
> @@ -79,7 +80,7 @@
>   #include "sis900.h"
>   
>   #define SIS900_MODULE_NAME "sis900"
> -#define SIS900_DRV_VERSION "v1.08.10 Apr. 2 2006"
> +#define SIS900_DRV_VERSION "v1.08.11 Jun. 23 2019"
>   
>   static const char version[] =
>   	KERN_INFO "sis900.c: " SIS900_DRV_VERSION "\n";
