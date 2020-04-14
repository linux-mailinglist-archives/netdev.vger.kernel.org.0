Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC811A878F
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407671AbgDNRct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732341AbgDNRcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 13:32:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0191CC061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 10:32:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g32so200888pgb.6
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 10:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eu5tfJyu8mHmu9rt4YZttz81pwJSqiG4m0FXuEWFyYY=;
        b=tHFCGSA/ediQZ7wQqT9vqcxu/83xsSExEP4twP9NsGsKFTH/iMLiU6IHDDfN7M4q4S
         goUKV4c+gCrDhp0r2xOBtxKN1rFevwzYJUaTL6nx+gnlr3J5BonXssNqms6CG15pfVcL
         BFHtgdeX3pmdPjAymrTB/nVwMvXFtUY6zPpgjN3KXr0HDuvvu9wjlyqg1l5gC+f7jQH0
         ymKYwuZ8v5RfZ7o0Yv/RUri79VuBksmNoClumQLsGiBPddHh1umQEA6BFZap/vGJ+HlU
         ON/YEgNlybAZBpS7W7XfF6OJiHdCaQJehhGXMy+IAL12iDgInDUtmXKvwuzqeqXHFLVe
         22Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eu5tfJyu8mHmu9rt4YZttz81pwJSqiG4m0FXuEWFyYY=;
        b=efwxDgoZ8ug63bdyXuM983Brb7XXDHNhgwA3YpB99EDpl+B4HAL2fU0L0hKDRFBRYO
         +1ZRjmB7/gLTbUydtMbn0o5CVT6cY/u2dXo6+2JSpH/wcnp7kEPgXbsWJerlgcIzZSCW
         S6GesWIXewR4I/tcV/NYKukek7leu94aU2Cf+6weVx+SZT9qcFaMzWXATLf9BNbApLTt
         nEjyOMrUsT7TVMPXkrZN4pO210Sgw+ezxoQPDlu7NsTD7RvVnN66vFry0p9WjZt+bUn7
         OxYHd+wol4efheA+29g/Peh6FgYZ0fcefXE0CZU6oOZK3wqTiIvSDqFQ+zf7Pps/lrwA
         pmzw==
X-Gm-Message-State: AGi0PuagW2nFkAvNrdmX9owbq42Ic5dXksaThN09SagyV/RclEsdnTRr
        +6N5TpvVQ9En3hklSk7i5IVEkQ==
X-Google-Smtp-Source: APiQypKoUvt1ilDEKHY/DChkoWPSCETFSz2iDy94SOmZmXFnrNwu7SU/6Gfggm9XQrCh2wsL6/goDQ==
X-Received: by 2002:a63:140c:: with SMTP id u12mr16372504pgl.243.1586885565385;
        Tue, 14 Apr 2020 10:32:45 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x27sm11775382pfj.74.2020.04.14.10.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 10:32:44 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] drivers: Remove inclusion of vermagic header
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Borislav Petkov <bp@suse.de>, Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Pensando Drivers <drivers@pensando.io>,
        Sebastian Reichel <sre@kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-2-leon@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <823d56e6-87c2-35d2-c89e-57185ee45e7b@pensando.io>
Date:   Tue, 14 Apr 2020 10:32:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414155732.1236944-2-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 8:57 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Get rid of linux/vermagic.h includes, so that MODULE_ARCH_VERMAGIC from
> the arch header arch/x86/include/asm/module.h won't be redefined.
>
>    In file included from ./include/linux/module.h:30,
>                     from drivers/net/ethernet/3com/3c515.c:56:
>    ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC"
> redefined
>       73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
>          |
>    In file included from drivers/net/ethernet/3com/3c515.c:25:
>    ./include/linux/vermagic.h:28: note: this is the location of the
> previous definition
>       28 | #define MODULE_ARCH_VERMAGIC ""
>          |
>
> Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

for ionic driver:
Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/bonding/bonding_priv.h               | 2 +-
>   drivers/net/ethernet/3com/3c509.c                | 1 -
>   drivers/net/ethernet/3com/3c515.c                | 1 -
>   drivers/net/ethernet/adaptec/starfire.c          | 1 -
>   drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 +-
>   drivers/power/supply/test_power.c                | 2 +-
>   net/ethtool/ioctl.c                              | 3 +--
>   7 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
> index 45b77bc8c7b3..48cdf3a49a7d 100644
> --- a/drivers/net/bonding/bonding_priv.h
> +++ b/drivers/net/bonding/bonding_priv.h
> @@ -14,7 +14,7 @@
>   
>   #ifndef _BONDING_PRIV_H
>   #define _BONDING_PRIV_H
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
>   
>   #define DRV_NAME	"bonding"
>   #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
> index b762176a1406..139d0120f511 100644
> --- a/drivers/net/ethernet/3com/3c509.c
> +++ b/drivers/net/ethernet/3com/3c509.c
> @@ -85,7 +85,6 @@
>   #include <linux/device.h>
>   #include <linux/eisa.h>
>   #include <linux/bitops.h>
> -#include <linux/vermagic.h>
>   
>   #include <linux/uaccess.h>
>   #include <asm/io.h>
> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
> index 90312fcd6319..47b4215bb93b 100644
> --- a/drivers/net/ethernet/3com/3c515.c
> +++ b/drivers/net/ethernet/3com/3c515.c
> @@ -22,7 +22,6 @@
>   
>   */
>   
> -#include <linux/vermagic.h>
>   #define DRV_NAME		"3c515"
>   
>   #define CORKSCREW 1
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
> index 2db42211329f..a64191fc2af9 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -45,7 +45,6 @@
>   #include <asm/processor.h>		/* Processor type for cache alignment. */
>   #include <linux/uaccess.h>
>   #include <asm/io.h>
> -#include <linux/vermagic.h>
>   
>   /*
>    * The current frame processor firmware fails to checksum a fragment
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 588c62e9add7..3ed150512091 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -6,7 +6,7 @@
>   #include <linux/module.h>
>   #include <linux/netdevice.h>
>   #include <linux/utsname.h>
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
>   
>   #include "ionic.h"
>   #include "ionic_bus.h"
> diff --git a/drivers/power/supply/test_power.c b/drivers/power/supply/test_power.c
> index 65c23ef6408d..b3c05ff05783 100644
> --- a/drivers/power/supply/test_power.c
> +++ b/drivers/power/supply/test_power.c
> @@ -16,7 +16,7 @@
>   #include <linux/power_supply.h>
>   #include <linux/errno.h>
>   #include <linux/delay.h>
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
>   
>   enum test_power_id {
>   	TEST_AC,
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 89d0b1827aaf..d3cb5a49a0ce 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -17,7 +17,6 @@
>   #include <linux/phy.h>
>   #include <linux/bitops.h>
>   #include <linux/uaccess.h>
> -#include <linux/vermagic.h>
>   #include <linux/vmalloc.h>
>   #include <linux/sfp.h>
>   #include <linux/slab.h>
> @@ -28,7 +27,7 @@
>   #include <net/xdp_sock.h>
>   #include <net/flow_offload.h>
>   #include <linux/ethtool_netlink.h>
> -
> +#include <generated/utsrelease.h>
>   #include "common.h"
>   
>   /*

