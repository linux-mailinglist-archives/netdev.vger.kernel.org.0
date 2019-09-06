Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86EEAABCAA
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404903AbfIFPgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:36:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34061 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404801AbfIFPgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:36:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id r12so4761473pfh.1
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 08:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=HpjEWsWBbxV4+yzrMPtf/mM7e0LTvbXiTW1Tj/dUZfQ=;
        b=cI9wCRY/+Zs4kwkoG8G6ewDFIMjERMpaVUNWJndg2lLdw/vbiaHM50YzqNm/erXVcL
         VuoQULwl8ySyMXiHkiC1KNseoTxGP0pk7QLaYEC4CJ+AFbvJxkoFT7ty73DeWMtgl8t8
         osmIHlTw376akMu8IOoUET4m7PbVo/9YZPh6k3WGI/GFzosqf8X6HSuORCYbpd5udMxv
         vmkIjipT9Oz3Cj/a+YUtvfsLzGpUznCtmXQWWX7ovgJR1+ri/OxNWv5Pwvr3K6+x8tLg
         SIIcwTHiBxppkx2+QHgSJ1zoLJqpNIxJaXsiyxIGkhTV8TWVkBBVltqLWsxAaAcmiIlB
         RieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HpjEWsWBbxV4+yzrMPtf/mM7e0LTvbXiTW1Tj/dUZfQ=;
        b=VAkTXVsL3V1poFRx5rvHF//1k3kquq+VnODGh7bpg4BB3HXP8cPvrHQmpW7amVCscQ
         LpwWsz56D0beTrgHQatQzqodN953xmJ8z+IbC/CvoOOWSJNLAe+PQU2BxT0sWCt9Te8m
         4egqCYw6zvQMMKYcPCZBa2DieBuFN+gA/Ll/VYlhQnqGT3uDLdsBgsDrkLUdOE5MmeOl
         Pd4/jbLrQX3OsZk0sdmSolJo3BA1OHCpuVbVWsM7AODv0yXFiRh/3886LGGJDaUsl74i
         Ibzjoips18V3Po4U4fhdzI3qbZKTH6nddW0KxqdJD7qhjXfO4Xo3+k5jfDYsqEzZSgSM
         aQVg==
X-Gm-Message-State: APjAAAV3nFp4L23RI2M08vKcICo8SZ7lCRIArQ5f78a/TxhVqonyp3ge
        q2LBTpH1bYag++vxUX742QoY6g==
X-Google-Smtp-Source: APXvYqzY2AzbiTR6TecAkR9TlFGCfaBVlv/TcplEgRsaAi8ZTZk4Zr61REn7DjEbXjlq7t4rD8KlDg==
X-Received: by 2002:a63:dd16:: with SMTP id t22mr8516756pgg.140.1567784181828;
        Fri, 06 Sep 2019 08:36:21 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k14sm4817415pgi.20.2019.09.06.08.36.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:36:21 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: Remove unused including <linux/version.h>
To:     YueHaibing <yuehaibing@huawei.com>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190906095410.107596-1-yuehaibing@huawei.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3556b355-0cd5-ed28-8821-525d24197d07@pensando.io>
Date:   Fri, 6 Sep 2019 08:36:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906095410.107596-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/6/19 2:54 AM, YueHaibing wrote:
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/ethernet/pensando/ionic/ionic_main.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 5ec67f3f1853..15e432386b35 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -2,7 +2,6 @@
>   /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>   
>   #include <linux/module.h>
> -#include <linux/version.h>
>   #include <linux/netdevice.h>
>   #include <linux/utsname.h>
>
>

Acked-by: Shannon Nelson <snelson@pensando.io>

