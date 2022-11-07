Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAEC61FFB2
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiKGUn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiKGUnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:43:24 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC188B01;
        Mon,  7 Nov 2022 12:43:21 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id l15so7614224qtv.4;
        Mon, 07 Nov 2022 12:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XNI93Uik6up1/IAcpo+3Mp827uzXJuGRtoGZTDpioz4=;
        b=cXk8LMrE/ZXZtyJAVLqUUxkIcI7zWRd0YrH4Qz/5lu0n/D81CnpLu0rWxfEcHs2/x3
         5oGAm2rpI5ScumDiqr29Fy4lt/zasoB4R30XvAqGg5q+cuXHk3dFLA0gzC+HZJ+wOHby
         Uaa7Nta96XxeUbD1t4N/bUhlLq6ZUrRwhsnahbesHH0EjdPDi6PcycdmrOHNF5Y1jiay
         9kBKPL/R2n0jbdVwvmLtF3p0JfLnSyilZbIVZ6PTGf4PfhGNVvRFVfiuTgUPvcgh9foR
         XbgNiU7VwFNjt4nMU7IbAyvW53C4+Ga4GVAlepA1DEXOdlby2qq0gOdSQlc9iJuV3Yvu
         F10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNI93Uik6up1/IAcpo+3Mp827uzXJuGRtoGZTDpioz4=;
        b=kSYL57x0TliTNc9DkQa50h3iqNNDlihe3kAE1hIvxhJO0U8bwr3GjyyvCRExhabuXL
         ouIWh5lgYQS0xFhyCGzARDFAjNUbOkpxdqJk8oe/FfF5IsUS84f1QkzqWzJVe6lMV0x2
         Ylqv/JWqXfmkElDtaoCrniT9k5d1QUyM0RPLWv2doeQUQQ9LNOLbgQXCRKn2YJEd+eHh
         vaORhHse76fpCuEjqQUwfKnf8r2NUUEpftnQj9VYYTkGkW+zI7vK5UQobKXKJPctPT5u
         tguDBhYiTexrp5UosPvA1UHLtQRN+lGvpQWk/jfWWbB+gMywBfBcMTb3wvdHQyNh+oyK
         F+Ng==
X-Gm-Message-State: ANoB5pm45QJENdwS3cLepxEly003GjoUaUqCBjmadGUvE1+0kfSg1Zf/
        RiHvAvdTpqtdIvN/K3mXCVU=
X-Google-Smtp-Source: AA0mqf7svaSZ4olynhxSTPr3W4cKBKV5EipCkuzOl1GfLTclkqgXoU91MRjlSKR+bLdsyD6vbadjDA==
X-Received: by 2002:ac8:7393:0:b0:3a5:91dd:a686 with SMTP id t19-20020ac87393000000b003a591dda686mr4280040qtp.423.1667853800781;
        Mon, 07 Nov 2022 12:43:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n8-20020ac85a08000000b0039492d503cdsm6893115qta.51.2022.11.07.12.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 12:43:20 -0800 (PST)
Message-ID: <5e4b19ca-fafe-dcda-332f-1c400c91b0a6@gmail.com>
Date:   Mon, 7 Nov 2022 12:43:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net: broadcom: Fix BCMGENET Kconfig
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221105090245.8508-1-yuehaibing@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221105090245.8508-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/22 02:02, YueHaibing wrote:
> While BCMGENET select BROADCOM_PHY as y, but PTP_1588_CLOCK_OPTIONAL is m,
> kconfig warning and build errors:
> 
> WARNING: unmet direct dependencies detected for BROADCOM_PHY
>    Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
>    Selected by [y]:
>    - BCMGENET [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && HAS_IOMEM [=y] && ARCH_BCM2835 [=y]
> 
> drivers/net/phy/broadcom.o: In function `bcm54xx_suspend':
> broadcom.c:(.text+0x6ac): undefined reference to `bcm_ptp_stop'
> drivers/net/phy/broadcom.o: In function `bcm54xx_phy_probe':
> broadcom.c:(.text+0x784): undefined reference to `bcm_ptp_probe'
> drivers/net/phy/broadcom.o: In function `bcm54xx_config_init':
> broadcom.c:(.text+0xd4c): undefined reference to `bcm_ptp_config_init'
> 
> Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@broadcom.com>

Thanks
-- 
Florian

