Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CBCB6E67
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387658AbfIRUrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:47:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40168 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387492AbfIRUrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:47:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so523183pgj.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 13:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6L+VjzcHswaXTY/zBXV0IzeQ41/pBTuQGxWIV6p+PQ0=;
        b=kbz3gJCTYu/9N2PsX9/677GNQ2MURRJArq/xJv3ayCLI8gWWCxJCFEGPe+ugqae2Op
         lyc6xzcjb1ygHE+Rfe1DwLr4gr6kvLBu7wlkBbbLhoh6np1j8yp9t8A8ADWCT/E920gp
         gF1uYD/q88hEPOnaqJ6c/jY2EAKrG75a9O6iixygduVU02O/V7wEIUixf1G0JANSSahx
         1WykHopA8+iU2tUFKK32H/uQkQZwXFDnfPLYtO/cIXUyWwu5eOscKnZzydOUXobNlSjR
         iRa7gOtHgg561aCZhMeEy+f/FXLuZ7bW38A9DMstE7V+G3u/Woy7B/K4n2mjzPDkOQXc
         JFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6L+VjzcHswaXTY/zBXV0IzeQ41/pBTuQGxWIV6p+PQ0=;
        b=Cj9BMQLpbAtScK0KPrcgtdqEgjDIMgbpSdK2RUd3O9fwx+D0WZarh81jo4EovGoA/I
         zgA9M/zt1iHbKdQ04/TMF4dO9VVs8uAZqDvUeMJZLuRvNYgvz6ZGscfe55aJh/O4XhcV
         GvmDUSicjfPqVWtpQCv6L5ZljFGRuSD8dU62yCUEBXOQIYxrsH1mxbcF83xOg3c+UBCc
         ncj/fvPoOWbRGo+cwCZi1aaEM54LiPATkb/bfLjrt2l23dqtWE7GcCngijeHJkh2Qrc5
         fvSLUYRmcIORy8yVHmbpixOE58lyBfgjQrJA8+U8piYp8Ok7EA/fYIhq4lzulpGZT6mr
         m/BA==
X-Gm-Message-State: APjAAAVZuBWNGxugngW+gJVZ0skp439Tx0Ariq8XBS1fWgy/tDJuCFkK
        +S8UjvnUW2n/4Te+L5lgB83VPQ==
X-Google-Smtp-Source: APXvYqwuep5pewN0WPqjzbukkq/+BWVHR/FT3LTBOlPZv/Mprtab8gW5fvaHzSRHvWgfWVIo1gKR6w==
X-Received: by 2002:a17:90a:17c5:: with SMTP id q63mr270784pja.106.1568839659039;
        Wed, 18 Sep 2019 13:47:39 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j1sm6051803pgl.12.2019.09.18.13.47.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 13:47:38 -0700 (PDT)
Subject: Re: [PATCH] dynamic_debug: provide dynamic_hex_dump stub
To:     Arnd Bergmann <arnd@arndb.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@akamai.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190918195607.2080036-1-arnd@arndb.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <91b69922-926a-9c27-3a08-e2db2d7ea66f@pensando.io>
Date:   Wed, 18 Sep 2019 13:47:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190918195607.2080036-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 12:55 PM, Arnd Bergmann wrote:
> The ionic driver started using dymamic_hex_dump(), but
> that is not always defined:
>
> drivers/net/ethernet/pensando/ionic/ionic_main.c:229:2: error: implicit declaration of function 'dynamic_hex_dump' [-Werror,-Wimplicit-function-declaration]
>
> Add a dummy implementation to use when CONFIG_DYNAMIC_DEBUG
> is disabled, printing nothing.
>
> Fixes: 938962d55229 ("ionic: Add adminq action")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 2 ++
>   drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 ++
>   include/linux/dynamic_debug.h                    | 6 ++++++
>   3 files changed, 10 insertions(+)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index db7c82742828..a255d24c8e40 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1,6 +1,8 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>   
> +#include <linux/printk.h>
> +#include <linux/dynamic_debug.h>
>   #include <linux/netdevice.h>
>   #include <linux/etherdevice.h>
>   #include <linux/rtnetlink.h>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 15e432386b35..aab311413412 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -1,6 +1,8 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>   
> +#include <linux/printk.h>
> +#include <linux/dynamic_debug.h>
>   #include <linux/module.h>
>   #include <linux/netdevice.h>
>   #include <linux/utsname.h>
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index 6c809440f319..4cf02ecd67de 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -204,6 +204,12 @@ static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
>   	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
>   #define dynamic_dev_dbg(dev, fmt, ...)					\
>   	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
> +#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
> +			 groupsize, buf, len, ascii)			\
> +	do { if (0)							\
> +		print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
> +				rowsize, groupsize, buf, len, ascii);	\
> +	} while (0)
>   #endif
>   
>   #endif

Thanks, I hadn't had a chance to look into that one yet.

Acked-by: Shannon Nelson <snelson@pensando.io>


