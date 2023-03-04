Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28F86AA90D
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 11:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjCDKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 05:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCDKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 05:00:14 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD0E1C7C3;
        Sat,  4 Mar 2023 02:00:09 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p20so5201099plw.13;
        Sat, 04 Mar 2023 02:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677924009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Osgh48C4KnLfAsi4B8h3TeoDTNi6JcyLO4dX+82DIss=;
        b=qL+5vVkGpZdEireGkhPsYww/RsdL7mHmQQCHHuHjz8CSUm1r3iujJq0ZwIhAj4py7+
         ygoPJN8ohHOBG+HeYt28/iYodvVE7Wj+fYmS33wX617IqW1hd0WejUCNRLQd7KoQzzYF
         GBDjjmlctTMhTxcuvvzOLOjwIowPL/lakmhC47jZMNEVXah21h6XFNUegyY/kVEpPlWk
         M0vQvfEIl5MQS5i87iGapXSD7DZw6Aij43dsJvSc/TWiKdb/csacibgsBQxFJY1zTPxF
         IXIDeVKzG1WRzIEnOniBDQRIDKpuZGON+MNNF4MHSRo4IWosGYtzs/BQphe3bTKIJ4Xr
         e+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677924009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Osgh48C4KnLfAsi4B8h3TeoDTNi6JcyLO4dX+82DIss=;
        b=Al3IG+u8nyUMUyATRmCCpjSuvj0M9OrpxqnluCv29wufeNcGyFe1EGH7bbj02/dZ4Q
         PuD0ZiwTcSEWl3tfrfcq2i0HoOSEmTJI7ZL7AuQH1Nt+/VWQ3gKjpl1cwtT1J9i9693v
         KxImWN4TuEecD21BsrRfVpE8FqJH/Je777+rJ7776fjWY9cPUonEGRvplzGltONZvPrI
         kRX8PAHIEpiyKbd2Vm5lliLF2TD86d802YY7+ZI//ZgKveugpVL6Zc9BuqvtweZcrOdX
         UtP014iyF5L6/rU5xLrxn9RfJAxCUzTH54EFWB2NJwUjYmEDE9Gkx1JMnsnfq4ORFg9y
         iY/Q==
X-Gm-Message-State: AO0yUKWWfrCV1wYFezOH1jnN8A178ZvNwEaB/fgtwB5bNFyixitbjbIO
        fecBxjlWDsNqcd1hTleEyKl4pd9pv1W6+A==
X-Google-Smtp-Source: AK7set+rXOuLqCSiww8Kj5UYsgdcmDlG2Q4gggWLA18NFWgxo93C9kEBRCi3aDCg5D5B+tT9SSving==
X-Received: by 2002:a17:902:bb90:b0:19c:dbce:dce4 with SMTP id m16-20020a170902bb9000b0019cdbcedce4mr4229627pls.15.1677924009170;
        Sat, 04 Mar 2023 02:00:09 -0800 (PST)
Received: from [192.168.1.2] ([218.150.75.42])
        by smtp.gmail.com with ESMTPSA id b2-20020a170903228200b001994a0f3380sm2952808plh.265.2023.03.04.02.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 02:00:08 -0800 (PST)
Message-ID: <144f843a-a5d5-4d2b-6d8e-6dfb064cbeba@gmail.com>
Date:   Sat, 4 Mar 2023 19:00:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/2] r8152: allow firmwares with NCM support
To:     gregkh@linuxfoundation.org,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
References: <20230106160739.100708-1-bjorn@mork.no>
Content-Language: en-US
From:   Juhyung Park <qkrwngud825@gmail.com>
In-Reply-To: <20230106160739.100708-1-bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

Can we have this series backported to all applicable stable kernels?
+and future fixes:
commit 0d4cda805a18 ("r8152: avoid to change cfg for all devices")
commit 95a4c1d617b9 ("r8152: remove rtl_vendor_mode function")

RTL8156 (2.5Gbe) is supported by r8152, but wasn't blacklisted in 
cdc_ether.c due to having a different product ID (0x8156).

Some RTL8156 users are stuck with using the cdc_ncm driver prior to this 
patch series, which results in a far less ideal experience [1].

As we (finally) have a proper fix implemented thanks to Bjørn, it seems 
to make more than enough sense to backport this to stable kernels.

I'm personally running v6.1 with this applied.

Thanks, regards

[1] 
https://lore.kernel.org/netdev/CAO3ALPzKEStzf5-mgSLJ_jsCSbRq_2JzZ6de2rXuETV5RC-V8w@mail.gmail.com/

On 1/7/23 01:07, Bjørn Mork wrote:
> Some device and firmware combinations with NCM support will
> end up using the cdc_ncm driver by default.  This is sub-
> optimal for the same reasons we've previously accepted the
> blacklist hack in cdc_ether.
> 
> The recent support for subclassing the generic USB device
> driver allows us to create a very slim driver with the same
> functionality.  This patch set uses that to implement a
> device specific configuration default which is independent
> of any USB interface drivers.  This means that it works
> equally whether the device initially ends up in NCM or ECM
> mode, without depending on any code in the respective class
> drivers.
> 
> Bjørn Mork (2):
>    r8152: add USB device driver for config selection
>    cdc_ether: no need to blacklist any r8152 devices
> 
>   drivers/net/usb/cdc_ether.c | 114 ------------------------------------
>   drivers/net/usb/r8152.c     | 113 +++++++++++++++++++++++++----------
>   2 files changed, 81 insertions(+), 146 deletions(-)
> 
