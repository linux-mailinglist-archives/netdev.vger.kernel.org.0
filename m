Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32B65E6A91
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiIVSUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIVSUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:20:45 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F84DFFA41
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:20:42 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id g12so6921573qts.1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+bVdIPyub7QJLNcML2N1oFYnPmpBScskp1wVGOlutz0=;
        b=kIl1Cc8wOucGcoSZLgs3dwKRfWjPJM3H95o/clkrIp2KxjA5P94MIfQrq9lEVpOqdC
         hiRvq+DYyI9xk+HRKLQ0m7aJHFu8nhXpV7LUqUnY9sBymx3NPcfp1XuNhxjDofi4Mk0h
         xq0DkakA5SfRA2TulSrlObmVHeEhOxtYYaZ3ii+k41zb+IxT2/tZ52Bmz9UPZ1QqLncV
         Msl1zkCeKR36kiP6DG1cPz3UevE7LjaOqqwPisYKBY/0n1cEUdXZghAtw4ct4N1H05G8
         MgYhS6XK8TZQrAqiTWvsVGGN42l6ez/ibHX7liKEFmGOwvu2rQ7+B7Va/34a5Lv4hnYc
         DjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+bVdIPyub7QJLNcML2N1oFYnPmpBScskp1wVGOlutz0=;
        b=JvHIuRvlrSiKfQKzJYdijoA0iSDWldAsZ6k8fcZ3GsgrCL4wt6shk1GCDifDQVrMDm
         dBUsh/UvImYIyH9ddApVMFyrpuT4yLCQKdizKlsx6vEgGwwrYII6C6IEimZ1izuY1Ioz
         yGHtH34M+hOJlsUt5oFiuO8cIPPY04PV2utdKpAw3BWJmu3BywsZWiy2l8P8fBexXKXv
         9/0a/wfPXRAqWHVwYRAhXa+fLKO0h5+9rkC7ewtzgq5L8YiPzx71Xt4+jE3McizCJbKC
         M0RR47KAeSiPfFzcOxY7iCeP42fLbH3biY/UwXlmBF4ONuO4UQtZZKgPpRhT3diNBzDc
         R3ug==
X-Gm-Message-State: ACrzQf1FUmQh82IYm/k+QadiFf+suE7wm6p3vyP2chUSray+wv8WKPdq
        XUgUIn8E4qP12CHdonILiNA=
X-Google-Smtp-Source: AMsMyM4vOC4BXxK5vOgvo/qj9sizncOOrYNOaBbcxL6DqAYGvTLGEvrkIIE5AhEdu7NIKOutKiwi3Q==
X-Received: by 2002:ac8:7c46:0:b0:35d:147c:38ff with SMTP id o6-20020ac87c46000000b0035d147c38ffmr3302398qtv.1.1663870841831;
        Thu, 22 Sep 2022 11:20:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f4-20020a05620a280400b006ce0733caebsm4525323qkp.14.2022.09.22.11.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 11:20:41 -0700 (PDT)
Message-ID: <d7d644f3-88b4-befa-db33-f9cda6220e4f@gmail.com>
Date:   Thu, 22 Sep 2022 11:20:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 03/18] net: dsa: loop: remove unnecessary
 dev_set_drvdata()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        kurt@linutronix.de, hauke@hauke-m.de, Woojung.Huh@microchip.com,
        sean.wang@mediatek.com, linus.walleij@linaro.org,
        clement.leger@bootlin.com, george.mccollister@gmail.com
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
 <20220921140524.3831101-4-yangyingliang@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220921140524.3831101-4-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/22 07:05, Yang Yingliang wrote:
> Remove unnecessary dev_set_drvdata() in ->remove(), the driver_data will
> be set to NULL in device_unbind_cleanup() after calling ->remove().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
