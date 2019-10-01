Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DAEC39C5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbfJAQBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:01:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39895 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731231AbfJAQBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:01:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id e1so4433253pgj.6
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=idbzkM4Uy3IgWjz+crMW94nlfJxR/IgtZnRXVc7jjQk=;
        b=ApBg4e0yJjPYuGCRnLEys1GKToPLkmDDLlkuiZK8QZQy0EDHWuth01D6nqOvq4KAng
         Z0xcmh0o0od7yoNPG8gHR80kaxpgRzAAktzpBL8shUTR1GFsfJe4mSG1hMAwKDOT1yWg
         J8ljpl4j3PadYPdWA7eAqvUwMwNQAiR3H8bZ5IZlzKO3SjwsFmclT20PH9vcvMoqiuDA
         G+xYsPanBp0ne/KalGKxAYfevIt56y1/L7mABnxch+Hf7TVW/9H/b2IYS92klbfZ49/x
         ptovyq44ZiQdLsVxb7ilymFMi49nWOXlRWTSakofVVx4o4PqxI1ItGnIC/E2AthqF6uW
         XvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=idbzkM4Uy3IgWjz+crMW94nlfJxR/IgtZnRXVc7jjQk=;
        b=nqrXhTEWPYqfn6R7HrRA5zP4Oeimc728OqOBePVK9bGM8AUO9IcU+q+dG/U87n50f1
         Po6NTbiZTv4NvskxZsoHgwbTeQ7m9eV5XpGnVJBAStLFkLgPYvpznmsbglPKGR+xRmZg
         7LbmIky+cCNZu1olGNH9a8qylTUCJewqqkzTsrMg/SGhNqZNFKVv9hQzMhYes1DY836G
         9MOuwurwFnUjIY6N1qMTPpOb1/1GsugmutjLgMFjVsL9jtdfwxsjZTaKahvjtsgLLadq
         0+X7cbH+Qy/Yz4wsoZ0447YfaADwBlEyasgnkpQsWdHwOJ7yTIKGa3BBXP+JQ9K3Lraw
         bn7g==
X-Gm-Message-State: APjAAAW2h3zszvXCWlqO4LP3r9lT/CUljvzGtHr5/A1JAQ1T3ARhzkep
        IT9sczuCCTZMgW/zFiOiimQlUQ==
X-Google-Smtp-Source: APXvYqymArKhOXlsUJI+sJmVq0/SoBQOToYBm5aE+7kMNeRDvzhEE0tq8mcjkbbNZIgAEHyF3ePxZA==
X-Received: by 2002:a63:ec52:: with SMTP id r18mr31698670pgj.128.1569945704953;
        Tue, 01 Oct 2019 09:01:44 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id v4sm15064179pff.181.2019.10.01.09.01.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 09:01:44 -0700 (PDT)
Subject: Re: [PATCH] ionic: select CONFIG_NET_DEVLINK
To:     Arnd Bergmann <arnd@arndb.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191001142151.1206987-1-arnd@arndb.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <57c673d8-a1f2-e759-7a7d-3cbf9b370d55@pensando.io>
Date:   Tue, 1 Oct 2019 09:01:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001142151.1206987-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/19 7:21 AM, Arnd Bergmann wrote:
> When no other driver selects the devlink library code, ionic
> produces a link failure:
>
> drivers/net/ethernet/pensando/ionic/ionic_devlink.o: In function `ionic_devlink_alloc':
> ionic_devlink.c:(.text+0xd): undefined reference to `devlink_alloc'
> drivers/net/ethernet/pensando/ionic/ionic_devlink.o: In function `ionic_devlink_register':
> ionic_devlink.c:(.text+0x71): undefined reference to `devlink_register'
>
> Add the same 'select' statement that the other drivers use here.
>
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/pensando/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
> index bd0583e409df..d25b88f53de4 100644
> --- a/drivers/net/ethernet/pensando/Kconfig
> +++ b/drivers/net/ethernet/pensando/Kconfig
> @@ -20,6 +20,7 @@ if NET_VENDOR_PENSANDO
>   config IONIC
>   	tristate "Pensando Ethernet IONIC Support"
>   	depends on 64BIT && PCI
> +	select NET_DEVLINK
>   	help
>   	  This enables the support for the Pensando family of Ethernet
>   	  adapters.  More specific information on this driver can be

Thanks!

Acked-by: Shannon Nelson <snelson@pensando.io>

